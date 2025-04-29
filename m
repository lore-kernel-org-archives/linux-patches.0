Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BD821A43D;
	Tue, 29 Apr 2025 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946067; cv=none; b=Prb6d3RonBTYL00z4jBsKDoFL4Km6eMbL03bbteyMfBgcXzngbnh5kDaGbcrVWtAt3i2sIZ94txnCiiAg+vSx5ClhGwUAWIR058BCzVyVaoMY2QvJnq7C3Il6rL3Tu/YI3BRhN1jJx0vBnJUXp1nG6ALjpyTbJV8Q3mbAqhKboQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946067; c=relaxed/simple;
	bh=GNwMDE5AtAoCfGiiQOJZ+DoSo4gOdBPbug7qG3me/ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdqCi4QG+5X2jonEv9bE1a2AvamBBN8QncQrWkavxOC0PKHiJMyu6CYOKmN2VYQqw2M6Dftywnm0wh3iuFSzEJ0GdicvHDYmdHmqkZHh2kfYFs//k4T+rVamGAwgEf0MYIJ6Jyx/FRsBQoGGY2OCW698/nHmHhZY8SMWPs20RqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcjqDgQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcjqDgQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE2CC4CEE9;
	Tue, 29 Apr 2025 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946067;
	bh=GNwMDE5AtAoCfGiiQOJZ+DoSo4gOdBPbug7qG3me/ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcjqDgQs0O71X/PLcHiMNJ7wuCTpAd3zh0b/mqfZAeo7QgDTckhWIc4J6iDxwIOk7
	 Ss3Lt2Nevj9YTE6QKhcjAjhJew3FaNGmnLZOZzKj6AmVb8meWQAE+qo9bx+ifVxYY0
	 Bl4P6331PUcm8UaC++Jg/T95K/B53M/J6U73GKzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.14 143/311] mei: me: add panther lake H DID
Date: Tue, 29 Apr 2025 18:39:40 +0200
Message-ID: <20250429161126.893126469@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 86ce5c0a1dec02e21b4c864b2bc0cc5880a2c13c upstream.

Add Panther Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250408130005.1358140-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,7 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
 /*
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -124,6 +124,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */


