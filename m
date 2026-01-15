Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D68A3E9599;
	Thu, 15 Jan 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500046; cv=none; b=aiozqRGAsrYzVskopPsrnqbIxT/yuexn7zFwk/zcdm1dgdS+r9S/MIftugx9UTd6+yatoJgzaGaRNsz/KdI58dbViuK9RaiIwzBg7SDDAJCdSEU7LDV7G5PLVI1525XOzkL2dEdyxpOJZKECcgpN71CJkJnmBeX3YNqmS5aIFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500046; c=relaxed/simple;
	bh=8Ccalfc05MOKY7fco6xX/H9wl80vCYjIvif51R0mjcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUpBMJcN733Eqq8zDgsRNyrIB7hSvedCye5QHp9j67ci7A9Bkuu3Zf4wAE1QG+27lXJRckTx7UZQV/GqUJobRFHf8/bPJ/1Axznu6mBUv7oayLGjDF0B70HykltsIs4MAuO/bsar0UJRMEQVt4/KPujvcwmkpwvZ26HMzRmFxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aITLLtpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aITLLtpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8F1C19423;
	Thu, 15 Jan 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500046;
	bh=8Ccalfc05MOKY7fco6xX/H9wl80vCYjIvif51R0mjcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aITLLtpSwan24716tgkTVVMv/TQ2FkTv5TzK7EQxy8IMTVX2uOUEbGIpJpDXP3/+P
	 F2DHEuRn+ZU9lNgHmOYd+TvucJZWQWfcrRgLehkR6wqBobvZR+WS7e+5NOCqdgBbId
	 Uu1cZjTkkdLXYOMjJayE4i4CAQ61JCQI1vmDKI6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.10 412/451] mei: me: add nova lake point S DID
Date: Thu, 15 Jan 2026 17:50:13 +0100
Message-ID: <20260115164245.844244302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 420f423defcf6d0af2263d38da870ca4a20c0990 upstream.

Add Nova Lake S device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251215105915.1672659-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -122,6 +122,8 @@
 
 #define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
 
+#define MEI_DEV_ID_NVL_S      0x6E68  /* Nova Lake Point S */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -128,6 +128,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_NVL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


