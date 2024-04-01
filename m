Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5C0446D5;
	Mon,  1 Apr 2024 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988730; cv=none; b=DVz3MpRzEq33VIYh+A0ujUmp6cy49d+vT2kvm7XI1UP6yfBcL0jig9UsNOJRHMyD5j4mi6Mahr988cz4dkePa5VIsU63xPEdgRhNqi00T0hrXKswrwwvTbEbD90E5aEigUv8MJGAHlD7VJzKyRnByFiFJ0TB9NU32PTLm6YIbPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988730; c=relaxed/simple;
	bh=A8dlAxkbytLO6vjY6asrlH5zHT9fufMxjDnlSdm9sqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNuV+B0+5a5qODZ4RFK654DgdkINEvFQeJSyYNWHbsuMPv7O5g/ZJEgfXB5LC46ICubm3mz1mAzN5a4k8VWGo/Xp/hwP31ZZaUFy5JUXRJNMlzxQCnfOn2ousG6y1vlZuLvz+jcl9GwLK/r4GSOEx1cvu45ipHXb5JPyhOYcK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFX8toVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFX8toVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD292C433F1;
	Mon,  1 Apr 2024 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988730;
	bh=A8dlAxkbytLO6vjY6asrlH5zHT9fufMxjDnlSdm9sqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFX8toVhcvlGi2RqoOYx1LWPfVk+4k9GjZVeFfOYTHD4KEY6Q3tFIFxxMl9fzetcV
	 GvmO0jLxp+WNFVxJRaxReoggjre5iu9c8+sLgZwvlWjJ3VH6yFXtFV2GiqskRRh+XF
	 pqMghbZIPIcONz8EuRQtLePbJ7uMPvYQizd6dQdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.7 272/432] mei: me: add arrow lake point H DID
Date: Mon,  1 Apr 2024 17:44:19 +0200
Message-ID: <20240401152601.288907822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8436f25802ec028ac7254990893f3e01926d9b79 upstream.

Add Arrow Lake H device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -113,6 +113,7 @@
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
 #define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
+#define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -120,6 +120,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


