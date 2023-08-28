Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A50EC433C8;
	Mon, 28 Aug 2023 10:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218159;
	bh=3XosIgii8qlwt+LNDIt8DHXWRLNvhJShUlQe0WY5AAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkPMZdSp3GzJAVfinXgO6avC4U2AVm1NyE72TW91bGo1hdfqySELVaRDZh2PBueT0
	 vSbFENnz///Pjja98cajd1GES+ObdoIeFcDEFvm75WO3HsbuWZaeLWWpx/jvzsD5OP
	 /elp5eywShzuf8hVk1jsRcF0bzxJXDc0OFB1FJ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Song <chao.song@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 117/129] ASoC: SOF: ipc4-pcm: fix possible null pointer deference
Date: Mon, 28 Aug 2023 12:13:16 +0200
Message-ID: <20230828101201.263230293@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Song <chao.song@linux.intel.com>

[ Upstream commit 2d218b45848b92b03b220bf4d9bef29f058f866f ]

The call to snd_sof_find_spcm_dai() could return NULL,
add nullable check for the return value to avoid null
pointer defenrece.

Fixes: 7cb19007baba ("ASoC: SOF: ipc4-pcm: add hw_params")
Signed-off-by: Chao Song <chao.song@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230816133311.7523-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 9e2b6c45080dd..49eb98605518a 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -708,6 +708,9 @@ static int sof_ipc4_pcm_hw_params(struct snd_soc_component *component,
 	struct snd_sof_pcm *spcm;
 
 	spcm = snd_sof_find_spcm_dai(component, rtd);
+	if (!spcm)
+		return -EINVAL;
+
 	time_info = spcm->stream[substream->stream].private;
 	/* delay calculation is not supported by current fw_reg ABI */
 	if (!time_info)
-- 
2.40.1



