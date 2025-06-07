Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCA821ABDB;
	Sat,  7 Jun 2025 10:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291011; cv=none; b=FBnXzQGzxQlla2gHeCKEoZRaT4OXt4D13oUjLZ2b7ZeAs+ElwfFYoa6T0rzXd0aCGp3CsuD7zEepKF0DCE4dTcJD1GnCNwO2vVtShww2cH0J9AFd4sB9w6QWKeTiBHw87/GvJgIne5zZ/R8nc5/6DHlRgGhoEEpMwE8NkzIsSdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291011; c=relaxed/simple;
	bh=oFDPgtoP2NFyJ+Xt1s1hXvhBXNibhwSjUoxzJqodYNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXVxQYXNInxhUKMcwjov7fCQ673VirQEYlllymBHC4FU62jiV9wqrUnG/jHrY6tqhZQa9AYcstzZs+Yx3tOid3biK/rPRZv835+a443SK4R75Ol3XS1xVp00PKNav0xD4x0CN/X5IYARUrMTYfJDXkzeHngND3utLDFwXVXrbj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAU5gQe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAU5gQe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA44C4CEE4;
	Sat,  7 Jun 2025 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291010;
	bh=oFDPgtoP2NFyJ+Xt1s1hXvhBXNibhwSjUoxzJqodYNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAU5gQe1JSEQhbUz7patq48oWK8EyvPExn4P/NxpWQS4Zmw3FS4CQJ49ZRBvnDbuz
	 vD7jq8V9MGMK9b/oV0hMl6lr1n+rPUJ6EYKZ6V6z90rx3Gjeg6icqcdPyWhNYE0Mr9
	 QYd72EQ11232YkI9F1SAJI+nAgyXJcGm81p3USGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.14 16/24] nvmem: rmem: select CONFIG_CRC32
Date: Sat,  7 Jun 2025 12:07:56 +0200
Message-ID: <20250607100718.337428224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvmem/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index 8671b7c974b9..eceb3cdb421f 100644
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
-- 
2.49.0



