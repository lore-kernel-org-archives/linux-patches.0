Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCC1E1337;
	Wed,  6 Nov 2024 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898254; cv=none; b=RRkwOSuoU7JcX8NtaK+SfICE3FCn8QCnbKdCDgwa2oI4ffiCw7ZyET/gutl9ZvSOhhlog1pk5iVpux7M8tQCtmBpu9u8nPHh1O4i7THTs3QOPUQ6qbmBNxhzTfKsfXhCfHmL+8hB1aBQ20kJFFlB/S38argBXXmbIn3MPBQ77EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898254; c=relaxed/simple;
	bh=cXvjuu5jIcQH3CwC/44zMQI0aTSpvQz5EpDRht553k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozTjgoKBBxK74Jq5h5KVHFDcGcqS3I48JG0WRrf8lD+RNK2kUk6yPOBi21O6Q/ElnI7mnTqeScwgiyi/L+mNQkTO4rU7pTYzF5gMkszYMjgiExtRp64pTUcgzLuxITaAqgikXWqP2c1yzWc1MLNzSPHjLlICBL5jBTkYXidjNjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9X3aQng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9X3aQng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDACC4CECD;
	Wed,  6 Nov 2024 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898254;
	bh=cXvjuu5jIcQH3CwC/44zMQI0aTSpvQz5EpDRht553k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9X3aQng9XxNXThAv/JdltxbD95FR/AmLNb6FLw/N97Ujoitf6pzTDFnhuhou/IzW
	 uJvwijQCRAiRBn7+1arwVmzvwucpuTQ/xH9iLDHmtt0TZew/G7tyijTppi4i1VUpEo
	 GMV00bd4aQfAzYJbVktfjI+f1dKAb4ZPFUCqeLpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/462] Minor fixes to the CAIF Transport drivers Kconfig file
Date: Wed,  6 Nov 2024 13:01:09 +0100
Message-ID: <20241106120335.865917790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: rd.dunlab@gmail.com <rd.dunlab@gmail.com>

[ Upstream commit 0f04f8ea62ce79f5a8bb1a7c2d92513799532239 ]

Minor fixes to the CAIF Transport drivers Kconfig file:

- end sentence with period
- capitalize CAIF acronym

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: addf89774e48 ("ieee802154: Fix build error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index 2b9a2f117113e..66ea15f067025 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -22,7 +22,7 @@ config CAIF_SPI_SLAVE
 	The CAIF Link layer SPI Protocol driver for Slave SPI interface.
 	This driver implements a platform driver to accommodate for a
 	platform specific SPI device. A sample CAIF SPI Platform device is
-	provided in Documentation/networking/caif/spi_porting.txt
+	provided in <file:Documentation/networking/caif/spi_porting.txt>.
 
 config CAIF_SPI_SYNC
 	bool "Next command and length in start of frame"
@@ -38,7 +38,7 @@ config CAIF_HSI
        depends on CAIF
        default n
        ---help---
-       The caif low level driver for CAIF over HSI.
+       The CAIF low level driver for CAIF over HSI.
        Be aware that if you enable this then you also need to
        enable a low-level HSI driver.
 
@@ -50,7 +50,7 @@ config CAIF_VIRTIO
 	select GENERIC_ALLOCATOR
 	default n
 	---help---
-	The caif driver for CAIF over Virtio.
+	The CAIF driver for CAIF over Virtio.
 
 if CAIF_VIRTIO
 source "drivers/vhost/Kconfig.vringh"
-- 
2.43.0



