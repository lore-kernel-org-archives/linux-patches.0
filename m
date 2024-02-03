Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E7E101C1;
	Sat,  3 Feb 2024 04:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933401; cv=none; b=Q+TBne6lH582WTtI1n0ARyU2UpeA+uMW2jxZ7mwSLVuDVsTE3qEWwtuqznLmfSYTZCM9FPDrQoNIyiQCrO3AWmp03+l9jOWg70JqEAqhViJgemsfhBR+xbu46ExX3W6ARpupYhx8Ha3K3UmW1VE6cg559g6cS2mnipTKF9MZvkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933401; c=relaxed/simple;
	bh=nt9lmC/YR2BOOC5Hc4RcYflwuCd4Ue2YbQoQ+c/XV9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rioKiVReHgxRUpNFvX0TIZ8kS7KUt7Kokgg2Y+4kq/28kRUtRJA/NdIKnm8CFhqlGmfnHDV28WSQQqp59Cuh96XWgWUTQchcWCSpN5zSX8z6O9QdWsNhEB8fsGvHDYUYfqyx71qV7FiNHacGfOCUq92JSpzAriszV337hVaGcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMzsuLAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMzsuLAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F99DC433F1;
	Sat,  3 Feb 2024 04:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933401;
	bh=nt9lmC/YR2BOOC5Hc4RcYflwuCd4Ue2YbQoQ+c/XV9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMzsuLAOMWq24jDqn4mlCRiirgwPd5hkWxlSt5u94+I8hqLu3Z1jJVC+pfcttjwuA
	 qiMlUk+oA4rb7rDF8jVNJHpg5K050/2BHO51sZdXtGBa6cfvsv7bHMWs5cGncR1mjh
	 kHeImM7q7RvfskuHxE3BYPbcTKDD2uGibJ8JpzbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/219] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Fri,  2 Feb 2024 20:04:52 -0800
Message-ID: <20240203035334.270526533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 5ec42bf04d72fd6d0a6855810cc779e0ee31dfd7 ]

The PCI ID insertion follows the increasing order in the table, but
this hardware follows MTL (MeteorLake).

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b76ff0850618..73cc1e7dd15a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3000,6 +3000,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
-- 
2.43.0



