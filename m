Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD669E08;
	Wed, 21 Feb 2024 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521423; cv=none; b=U+tgl76GVlnIcwvNrgobp4xAJzOqnC/M/XlEKkx1/+m7IJqJHX+88Ot0cOWGVYMAs55pCYiuiVbhlTKxlL0HmwAvT2FXuWtrWCvgqy5Youl0HWEvkaDoX1meShfEmdqkZE6HPu/6iMjEVpqsg2oM+coNJo2U6epFe42rRJ+KILE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521423; c=relaxed/simple;
	bh=HfhBu3tLtq/iHKbe2MlUePbDGhmil53galBpEn5O+BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJb2a3xbfB0PYqOwCmkOY25bNj2MW0dlffO9GO2V4wf47GiXE5ErN6DD0ZVdiySwYpNR4y7rcsZ1cEpYXW4fuB40AccYJuTNbbp3Hk/TAQj+GXK9s5ZdfuUL62J5qZo/hVerc8Vvnnl5gAlmalb3g6+H/uYxTSGkEdwXjvbIPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1a6j8rxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1a6j8rxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E29C433C7;
	Wed, 21 Feb 2024 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521423;
	bh=HfhBu3tLtq/iHKbe2MlUePbDGhmil53galBpEn5O+BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1a6j8rxfCU9b/U4td7INthxKHi/sRVB5Z4bEvib15mEDRriM55Hg8ekbb9jA/lR2/
	 AONmyx8uEz85Q/Wytrwjwphh05HYZzNrMSj5h2Qbj5VIfI5vkLUi5TqugGCN0DGGgQ
	 8kDgBpq73HIQUk2OHASsr9tzB2y3wdOdHMkVkvIA=
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
Subject: [PATCH 4.19 105/202] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Wed, 21 Feb 2024 14:06:46 +0100
Message-ID: <20240221125935.151177470@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 76d5490231a7..3ac7b92b35b9 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3004,6 +3004,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
-- 
2.43.0



