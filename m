Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg83j5fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39D8C433C7;
	Wed,  4 Oct 2023 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443863;
	bh=lbbOtcJTkNJwKTochjKakW1cOoyXW23q7TlPSHkuclU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mg83j5fhbg1FzT+1inwZdQvZIDae/D50jefsS7KQLTAoDhh+2kl5EkksZvE0ElObQ
	 Ae28+D9tWkYqhaCCOpcvPG+S+SAYWiInNEv4B5hGh8gdaewTLOODK16DuYwjNz1XQ8
	 gExI7YXpsPqJz2uELzGH9FNwk0kT5pCSuZEg3nUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 046/321] ASoC: SOF: ipc4-topology: fix wrong sizeof argument
Date: Wed,  4 Oct 2023 19:53:11 +0200
Message-ID: <20231004175231.305595878@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 6ba59c008f08e84b3c87be10f3391c9735e4f833 ]

available_fmt is a pointer.

Fixes: 4fdef47a44d6 ("ASoC: SOF: ipc4-topology: Add new tokens for input/output pin format count")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230914132504.18463-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 11361e1cd6881..8fb6582e568e7 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -218,7 +218,7 @@ static int sof_ipc4_get_audio_fmt(struct snd_soc_component *scomp,
 
 	ret = sof_update_ipc_object(scomp, available_fmt,
 				    SOF_AUDIO_FMT_NUM_TOKENS, swidget->tuples,
-				    swidget->num_tuples, sizeof(available_fmt), 1);
+				    swidget->num_tuples, sizeof(*available_fmt), 1);
 	if (ret) {
 		dev_err(scomp->dev, "Failed to parse audio format token count\n");
 		return ret;
-- 
2.40.1



