Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED1313790B;
	Tue, 27 May 2025 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366111; cv=none; b=UDVpj/sDGF1Uva0Tw2QTWJXItnNBS5EsF8Z98d8PeeSJjhiLtA4+5nZFqttxrnEh5V3diVBkAssB/D9tNVdUN7t+cIlN6rOiwNBBe1mv1zZYb2bbA3KQ3q7uTK0mSWewNKYmWb6epqE17d6HtMcYWpFvuwXL/Y7zjb3iZUXAEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366111; c=relaxed/simple;
	bh=LgRqqsglq1xUx2O467xKrDOUyhtj8FgPoJ2Bs66GkNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P34tsxZUogbGRsAwCFpJzDfG4XBr7jQ9JKloSjQvJzFwZNzngdgvU0Km9Xum/yje6ELAP/4O0htIUNbPUCEzc2nO60SCCZZTw8JW7CkB7itknC+bsvzN39VEkkwikhHcVG9kUV1mcxDREUtjqnRYxfHjv1EOYD3lcl2+P16Wlh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY5rl7H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY5rl7H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F6DC4CEE9;
	Tue, 27 May 2025 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366111;
	bh=LgRqqsglq1xUx2O467xKrDOUyhtj8FgPoJ2Bs66GkNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dY5rl7H14NvjisORRKkHy/C3Mqt/fIzat0IPW8qXK0Ya2r4w/31RyzP67hp3Bu8F1
	 xeOqYMrm9NyeT/KMHhPAv4J5Rf5UybgCIkz9b0CNkWFg7bDvVh5A8WoaApJ5lGiwiQ
	 MCDwLRTKPq40iW+pwyhxFH05xIbJRK88jLGlJzpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 577/626] ASoc: SOF: topology: connect DAI to a single DAI link
Date: Tue, 27 May 2025 18:27:50 +0200
Message-ID: <20250527162508.416758944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1059,7 +1059,7 @@ static int sof_connect_dai_widget(struct
 				  struct snd_sof_dai *dai)
 {
 	struct snd_soc_card *card = scomp->card;
-	struct snd_soc_pcm_runtime *rtd;
+	struct snd_soc_pcm_runtime *rtd, *full, *partial;
 	struct snd_soc_dai *cpu_dai;
 	int stream;
 	int i;
@@ -1076,12 +1076,22 @@ static int sof_connect_dai_widget(struct
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


