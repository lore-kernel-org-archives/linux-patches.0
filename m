Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1015D1;
	Sat,  7 Jun 2025 10:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291106; cv=none; b=f8+xgFnX/6EBSTx4+qZQifV1n7a7opkgHp24Dd3huCWOwI1znbZXANdlDhMORbLJoKi2DcUPA9U/rv+YFDD5aeL3D465+pkGH4RBTfCTI79emACUpUiQ/Ld6lG8mcLzvD4zDZOIzQcc3A0QUZBqOc+UKdYBglGSH1y9wvsVGQ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291106; c=relaxed/simple;
	bh=zsJK/belmyH6W7FQ6MXlZKYai+Jo/6ZTl6tb9pIEyls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOtAi5FXtnthbdFziv2MpK/NK57lpyZjXzOM7y526OnN7mEiy7VAns0ApTAfh1InKjzkjZFkOG0OiTQH0qUnE0X8EBkm3R6wLDfMWM7rqR17rXNxNh8ad0soC6GaB4wCxx4EZoHqN62SPfJWW08t+9L/oqkFnG06bp0LNDHZ3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k67uUmJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k67uUmJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB95C4CEE4;
	Sat,  7 Jun 2025 10:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291106;
	bh=zsJK/belmyH6W7FQ6MXlZKYai+Jo/6ZTl6tb9pIEyls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k67uUmJtNZwy6sCkDqH3Zf5Z7uOAxgGnvf8O8+Whg+GwHsyPr9sCBp12AcYpzXVsB
	 nPYwGN+8/pFhayJSxnaYqEPfuHElo4hdcScB9IRIJYudbQwCJFAAGjqGFEC3kmILkp
	 STlPtOiK4nOADm9YtXcfBGv4B2dmtgTIuQaebA0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.15 25/34] nvmem: rmem: select CONFIG_CRC32
Date: Sat,  7 Jun 2025 12:08:06 +0200
Message-ID: <20250607100720.699856172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 7a93add1d31f14e0b7e937163904dee1e864a9a8 upstream.

The newly added crc checking leads to a link failure if CRC32
itself is disabled:

x86_64-linux-ld: vmlinux.o: in function `rmem_eyeq5_checksum':
rmem.c:(.text+0x52341b): undefined reference to `crc32_le_arch'

Fixes: 7e606c311f70 ("nvmem: rmem: add CRC validation for Mobileye EyeQ5 NVMEM")
Cc: stable <stable@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250509122407.11763-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -260,6 +260,7 @@ config NVMEM_RCAR_EFUSE
 config NVMEM_RMEM
 	tristate "Reserved Memory Based Driver Support"
 	depends on HAS_IOMEM
+	select CRC32
 	help
 	  This driver maps reserved memory into an nvmem device. It might be
 	  useful to expose information left by firmware in memory.


