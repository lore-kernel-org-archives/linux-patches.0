Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E782FA647;
	Tue, 17 Jun 2025 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179173; cv=none; b=XaIHt/sSJd9wy9JZC/4Ih9jeDnCSzW26mW+OlXd2JB8NumsSV4HqcfbV6nxsEG5lkhiVGwPfwK5YZyBlvGFloMWjFhT8AciQi4r6Xsuk/nwZ9F0n9aPJh5CXIpgc1O7Coy4WBJtghTZYl/n7U8NaNAhPuWiFE85fCU9vrFCYkLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179173; c=relaxed/simple;
	bh=A71XfipmLb9QafThJ9xTedRI7O2ztXkUnb+M2RwB3hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZsW/hFcz8bbfPamH0oUnY8iOCwTP4ADO0pa83NJpMrdrM9eBZnEA3sM2b2ATn5bDF7eydRFsNIyeIyhtAu6exWHpw1/xSBTycZ/3C0zQR6hXDsEwSFEc/Z27Ea1gUsGtcGdrn6jfJj+7RAlyyr4s0GvfeBj4dtHecKw3Yp7vz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHTP54NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHTP54NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545DEC4CEE3;
	Tue, 17 Jun 2025 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179172;
	bh=A71XfipmLb9QafThJ9xTedRI7O2ztXkUnb+M2RwB3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHTP54NAp8YS2MgOsl4nI24p1btkrj8Z3Vky6DSqwNKJl971TyNc6YVFQF7u0RVk7
	 jMjTT7+hFhIw9eDl3i4HledQ5N4igyYJqUA3tQn5DpNxz82e+PsQM0Z9/jLk7rgY0o
	 cpvvc+BDXSjlWflRGRtDhG/tnkj9aqp9BeDavnbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 640/780] ASoC: Intel: avs: Fix possible null-ptr-deref when initing hw
Date: Tue, 17 Jun 2025 17:25:48 +0200
Message-ID: <20250617152517.535687100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 2f78724d4f0c665c83e202e3989d5333a2cb1036 ]

Search result of avs_dai_find_path_template() shall be verified before
being used. As 'template' is already known when
avs_hw_constraints_init() is fired, drop the search entirely.

Fixes: f2f847461fb7 ("ASoC: Intel: avs: Constrain path based on BE capabilities")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index fc51fa1fd40d2..5a2330e4e4225 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -82,10 +82,8 @@ void avs_period_elapsed(struct snd_pcm_substream *substream)
 static int hw_rule_param_size(struct snd_pcm_hw_params *params, struct snd_pcm_hw_rule *rule);
 static int avs_hw_constraints_init(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_pcm_hw_constraint_list *r, *c, *s;
-	struct avs_tplg_path_template *template;
 	struct avs_dma_data *data;
 	int ret;
 
@@ -98,8 +96,7 @@ static int avs_hw_constraints_init(struct snd_pcm_substream *substream, struct s
 	c = &(data->channels_list);
 	s = &(data->sample_bits_list);
 
-	template = avs_dai_find_path_template(dai, !rtd->dai_link->no_pcm, substream->stream);
-	ret = avs_path_set_constraint(data->adev, template, r, c, s);
+	ret = avs_path_set_constraint(data->adev, data->template, r, c, s);
 	if (ret <= 0)
 		return ret;
 
-- 
2.39.5



