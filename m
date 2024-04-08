Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DACF7C086;
	Mon,  8 Apr 2024 13:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582305; cv=none; b=Ju/L47qY8v4hJ5vmZ3I6IYGDHSn/YCe8/9K1zdDap+kl4ZvfH+2pZA8IKqdUg3/i22lEBSlA7qDRLg0Cj9eIpCHeqTqdQIJoeZAfEjQ1Cp0yc0zGz8RFXY7ovGC+z0aFBs2KsUYiLjxq6iTLV46F7mswiFyMc6dWg72OJYRmhps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582305; c=relaxed/simple;
	bh=FpSLF5MZJCoCVO9PZPdj7xiZ9Q9IBeqpaaqmAadca8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBKfcJGECxXw7VPas7L3FDhNKb9f1ZSNMF2WNX45Gefb1upot+lyIo3YTp8HBCWZwOHVY1654p/gbOWekI2dwnKbIG/eeLdHRuAjwKMQqBOYpy+b5KLuG8rLJAY86JCuUrQjdFME38ESaqkWoZ2d1lgUNZurwXMfQ+lj8cBAzyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6uXB7Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6uXB7Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B5EC433F1;
	Mon,  8 Apr 2024 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582305;
	bh=FpSLF5MZJCoCVO9PZPdj7xiZ9Q9IBeqpaaqmAadca8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6uXB7TwsGCsaQW+yILhvP8Zt27W7v6tS86MQX7XbP8B/xjta1VeTCVjqhckV3YRa
	 Qf5mYVzFVwON70RjeoUGiWPdiiM091GXf+uaXRiYnyeyFvfx9WJY6lmNs16/pWY2Vg
	 MMbHwqg8Q3mjC6Z456htdzsPgkax2YsFcjc8JsgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 131/690] mei: me: add arrow lake point S DID
Date: Mon,  8 Apr 2024 14:49:57 +0200
Message-ID: <20240408125404.280998491@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 7a9b9012043e126f6d6f4683e67409312d1b707b upstream.

Add Arrow Lake S device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -112,6 +112,7 @@
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+#define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -118,6 +118,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


