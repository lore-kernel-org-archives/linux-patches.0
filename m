Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DAE1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI4VQK7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CCAC433C7;
	Wed,  4 Oct 2023 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443936;
	bh=ZPKqTnYuHKC94BhXGn0SsZP4PsK2Zc/rFpnxIb3acfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI4VQK7ces5IZaBjC+bWmUahsPG/phYyJ9SWIa5mi9st8SwGINZcwCvxBqAI8iiG4
	 G6y6k2k7Ownt+3eSNjumx3yHvPCLGVngnLDZTZc2tb4JOU/TSpOXM45ZuyQvs7yXPo
	 YA1TpjnpDX01jG8kgpNojhtW9x7sTmLgQveBhjI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 055/321] ASoC: hdaudio.c: Add missing check for devm_kstrdup
Date: Wed,  4 Oct 2023 19:53:20 +0200
Message-ID: <20231004175231.709533393@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit c04efbfd76d23157e64e6d6147518c187ab4233a ]

Because of the potential failure of the devm_kstrdup(), the
dl[i].codecs->name could be NULL.
Therefore, we need to check it and return -ENOMEM in order to transfer
the error.

Fixes: 97030a43371e ("ASoC: Intel: avs: Add HDAudio machine board")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230915021344.3078-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/hdaudio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/avs/boards/hdaudio.c b/sound/soc/intel/avs/boards/hdaudio.c
index cb00bc86ac949..8876558f19a1b 100644
--- a/sound/soc/intel/avs/boards/hdaudio.c
+++ b/sound/soc/intel/avs/boards/hdaudio.c
@@ -55,6 +55,9 @@ static int avs_create_dai_links(struct device *dev, struct hda_codec *codec, int
 			return -ENOMEM;
 
 		dl[i].codecs->name = devm_kstrdup(dev, cname, GFP_KERNEL);
+		if (!dl[i].codecs->name)
+			return -ENOMEM;
+
 		dl[i].codecs->dai_name = pcm->name;
 		dl[i].num_codecs = 1;
 		dl[i].num_cpus = 1;
-- 
2.40.1



