Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892DB7BB18;
	Wed, 21 Feb 2024 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524305; cv=none; b=QHzRtmFzC0NBe/1wLtlRbhG2DvYgIBgodAOUjf4zZXdDdFCAt7RFux2sMt7E74nltvufSV9c8QllA2i0j4M5kyioWyCSLju9RNY2wsQgPucr2V5JUVBp8mX5ovmTC6dPhKM42nkclPmjJhe79t6xiwNpOEgt/G/DLq/PvoDAGSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524305; c=relaxed/simple;
	bh=tMMvAy3h/5fRrY+CfLwu+4zUhM8k5bUhEMIwXRjXYVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KcwOwLsGfLOao7xA/7tV+6WmkkDzDg49X6zyAv7j+8mvOcwGW8YnqIY3hpUWUKA5wyAaR6Q++oV8CMG/euJ2Hr97xi1mg1WHCUAkkKTLawEdNXmi2r4+ZOXAkeDjb4GCbpd8JjFjTVKfEUKlf0mCboQ+64/Mg0yyL1EmNiLhoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbqbWHWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbqbWHWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B972C433C7;
	Wed, 21 Feb 2024 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524305;
	bh=tMMvAy3h/5fRrY+CfLwu+4zUhM8k5bUhEMIwXRjXYVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbqbWHWVn7s/DFCbZ7mbySQbyZSsCBvz54kMNRCqHgf57DSQuaXKQhsXoqFfWvfub
	 qZbPhN04pSy370Pdii4mPv0egnDk7woVeyrIWAEN3/PPEwi/zxwh1MSesOvKzHCNE5
	 AtlANtPzrp4ACetYjl6qDwHfteEkkoUaArS/9UJM=
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
Subject: [PATCH 5.10 187/379] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Wed, 21 Feb 2024 14:06:06 +0100
Message-ID: <20240221130000.441267270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1a41147b22e8..80744a7b5e33 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3020,6 +3020,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
-- 
2.43.0



