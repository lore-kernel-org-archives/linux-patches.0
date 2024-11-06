Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69101DE8B4;
	Wed,  6 Nov 2024 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895400; cv=none; b=SRHoYfujtGuuXEQ4jl7VHCw8BcNb9tf9DRuiNhZnCE0VohifRIGc7BWl5/LxtAdSdwpUjA8Jj9qC5UHttXOWFpDTnMNkFvRfyoyvCkf+1KoRxSbbCSTGIgSr+/UXouSpDT2Xa5nfZh+667uSdnHpO5OTS00juVI73W2lAAizXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895400; c=relaxed/simple;
	bh=poe0ReoIWAmjIvIR/xHIIiNIbKHxNO9NwNez5Dd70KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWPQXThhlPlnH5mcNYaBdAvPCfT7wvyBDMmk4JdidsVe5zz7sEYRAmyvuMzawETDNH9ZcoRhnogf7gFO3edkXY3LYC+tSAX+xTypXZS2Q5XrcNz2aV77ZQ3vIQmF7zZgAe5xP9cpCaXcAPpdqn5Av+m7mkXcrG8G5BvRCOpR02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkaTRdy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkaTRdy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2FCC4CECD;
	Wed,  6 Nov 2024 12:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895400;
	bh=poe0ReoIWAmjIvIR/xHIIiNIbKHxNO9NwNez5Dd70KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkaTRdy00mA88Y4WYqDc7wZKKoSEBjFr7q+KpBTm9VXlKNpSSOnuhdVVa54Fsh3CP
	 C0oAof5Ct5ZMEWByYmigHIVn1FEtiDUNHUAb3VXCLGFTjcPSDvApSYzm0r78bogxXW
	 e8sE5Wyl5PVfiu22Yk8LepyNBZwlJ0QRUC/mA8+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 4.19 204/350] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Wed,  6 Nov 2024 13:02:12 +0100
Message-ID: <20241106120326.022133448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,6 +84,11 @@ config GENERIC_CSUM
 config GENERIC_HWEIGHT
 	def_bool y
 
+config ILLEGAL_POINTER_VALUE
+	hex
+	default 0 if 32BIT
+	default 0xdead000000000000 if 64BIT
+
 config PGTABLE_LEVELS
 	int
 	default 3 if 64BIT


