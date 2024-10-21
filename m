Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E458D1EC001;
	Mon, 21 Oct 2024 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507127; cv=none; b=nqYMCZohVMT3ZAYSToL9ZBWHqPOSFdgwIrMfY4JJTsWkmZkN8UvTkaR4mBW5X6jHrRz61g5NRcx1mFZsuEOSNbRYFvK9av1UyzzTsLv2JG0z9bTlM0ukLGhSIEf9XF0dwQ8cimRJyzDGWmGz7NqvYZrlNWGMdhUffxHyVgX5exU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507127; c=relaxed/simple;
	bh=EZenF0rP618uFIoNVAZvxBH1h6CKfIOv0iiu9hePBgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egGhwBTz6s5jEfOJiw7tqkpkGXXcOsyM6MppKIs4Y2Jpu5AEP9vUUUdl1g9jtETvarXqcl3Mxrv1qFN00rcXQ8DwqE5O0A9G1I8NrO9A78xMldOHl6WUU42qyUe+Gxmm4YJEdFay5vuCf4mQczBll0GY6wDX+5Ahbu/89m1umGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpU08c7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpU08c7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F79C4CEC3;
	Mon, 21 Oct 2024 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507126;
	bh=EZenF0rP618uFIoNVAZvxBH1h6CKfIOv0iiu9hePBgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpU08c7xcZMH9k4sj+1BTPqOsmnNY8KZoHyG9fLqQw0NxhqcoZrhkc09E60lMl7Aa
	 vjPQOQrDcM6z5tySaUK1z7jAC9bNdbKjviNPsLKZc1zsP+BjSVVasd+mTJsmK8Wn+F
	 Td6soolZKoKp5NaON0B1weweEW0gq8pSQsumNPNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Thiery <heiko.thiery@gmail.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.6 099/124] misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for EEPROM device
Date: Mon, 21 Oct 2024 12:25:03 +0200
Message-ID: <20241021102300.552498622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
index 7c3d8bedf90b..d1cd4544c83c 100644
--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
@@ -364,6 +364,7 @@ static int pci1xxxx_otp_eeprom_probe(struct auxiliary_device *aux_dev,
 	if (is_eeprom_responsive(priv)) {
 		priv->nvmem_config_eeprom.type = NVMEM_TYPE_EEPROM;
 		priv->nvmem_config_eeprom.name = EEPROM_NAME;
+		priv->nvmem_config_eeprom.id = NVMEM_DEVID_AUTO;
 		priv->nvmem_config_eeprom.dev = &aux_dev->dev;
 		priv->nvmem_config_eeprom.owner = THIS_MODULE;
 		priv->nvmem_config_eeprom.reg_read = pci1xxxx_eeprom_read;
-- 
2.47.0



