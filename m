Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B934E764;
	Tue, 16 Dec 2025 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886609; cv=none; b=PAhV5Vf5JqYMZQBtddTf/aFuYMj9cYZ+pCTMudGzM5vB62yKuLSv2o1F4EdZBSSuO2ySXL76o5GEMOCylQsPyTLGydz+qKgK4nN++U2BmmKNym3UEQkDUbd67nDazAuZ+sb3/fgvU7yJyF6GwOmvEiQahreyLOmjFXmiV+jWF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886609; c=relaxed/simple;
	bh=k/9jufGshW1/11wjJIYvmNp602eMEXH4kBv36GKuqDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYt8ntEJ4t75lFDqhaXsqneL/HGiKiREELzpteO7T0NJ/HmOdvO1EYLk7x8j2trmLSSwkygr668KRlFTyMmdB8on0f+NlLiONA/SoX8q5cFCnWlN1Tn+GtpuuD0AKbS3QmYgoIhKolPXYbCyCHDj6Jgpr1cFpm0TzpserbCoubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jgxk174F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jgxk174F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD616C4CEF5;
	Tue, 16 Dec 2025 12:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886609;
	bh=k/9jufGshW1/11wjJIYvmNp602eMEXH4kBv36GKuqDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jgxk174FoGAmzFwLEfU2tNtGKSs2Z1Nn1R6VFHFU3FDY0Vh9pdD3p62B7+J3IEXzc
	 kW1CEl/AJCpGTc8Ewnt8BILJnAu/SH74Vfb1qPUcx7dmkIb+WF7x08OvXyy8LRS9S5
	 tKEvX2a3YNqVjf++Ge0xfc3onp5QJEVT6m96b93A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>,
	Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 486/507] ASoC: amd: acp: update tdm channels for specific DAI
Date: Tue, 16 Dec 2025 12:15:27 +0100
Message-ID: <20251216111403.048258744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



