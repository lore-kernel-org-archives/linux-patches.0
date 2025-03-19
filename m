Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B61B2194;
	Wed, 19 Mar 2025 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395075; cv=none; b=dHkQvqCMdC1Iqo92C6gfS8RHNUgNaLMS63eR5ZqbQm3qHewTSkmNORIY1P+0NQDuVREpk/koLOOMA7uIjIhQfiVv9uMoy8vNWRpitqlcVM+wNMUssyfUi9cguJ7ibud1aTzcQDzCDFhAGilTxgjQj9RCMKLOFQdbVsndhlcoSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395075; c=relaxed/simple;
	bh=Q96V65U41jnOeqWW+lFJykpkByyIYNW2pHiSJbBz9jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0JRAAa5yg5MBCPBmkEBHnzQjog1IgNI8OTmRIt1/jeSrgXvhMNIAi+z72VNVRY5u6TXa7mKyJ4DgOfCg6Hex6gXuyK4fub9fVNe6kBDSg6zo4z8rhJbJXPhUGbu77X4u7Gngkeew0wpyRecW0Dm9xNlVZ496M/F0RQNuLOy/p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDNzC7LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDNzC7LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64A5C4CEE4;
	Wed, 19 Mar 2025 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395074;
	bh=Q96V65U41jnOeqWW+lFJykpkByyIYNW2pHiSJbBz9jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDNzC7LLq2yIbulnKfuTRBrDuNdlwocnwX/bUQX5H5vFjIxUyeeselfHV9EfKlZeL
	 HxCMbLwJLqS5/TMKNoR/YpbbTa2ERX0J11NRW/+1IIl9a0jgvVZp3fN+pkBQyEbYwk
	 74jpY4wksOJe21cnB95Q1/fKWcda1egu17dbKsjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/231] PCI: pci_ids: add INTEL_HDA_PTL_H
Date: Wed, 19 Mar 2025 07:30:06 -0700
Message-ID: <20250319143029.637001773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a1f7b7ff0e10ae574d388131596390157222f986 ]

Add Intel PTL-H audio Device ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 22f6b018cff8d..c9dc15355f1ba 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3133,6 +3133,7 @@
 #define PCI_DEVICE_ID_INTEL_HDA_LNL_P	0xa828
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 #define PCI_DEVICE_ID_INTEL_HDA_BMG	0xe2f7
+#define PCI_DEVICE_ID_INTEL_HDA_PTL_H	0xe328
 #define PCI_DEVICE_ID_INTEL_HDA_PTL	0xe428
 #define PCI_DEVICE_ID_INTEL_HDA_CML_R	0xf0c8
 #define PCI_DEVICE_ID_INTEL_HDA_RKL_S	0xf1c8
-- 
2.39.5



