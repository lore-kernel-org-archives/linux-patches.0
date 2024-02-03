Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B5125C2;
	Sat,  3 Feb 2024 04:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933605; cv=none; b=BKFZlIuHYFlT7UNsZjXhStJXjBw0agQFfqxhkS+MehmzIS/xg176fSKVaDn2NkMfvhF08EvT6FLqDk/7xgxfb3JdprLwkdFR2kFvOg2TsPqoe/9+PsCgqihxZ51umJdFpN3Omiovn9seEGCJv8QGyH4LVAAP9gzU8TQWsyVnkXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933605; c=relaxed/simple;
	bh=uiqFp0ne/sudinAje1givjDO3fPArma+7a2ZZJu8YPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtQQE/pWto1XgEAWsWa+pWy/9mpkprAsyjgQASxuu0BCm0MmY96mNNJUn4ua9j7vOzJytLZOZMNV6eisCpjNi+7zaCgd2NZMLwDZxZK+i5SGoqM/8GCyR5DLTXrPrQ0fKOQNZNiH7ZY/jwnlSGA3oCweE0JfePvcDCm0DGgYZG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmITi/zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmITi/zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB97C43390;
	Sat,  3 Feb 2024 04:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933605;
	bh=uiqFp0ne/sudinAje1givjDO3fPArma+7a2ZZJu8YPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmITi/zJwxaTBCNQ8KTsJW9lk3RSE/Mivb2MZvUtoqCql9OXJ3vkxvx27MjIaeU/Y
	 zvM67T1a0jwoBrLuxIAYhLRd8D8SEi1VUYuDbl/Ne272EG1rxxZE/z76G0qpLSe9kJ
	 31rcMSfQPEr+3opx5wXwksxv6RpNC7DXuw+lctV0=
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
Subject: [PATCH 6.6 174/322] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Fri,  2 Feb 2024 20:04:31 -0800
Message-ID: <20240203035404.870863074@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fe4a3589bb3f..a6c66ea80194 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3064,6 +3064,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_HDA_RPL_S	0x7a50
 #define PCI_DEVICE_ID_INTEL_HDA_ADL_S	0x7ad0
 #define PCI_DEVICE_ID_INTEL_HDA_MTL	0x7e28
-- 
2.43.0



