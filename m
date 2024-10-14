Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FDA1AB6CC;
	Mon, 14 Oct 2024 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919308; cv=none; b=BbVD/XFc5JYRmTodB5TK9Yk1GhipGo1ptD5WrNBKKlxFZgfaJb2J+P7CGjxd3f/dJL/NcLOPNhUQ2i5T5Kz/j6Sf23HJfy0BhcZZ96pEjrMd6/FZ/awU0bZzkKHjaaY5mUzVNHRYR77+Fk/J688dQ/fJXCfyiFnLxAQFN5S4Eyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919308; c=relaxed/simple;
	bh=nioFBLkIqZCSe9Yb1NmPJ0FVdMs0myP0oulmU+W9K/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMoNuL4zww1mPZf5AkQkEJNuogJ5VA/NASQ8YwMH+SmEkZ8zm89ajU2OK4NF6TJiMWfKwRJdSXaC3OmXQb9Dc9ZvvHQzZe8LcxeXAaZM0+NcQAwUkXU6DhXe9foNUYceFbPPJ+A1FZPsUHi4Xsl+RetzERhToo74z12ozK8SsdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn0VBt3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn0VBt3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3FEC4CEC3;
	Mon, 14 Oct 2024 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919308;
	bh=nioFBLkIqZCSe9Yb1NmPJ0FVdMs0myP0oulmU+W9K/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn0VBt3P6+1PaVOg7qRcdPBbUHE/CLmOeS+k5qlj7cs+OtfUgODnV0RarmEN/5++w
	 5WatUtatYO43aqKL2ythQajMzdm0Zc0QQHG1Ami1NhKu++IzJnLumSwGh+UjG9sxAi
	 4GGHPnBnyGMyn4hjD9BWYwbKx+fWy6/WEap2svB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 573/798] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Mon, 14 Oct 2024 16:18:47 +0200
Message-ID: <20241014141240.513833176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,6 +216,11 @@ config GENERIC_HWEIGHT
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


