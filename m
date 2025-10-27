Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D40202963;
	Mon, 27 Oct 2025 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592008; cv=none; b=Z0H3ZYcsxzLR3G2lqGuZ6L5Upmhrib1cCr7XAu6bEEtgHvHBDAWPc+RFhLsDDhFo1tIgmbSIhUhystKXOQqA9FC/LI7b7r+twx6sbp+YvFplmM1lzh5jpMTXxpkJZv09GVcpD/NhcSao8/++2aYAVTdFuyek7/6Q1vvFucVW0RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592008; c=relaxed/simple;
	bh=ZOM2z9W39qKvrFwI82hvWHObM9m79+ttokadAXA2G4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP/2GyHqzcu1wa4DpvTG03jmt7N6L/SCg+FePjZIXtlbW+fBTfS4r7EDKf42d45S9cyov0XDEitkf2ISo6Sw9TADYvXeUQ07hJdDYsZOs/R5p8ZrImWeYa+qZD5rWB4EY+Ns1F4oGbSzhD0TvPLYIePCNjki6fKhQhhxUof2ObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9CV3/k8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9CV3/k8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BC4C4CEF1;
	Mon, 27 Oct 2025 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592007;
	bh=ZOM2z9W39qKvrFwI82hvWHObM9m79+ttokadAXA2G4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9CV3/k84PzNLAGHtCFJO5Aj6UbjlIt6hGjxrgdC5HDJf5FAuxQlyRDmw7K/DR8qB
	 w3+7kfKV4vo2MujgxbfstDHtqPhOuFvibgJNxfGABHNf4qEvkmN1sFs8vnLxusqrU/
	 O0rCmVudCYtv+WDHwJfeUfyEMTVuSm2Tqaz2h6VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.15 083/123] mei: me: add wildcat lake P DID
Date: Mon, 27 Oct 2025 19:36:03 +0100
Message-ID: <20251027183448.611532630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -126,6 +126,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


