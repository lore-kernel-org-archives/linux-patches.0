Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044F1F9413;
	Tue, 15 Oct 2024 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998150; cv=none; b=uJeK+jalmo1WDwO20lV8GuAtTPlQENla3CB97ocJtbf/f5XVzHUzknWotBsac07f8XGlsa45baRmHUI1445aVBIb+fVppOBDWTJ11F6S5SiGf+cu6dPFjBd+LUbfgUZwNhwCMfZaa8tm7bN61z1G3xFw6AOGZVAMnioPWCaAvnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998150; c=relaxed/simple;
	bh=kiGo6soc+ShokvsjTlUbDx0Tez0MqOJv7kKzqSn8BfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKuqofRUb7Hg9f8UsMaIlskIfV/PnzDtCe8BsQeDWIfNn8mCSXILviq+ToZipdPHr6ejnZEVTtkPFiVZcJ+pW1UOVltW71kTX5O6wWnQSHlflIagxX7UsctayEPSu2sHmRNzDDV7fgq6dkLoqMwlVMcUMcr+/wUXW0dGUSUr1WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kabIPU7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kabIPU7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D56C4CEC6;
	Tue, 15 Oct 2024 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998150;
	bh=kiGo6soc+ShokvsjTlUbDx0Tez0MqOJv7kKzqSn8BfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kabIPU7QJaZ9xnuCWdt8rd53oLJTcqR9QJ3mVllyFZawbPyhKNn03s7k4WLgVrzn/
	 7c+N/nut6Jaxk/7rmivcOHK2Rz33Ar0BdhN0jIrGN4c9N73FbTb7HiNqsq9LZXP9JW
	 rbcynWreKMZt5rwUKuEXECjbhMHOtia/1enEnGKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 393/518] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Tue, 15 Oct 2024 14:44:57 +0200
Message-ID: <20241015123932.145561147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -193,6 +193,11 @@ config GENERIC_HWEIGHT
 config FIX_EARLYCON_MEM
 	def_bool MMU
 
+config ILLEGAL_POINTER_VALUE
+	hex
+	default 0 if 32BIT
+	default 0xdead000000000000 if 64BIT
+
 config PGTABLE_LEVELS
 	int
 	default 3 if 64BIT


