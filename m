Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7411E47A5;
	Mon, 21 Oct 2024 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506849; cv=none; b=BGf4dX0hP71ug3zyUBM2KAG/zJhrhcvopa77G7fbL0CqA2iStMsnA9FzxD0+KIpdsq1iyBu1nhD4PVkpWjbwzBLIDEI79dK63km0VP9ngv/ndv8O7bTiYTyUdMQ+afjqk/sDCp3pu7l9Y7DrLAbJDaGYKKdlT7OibnvjFBWndY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506849; c=relaxed/simple;
	bh=Fwo670zhcbjx0v0zdxNJjeukL4u2AUdUPt+ds+l84W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1XHsQn4a7HNuWIZ1xLI3+gW6GcVyw7/+KzZrtrT8dL8Oj6iyPztWUDdl/8Av7lI5BPJzvomt7soIc0/bBO9uY9SsawvHi/CajIDmeg8EGJrjJlo2PW58VnZN+c9EF7aNAC6DTHY/Xy8q8OMry/Ri3g4kXl5fKrjRl6BhNaDzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8TGEIFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8TGEIFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920CBC4CEC3;
	Mon, 21 Oct 2024 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506849;
	bh=Fwo670zhcbjx0v0zdxNJjeukL4u2AUdUPt+ds+l84W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8TGEIFSguGOW8ia468EhM3m9cZYUvnjTr5Q4WgzRoIlIgP7QdxLjt2x69AGZptR6
	 MQVHyMHO7CFn2qb/MxaxgH1KZAEFQGh4j0Zym5FSnlMJq3R50F2B6R/f7CcGi+LkGI
	 0h1mFM9EcrtXVZqCBp8UjuHDdcbpGFx4x3pnfKS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Thiery <heiko.thiery@gmail.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.11 110/135] misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for EEPROM device
Date: Mon, 21 Oct 2024 12:24:26 +0200
Message-ID: <20241021102303.629388609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

From: Heiko Thiery <heiko.thiery@gmail.com>

commit 3c2d73de49be528276474c1a53f78b38ee11c1fa upstream.

By using NVMEM_DEVID_AUTO we support more than 1 device and
automatically enumerate.

Fixes: 9ab5465349c0 ("misc: microchip: pci1xxxx: Add support to read and write into PCI1XXXX EEPROM via NVMEM sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20241007071120.9522-1-heiko.thiery@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
@@ -364,6 +364,7 @@ static int pci1xxxx_otp_eeprom_probe(str
 	if (is_eeprom_responsive(priv)) {
 		priv->nvmem_config_eeprom.type = NVMEM_TYPE_EEPROM;
 		priv->nvmem_config_eeprom.name = EEPROM_NAME;
+		priv->nvmem_config_eeprom.id = NVMEM_DEVID_AUTO;
 		priv->nvmem_config_eeprom.dev = &aux_dev->dev;
 		priv->nvmem_config_eeprom.owner = THIS_MODULE;
 		priv->nvmem_config_eeprom.reg_read = pci1xxxx_eeprom_read;


