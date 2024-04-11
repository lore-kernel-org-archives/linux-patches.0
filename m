Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710B114A4C9;
	Thu, 11 Apr 2024 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831806; cv=none; b=rddPNHRI4fcQQVrMvYn8CUi0O0X9k3GcfM/Fk8tF9dL2b0kxtaS7jWMwI/btxYQu1FtYW9YMHYSt5QrwJy1yyRBj/xdWuPSBMQLQW/o+8GdV0v34AsrYdTyItisNOvcE1zRw5dEmipzCm72uAxrT2U4SQOeUz50D6wye9fmIJOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831806; c=relaxed/simple;
	bh=vOseH/gKgn7LQ3CtT5JOpu16i/cQfT8RzBwHQcsZCI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSsNglsgmqb/JrK3PfWwRTBfcTM4G6vKDCPYMX4mKgixhOMgnmCYOwLzgwtRGRoM5LYzudzvDuApizxj555tI+iYgg5Wy4VtrSWidNkLyBSltsz3Jbx9nlc0YqQ+HNoDdzR9ohgryW5M8fr10vE8uTTuyKrfB2gXJj6LiqqaPB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j35Q6mQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j35Q6mQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C752C433C7;
	Thu, 11 Apr 2024 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831805;
	bh=vOseH/gKgn7LQ3CtT5JOpu16i/cQfT8RzBwHQcsZCI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j35Q6mQEmyRZBWOBT/CPoi4i9C3u2rqqRISoJ5caBUPcHH7jYnSmTmfmdx6wkYH8w
	 uL4PHIB0oud2S1dHCZGJax8+5tYSukXJ/IlGigxnXVpb41yEQK2RyLl2d3CVb+c+rS
	 /fu3adHK/bkxmci8TG6Ad4+Pi/+575lWf9xQT6Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 131/294] mei: me: add arrow lake point H DID
Date: Thu, 11 Apr 2024 11:54:54 +0200
Message-ID: <20240411095439.603829159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -119,6 +119,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


