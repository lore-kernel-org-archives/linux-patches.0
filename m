Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A89B1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BC3C433EF;
	Mon, 20 Mar 2023 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324843;
	bh=9JMFh7fIhp+ZVCsUj7thh5UxF2zDmdZ58+FF8L6uuPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRnzy3A2X0sAe0xUejbaGN6H3U+hcs48rrcbHIT6h0lGPOFMer4KVqEPiKXzUeAv7
	 gCNr/R5gUgOKNVrjR6p7H8MwNKv+G/IzdGuNiVYzD1oA1k9AYu6ZQjdt0S9XrWjK8o
	 wDDH3ObUN3Hk8F8V6Ed48eTobUdrU2z8dQNK6MLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/198] ASOC: SOF: Intel: pci-tgl: Fix device description
Date: Mon, 20 Mar 2023 15:52:30 +0100
Message-Id: <20230320145508.003884416@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 376f79bbf521fc37b871b536276319951b5bef3a ]

Add the missing ops_free callback.

Fixes: 63d375b9f2a9 ("ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307093914.25409-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index 19e2d68dcb20a..ccaf0ff9eb1c3 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -218,6 +218,7 @@ static const struct sof_dev_desc rpls_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpl_desc = {
@@ -246,6 +247,7 @@ static const struct sof_dev_desc rpl_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
-- 
2.39.2



