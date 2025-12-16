Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111D0385CD4;
	Tue, 16 Dec 2025 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888636; cv=none; b=gbQ8OCegADvxiWl+nli0qoxQIK07tDsL+DSr8+8ccs7upPtHMZ6yGDMr13Fkyw1nKyKflrcm1Sulb65gZw6y1drT3LFLqxZt22hbFlqWpqS/oKsSsKrfBN66T/5Ra1gHlYkadZAsxy8aeZWhkEVsuLmRj0VnlJgfqIEkm7xztdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888636; c=relaxed/simple;
	bh=dIrPZ+fYXHEokWeoewKN3qYgFqOUEKgbxzKHalxoosM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoSumn0AIezk/cFRDnwBb1iE9ToZ0A3h8iaWgDDrJjem+WjphpZvBlY2cD6qr+eEBWsUpqFfgjIAIMZTBL3C2wrqLaca0dpFH04T0Jzoe0GAjaUyy3W25QNd/4d95mCAYL+Wpm3R7MY2nooTKB0aX5qL8NSF0U/0BT2OCV+sBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTrVn28w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTrVn28w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21CC4CEF1;
	Tue, 16 Dec 2025 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888635;
	bh=dIrPZ+fYXHEokWeoewKN3qYgFqOUEKgbxzKHalxoosM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTrVn28wO5in0khrNCwnmMfAwbaqtbt8iSW8MOleGraiu64mSGvOHlvbhhu5YyQ3E
	 eSQetocs2tFLtuEFm8c63E4qfpmNDNBUgCLGDLZXXfKLiC9QsnizizsO9cwVCTkSYs
	 XKaZegUuad2EPynuOHIk/amUGvk9BwljtyFr+RJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>,
	Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 591/614] ASoC: amd: acp: update tdm channels for specific DAI
Date: Tue, 16 Dec 2025 12:15:58 +0100
Message-ID: <20251216111422.803197122@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>

[ Upstream commit f34836a8ddf9216ff919927cddb705022bf30aab ]

TDM channel updates were applied to all DAIs, causing configurations
to overwrite for unrelated streams. The logic is modified to update
channels only for targeted DAI. This prevents corruption of other DAI
settings and resolves audio issues observed during system suspend and
resume cycles.

Fixes: 12229b7e50cf ("ASoC: amd: acp: Add TDM support for acp i2s stream")
Signed-off-by: Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>
Signed-off-by: Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>
Link: https://patch.msgid.link/20251203120136.2591395-1-raghavendraprasad.mallela@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index 4ba0a66981ea9..283a674c7e2c3 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -157,6 +157,8 @@ static int acp_i2s_set_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask, u32 rx_mas
 
 	spin_lock_irq(&chip->acp_lock);
 	list_for_each_entry(stream, &chip->stream_list, list) {
+		if (dai->id != stream->dai_id)
+			continue;
 		switch (chip->acp_rev) {
 		case ACP_RN_PCI_ID:
 		case ACP_RMB_PCI_ID:
-- 
2.51.0



