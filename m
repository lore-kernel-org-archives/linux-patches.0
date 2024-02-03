Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5911119E;
	Sat,  3 Feb 2024 04:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933853; cv=none; b=OFrfP2wakJ4czqd0NAI+SPY5hO+ii3b4l90tH42eN8JaoGz3BnMsp+vy4LScBRsKQj7zNNr7aki9Ofra8epUEhKZazlD1f7zwWS2GDPnTdrbREOEjXjlxz2BNFzO+DSNxEQzB4vslpGLi5aaxzmC10YuiNC5Ez9svZLhSXSmpHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933853; c=relaxed/simple;
	bh=uh3aXaiw4yAKd5vcWgdOWn8LJU1lXwEyUo7z3u4gSuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0gHjslh740DF6Vhw59sjshNENTLdqHbzF0+Q6BJUw8dm0RW55XnIFdD2d8V40CNlXoe3MnimabvCd/Kr1TN1lmnVQwoqhQf+brnsjIw34gAbAHE8YsEL8zQYU6g9yvhSCUZ0krvqMD2ZXw2cLsfssxOV97smyUFXvK0xS2RARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUqoGw0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUqoGw0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B46C433F1;
	Sat,  3 Feb 2024 04:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933853;
	bh=uh3aXaiw4yAKd5vcWgdOWn8LJU1lXwEyUo7z3u4gSuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUqoGw0qP/vNNsvlLV29wYTxcj13fYUmTg4SZ7j2vv1jD4qS+0pJH8bCrTFPDEpWW
	 t11hgbCdR0/+XkNLEfe4rtDNkuX30W00RyejbUMD5obDaDyqNoXDMfwYOeU0VgrrrI
	 fEf4c7KofeOxhbnzaboIUKMq/uFoEIdQMBVvJDzQ=
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
Subject: [PATCH 6.7 184/353] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Fri,  2 Feb 2024 20:05:02 -0800
Message-ID: <20240203035409.467403200@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 275799b5f535..97cc0baad0f4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3065,6 +3065,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_HDA_RPL_S	0x7a50
 #define PCI_DEVICE_ID_INTEL_HDA_ADL_S	0x7ad0
 #define PCI_DEVICE_ID_INTEL_HDA_MTL	0x7e28
-- 
2.43.0



