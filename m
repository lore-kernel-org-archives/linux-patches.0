Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC51E525;
	Mon,  1 Apr 2024 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990053; cv=none; b=mhianUwlJRvAI9SwX9TZeaNkH2YCJ21FJAH6hT8AmBR/EKCZ90tEFDcpC6+jzZlx5SneT95KFQI9r9FpTcwrs+brbp3MnTHfNkFTW1ypwdbHtkU2dgJpheBNfjdpS+OkljoNc/TTUjQGQh/aWtMmXCB5m3QzNJmR8RqyG25KJxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990053; c=relaxed/simple;
	bh=G5fU56mK7602vGGgYDCb69AsGqndRFRZaBCtiebAo7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHf6DIkli4rbGjDtCLS9f9FLIglCRNF/xCo6WDZOsmf1QllU9Yct3YAzu5fTc/tvB7ZQw2dotVX9h5ochYPf0a9pRF4NrD2Egid25UZw5r7x7K/4LmA82yEQ10mG1QlAgAHlD4R74O1pTSURCKmyFP4gOBojF0BSxFxAtzmBamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PirnhBKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PirnhBKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41493C433C7;
	Mon,  1 Apr 2024 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990053;
	bh=G5fU56mK7602vGGgYDCb69AsGqndRFRZaBCtiebAo7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PirnhBKA33Q4YF7cvwt3PEzufKCV6ZJiE928lnBqtpTDXFyX3kpiQS+uYIzneZwcM
	 EYMSORgCDiqF5yokA6knRFCl9TyS9AB+faJXm9Ii78uz7US27qLYh26b8Dj3KgJJzo
	 GuXHAb1b0VmfPvjbC7po6rHWKDnYeE1OitMfIqm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.6 232/396] mei: me: add arrow lake point H DID
Date: Mon,  1 Apr 2024 17:44:41 +0200
Message-ID: <20240401152554.833679965@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


