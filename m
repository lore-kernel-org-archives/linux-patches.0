Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9A2D5C95;
	Mon, 27 Oct 2025 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593611; cv=none; b=V2yIc8EdgtaqRu7lr5FNvKSOJI7TrhDzDe9aPfCCrmyep/4ZEMfCBD2jM6yqyU82tBWSEhPqL+mQVWCKPTAnE0IYM7yTn0zX2L81ggTSxpuymjn5GAjYCdipA96nTsQZ0ddJZcSvTYCyaTmPO9rO7UKpRq4NeOJcsZ5Ow+54fqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593611; c=relaxed/simple;
	bh=Cmp3gLuDiIs7AKz7xFd0HPyHlh+yPp+RyxvT1wP083E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIIPXlE3z5FmenWZfg+Qm1Ng6i8ktp7Dv6wwf8FIq67WxTIjR6B3QIeyOD/oY0OPt9iFUmr9plhMjfjiEi+eVgIB8gBQ3z7d6SsO6HxHC6pc0SOc1ADtOswyp/dKJw/LXKT35n7dJs5Yl9fyGfOHcDnPjitiRQ5xbZCkw9D3oGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LctEKsoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LctEKsoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04D7C4CEF1;
	Mon, 27 Oct 2025 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593611;
	bh=Cmp3gLuDiIs7AKz7xFd0HPyHlh+yPp+RyxvT1wP083E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LctEKsoO+Nlh6KIPtel6MZamkhBtTmTFGAqqjeiDWEKU04w5b3Tts3+sf3A+lzo6W
	 stZbKw8QHJcGD6tDvIdgrZgf9r4iT+P/XQOjQboTc9u2p8JdMCqSQ+TXb7pZi2uJVC
	 yb3wRDaGVGNHtuqaVQTNwCj3z2bn+a3MNcJJ7cAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.17 159/184] mei: me: add wildcat lake P DID
Date: Mon, 27 Oct 2025 19:37:21 +0100
Message-ID: <20251027183519.208470160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 410d6c2ad4d1a88efa0acbb9966693725b564933 upstream.

Add Wildcat Lake P device id.

Cc: stable@vger.kernel.org
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251016125912.2146136-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -120,6 +120,8 @@
 #define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
+#define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -127,6 +127,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


