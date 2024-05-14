Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BD9134CFE;
	Tue, 14 May 2024 10:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682843; cv=none; b=gW6XnKYuONE5dIRcAeh1xX/WAoQc5+gfRCU78FNxBEKdqTXS/PV9+4YAoa6GCLsjoUQNuPXzjF7A85MxknT1GY/JtuMKH1kVCMyCuDwzSibzolBws0i+JsYitL4lP+Oryhq15n/lD23DliOwqfsyOIaZj+t0h8XhAxVWs7Ze2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682843; c=relaxed/simple;
	bh=GUvPvIkehTaR0y10DDzxJe6VoI0B/3gbsAEMaLkan5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Prhi0ilfYg6xwtF3mpinZG6oTW+W5BHRLji6LyaO8o45hmhgGMu5pgToJVrA5gXAdVOf/mOUmz26tS1FDyCBb2zq88DgZW8EmkMDkMAaUZ5A1rOlZL7fese4xCeyPMAe5y2Uxv9FTB9D0kAF4u/EiYZ9s2AXWdkrIN/2wDI92SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHIdAgBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHIdAgBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5497C2BD10;
	Tue, 14 May 2024 10:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682843;
	bh=GUvPvIkehTaR0y10DDzxJe6VoI0B/3gbsAEMaLkan5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHIdAgBwfPrFzMcHBSZ2GWSwpljtvfHL9G9S/Fm2XcJ/mKu7SL/VsY70XyPTCoZxJ
	 hyUA2a8ZofWgWLuZ/LeQalRnzQ5o7fxwFca/pD3EC9IEhTrjUQWZWYAecru6dAleJa
	 FqXpwIkGf21qEkP8MQC4mhO6hN2nStvzPdcxlzUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 122/336] OSS: dmasound/paula: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 14 May 2024 12:15:26 +0200
Message-ID: <20240514101043.209573344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 755795cd3da053b0565085d9950c44d7b6cba5c4 ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via module_platform_driver_probe(). Make this
explicit to prevent the following section mismatch warning

	WARNING: modpost: sound/oss/dmasound/dmasound_paula: section mismatch in reference: amiga_audio_driver+0x8 (section: .data) -> amiga_audio_remove (section: .exit.text)

that triggers on an allmodconfig W=1 build.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Message-ID: <c216a129aa88f3af5c56fe6612a472f7a882f048.1711748999.git.u.kleine-koenig@pengutronix.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/oss/dmasound/dmasound_paula.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 0ba8f0c4cd99a..3a593da09280d 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -725,7 +725,13 @@ static void __exit amiga_audio_remove(struct platform_device *pdev)
 	dmasound_deinit();
 }
 
-static struct platform_driver amiga_audio_driver = {
+/*
+ * amiga_audio_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver amiga_audio_driver __refdata = {
 	.remove_new = __exit_p(amiga_audio_remove),
 	.driver = {
 		.name	= "amiga-audio",
-- 
2.43.0



