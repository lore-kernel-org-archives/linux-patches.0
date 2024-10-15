Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEA11C57B1;
	Tue, 15 Oct 2024 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993849; cv=none; b=SKBHFUddrJgbkOyjzx4BmV3eTfwwAVykBY6RbhVpjNlc+Ea7Ohy9t4yrfNxNFu2ljkkH4n1xADwn9D0JYR5i2TrJI4xEet8nu6uGmT8hznqTUHt6eZryCDoni59HdKW3C75mAvZ+eXQ9EQ+CTYfcPFH7Tdk9LlH9EcloQToCmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993849; c=relaxed/simple;
	bh=kaLDUmZzMagFBeSWL2mOoeFjvVQdglBceOQsqDkfebE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg8rha2qE64QZqgUyyxE9LdnX1gDwQ+Qnv8HtvqOEmAjpzU2YcZMBWOFqnHo2K9UkzoifgL8fSF4x79u8qmaiSI3KE1HEzEvpfqxQzG/pxftabDfWtw1aYvE1A5ryJ//u+x+JCwk3tNq9FJP2e5g+bE4A+CWpAd56poJCxdcw9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKxZCNC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKxZCNC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48EBC4CEC6;
	Tue, 15 Oct 2024 12:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993849;
	bh=kaLDUmZzMagFBeSWL2mOoeFjvVQdglBceOQsqDkfebE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKxZCNC2C1t4zwycdbjQ2JxN5TiZrIsOrR3GRTNP/aye+dd4bzm9yFAKKkOsTwqPg
	 jvgu7wzaY6DlDhajNHutPJSR0vM5f1ZoiXjjhh/vNd+zuGCtRaib2WmxTavvmzM7r2
	 aUO3zHAkY1i7B49xuVYsr1Ex+LFn+EbnjVDaCbrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 517/691] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Tue, 15 Oct 2024 13:27:45 +0200
Message-ID: <20241015112500.864994256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -210,6 +210,11 @@ config GENERIC_HWEIGHT
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


