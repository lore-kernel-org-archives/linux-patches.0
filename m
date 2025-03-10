Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96A02253FE;
	Mon, 10 Mar 2025 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628175; cv=none; b=m0YtF7a6Z+GAg6b3Nun7SajmOgE12KbSedZMdq7jPkSGnTdsJDKuCW+FlOXd54LqLxTX1GQWM4y4eOsXoiwwu7uIHuYm2n2h8Hce2Nj0Qv1Qv8no6KmbOYyoCPktOPA5MFkxZ2hA3N6c/jVwX/QAhSl6RyF5W6kfNfgjUvFlYwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628175; c=relaxed/simple;
	bh=OJdCFfkqSeS7lTpoRvSOdmPbd7VY15b5IkVhlb3cY9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG9nmN7GgbotW+7W9r1zuM4l0tuU1n3WSdF3IIrMgYjQwnmArxHlMYEuDUBvLGhdCE+4gY8TP93NhF2AlVqYa7WDUqY+ClrDQK2cp0BrV+zf1KSxGHHjGqognxtnJWX49csIAaZZTb7fdFUT5qYCgaAYKsjsaorW7R/GuNM7f40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce4TjMNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce4TjMNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCEDC4CEE5;
	Mon, 10 Mar 2025 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628175;
	bh=OJdCFfkqSeS7lTpoRvSOdmPbd7VY15b5IkVhlb3cY9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ce4TjMNSyW73asEL+Q85sOey1J34/ON8z7SM0btVFmu4HbQwpHg9dQlxCse9AgmAR
	 ldEeX6Si9WpHgYoVTQAv9f5MV4/WQJX1f589zHd8AFnpeg0RQBnq2wMRqFQ6BEGrdK
	 tgcHFAE8EGygzxZuqcQpnx4l9lfgwpGsGE/EYC0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.6 114/145] mei: me: add panther lake P DID
Date: Mon, 10 Mar 2025 18:06:48 +0100
Message-ID: <20250310170439.361755561@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit a8e8ffcc3afce2ee5fb70162aeaef3f03573ee1e upstream.

Add Panther Lake P device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250209110550.1582982-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,8 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -124,6 +124,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


