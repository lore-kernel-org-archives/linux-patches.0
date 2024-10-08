Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B61DDC35;
	Tue,  8 Oct 2024 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392491; cv=none; b=d+vRviG3d5U2LLPMLI0+IvJTDHr/CIBgry1lrtuvTDX6Upuf3/Sypfsm7oCr7q78iLlWtEWciQzVdH6lnwsFe08t/pjT3C7Luh6fA5Bnev8LBm9/y2mb5L3aWpkLHXysSisYEqs6f6B6p3vSGH4Zi+sJlrRWa/yjEfO2kLLwfmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392491; c=relaxed/simple;
	bh=POCBnUxEJkzDdp55hvNbQQGdh5YQT39e+PqXN2zjAMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THYqFU+yxKGXayLchQlo3vXSZoW2M8vW6cAD9qvUKrskSUMiaPNBRLsKW0465h6JapDZCDq0wzgL5fE3/9xWrwG2px10FgkUGgPjTl7AyHZiV5PqC/Xg+rGzvcZ/Qd3TcOUVXV6Va6rtIMC8MHlRZiCOEOt8YAGUOriZb5T4Jd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygDq5HNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygDq5HNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D539C4CEC7;
	Tue,  8 Oct 2024 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392491;
	bh=POCBnUxEJkzDdp55hvNbQQGdh5YQT39e+PqXN2zjAMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygDq5HNPSSwWvTwGrwdPkJ5vI+HG8TEbuRTbz1he/JUvA3JhlQ3ij3NEIWCCxoCoL
	 WeMYnEXzw+oXWu11WaWrLRG3kxDrLLMn1VYhkgfsRjrSEMUVILnYPZXJA2D5S++omz
	 0R7p5eriOAopwoZTK/fBTnVxVq5WGLMrygq68BtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.11 430/558] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Tue,  8 Oct 2024 14:07:40 +0200
Message-ID: <20241008115719.193681211@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 5c178472af247c7b50f962495bb7462ba453b9fb upstream.

This is used in poison.h for poison pointer offset. Based on current
SV39, SV48 and SV57 vm layout, 0xdead000000000000 is a proper value
that is not mappable, this can avoid potentially turning an oops to
an expolit.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: fbe934d69eb7 ("RISC-V: Build Infrastructure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240705170210.3236-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -319,6 +319,11 @@ config GENERIC_HWEIGHT
 config FIX_EARLYCON_MEM
 	def_bool MMU
 
+config ILLEGAL_POINTER_VALUE
+	hex
+	default 0 if 32BIT
+	default 0xdead000000000000 if 64BIT
+
 config PGTABLE_LEVELS
 	int
 	default 5 if 64BIT


