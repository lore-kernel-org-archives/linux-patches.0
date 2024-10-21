Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD61EF099;
	Mon, 21 Oct 2024 10:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507130; cv=none; b=pPlIQG5gFsWE4Xvq9E8c+GQ3jb1Vp2Cd1p+6tqFJsKRIy9G8/TWKMRnEvh5MziwNomF1h0QZn3mqyNKzW6dmZ/dGPbbNY9fpEl3WFseV0cY/A7H2qFu8pD4DB06NMhdAL58QNuPw4adVfw5BUEjS47Egjms+jBn9a9wA/gtnSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507130; c=relaxed/simple;
	bh=Tzyd52wjQgO5nqrirDLWZQfi6KGX0WQab+9HML/eQ4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfyitBXWsrURlbh9DfsvYyWlKOizYNfyf8On9HPKEt9Nl/nY/kQcEtMiAkkkns/KQ2MK0BAMNTks8E4XH+SZ2hdxOT1H1P4mxQGQWN1v3YTtdnj+rIqmHdfVeagHlI6bI/qssHCYuZLaseHs3GWrq9qCTSXSZEK+AI6iH37Hcek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0XYYN6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0XYYN6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8FEC4CEC3;
	Mon, 21 Oct 2024 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507129;
	bh=Tzyd52wjQgO5nqrirDLWZQfi6KGX0WQab+9HML/eQ4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0XYYN6a4T+cqaVPys0vX1kz5bAYJuC8hlvb1rCD7qp9K43Fz+lm5ZJ7Id17IlJtf
	 1pEagtk+0qx7acqV6aZ3Ut+/F3JJZ1WDX8MEyogmWmq4FNxuhEzkvAeAR1QxSRl5Tr
	 eTL/HlifHrSQOMsDxhz2eVBNrOC7DNDLIo2ynacU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Thiery <heiko.thiery@gmail.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.6 100/124] misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for OTP device
Date: Mon, 21 Oct 2024 12:25:04 +0200
Message-ID: <20241021102300.591188624@linuxfoundation.org>
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

commit 2471787c1f0dae6721f60ab44be37460635d3732 upstream.

By using NVMEM_DEVID_AUTO we support more than 1 device and
automatically enumerate.

Fixes: 0969001569e4 ("misc: microchip: pci1xxxx: Add support to read and write into PCI1XXXX OTP via NVMEM sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20241007071120.9522-2-heiko.thiery@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
index d1cd4544c83c..a2ed477e0370 100644
--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
@@ -384,6 +384,7 @@ static int pci1xxxx_otp_eeprom_probe(struct auxiliary_device *aux_dev,
 
 	priv->nvmem_config_otp.type = NVMEM_TYPE_OTP;
 	priv->nvmem_config_otp.name = OTP_NAME;
+	priv->nvmem_config_otp.id = NVMEM_DEVID_AUTO;
 	priv->nvmem_config_otp.dev = &aux_dev->dev;
 	priv->nvmem_config_otp.owner = THIS_MODULE;
 	priv->nvmem_config_otp.reg_read = pci1xxxx_otp_read;
-- 
2.47.0



