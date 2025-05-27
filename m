Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C352566;
	Tue, 27 May 2025 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368511; cv=none; b=HuL0IAUoJtaoScPN03tY2MnYzQVopYYgrGFVfm08MLRT7mr5RrqWZPmR36KghuQz0k1IUy18Kf5Xp979zWrKewbXZ0YuuhJWS7z+5Cz46/HmhDpSaKB3hGpV0X3Ax4rTSUSQhikYpx2A6p+dn2ILw39Ckt6aOqIb0l0GDJBIIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368511; c=relaxed/simple;
	bh=ZMrFjsqOhWhprLDn4a+hgFyqw2voNFMgTfTsn/0paBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfmPQDvCArLba6aDXT9roHojcwWy7i/+ZasEA5Di4hYLRrLmZNJAARCQbftZkxvD4Mij1J2ATm8tWd80B0GxAtSAT9VvKbPW2pLQyvAPzOXTFqTGMhUXLk+0yXZ8XCpuZIuJMy0jWm5phkEPbqSioJ7QcAR59yO34x3bmFHBubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNWMszLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNWMszLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE55C4CEEB;
	Tue, 27 May 2025 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368509;
	bh=ZMrFjsqOhWhprLDn4a+hgFyqw2voNFMgTfTsn/0paBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNWMszLv39jyGpFvNovDdfgr9liGc+HD8+jHA5/cmwQL0isvaDfqcZYpFJDPwlpnK
	 tI8gevxvc5zU3KGY+ZNdE8B7N2tXRE4M8eLbDiFjKnWcz9QIa+2fX4PAcNOwOvpCcA
	 d1jbEZGIPzaJpRmuuLOQtzNw7Qu6IrJpbgYB0ywo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 729/783] ASoc: SOF: topology: connect DAI to a single DAI link
Date: Tue, 27 May 2025 18:28:46 +0200
Message-ID: <20250527162542.808581750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 6052f05254b4fe7b16bbd8224779af52fba98b71 upstream.

The partial matching of DAI widget to link names, can cause problems if
one of the widget names is a substring of another. E.g. with names
"Foo1" and Foo10", it's not possible to correctly link up "Foo1".

Modify the logic so that if multiple DAI links match the widget stream
name, prioritize a full match if one is found.

Fixes: fe88788779fc ("ASoC: SOF: topology: Use partial match for connecting DAI link and DAI widget")
Link: https://github.com/thesofproject/linux/issues/5308
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250509085318.13936-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/topology.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1063,7 +1063,7 @@ static int sof_connect_dai_widget(struct
 				  struct snd_sof_dai *dai)
 {
 	struct snd_soc_card *card = scomp->card;
-	struct snd_soc_pcm_runtime *rtd;
+	struct snd_soc_pcm_runtime *rtd, *full, *partial;
 	struct snd_soc_dai *cpu_dai;
 	int stream;
 	int i;
@@ -1080,12 +1080,22 @@ static int sof_connect_dai_widget(struct
 	else
 		goto end;
 
+	full = NULL;
+	partial = NULL;
 	list_for_each_entry(rtd, &card->rtd_list, list) {
 		/* does stream match DAI link ? */
-		if (!rtd->dai_link->stream_name ||
-		    !strstr(rtd->dai_link->stream_name, w->sname))
-			continue;
+		if (rtd->dai_link->stream_name) {
+			if (!strcmp(rtd->dai_link->stream_name, w->sname)) {
+				full = rtd;
+				break;
+			} else if (strstr(rtd->dai_link->stream_name, w->sname)) {
+				partial = rtd;
+			}
+		}
+	}
 
+	rtd = full ? full : partial;
+	if (rtd) {
 		for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
 			/*
 			 * Please create DAI widget in the right order


