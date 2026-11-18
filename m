Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019683;
	b=2tQVJ5p9we04uaKUiELV08Mf2SS4XKXvNxJfbFz0ZhwoL81aW0tXriq/rTYLGNH0eQpi
	 v9nlQuRLm5gQA73nGFeklp/mUsYuASEANveenXJeToVav9EqMAraLhvoT3lhk0BeaEWTx
	 iY59JvmZhiv2S73wb538QHYajJ/Qp9FGIjCDfwaYfQwKjDNvtNcN+gw21AcsTR+AjaygC
	 KnFOq4YC7Qdc7t9IwKwcmXIpZJNPlzolgEaSMcWk9Iktis11aCOakLJ9Z0wR+KXvkQhnH
	 lf5Jewac2/5wil57Orm2cn4HGiCf4FI+r4JNxffgQVzaQzGgFiaH1S/+2Xrc7FNvpuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IUVwmlzvEG4Pzcxbci/htBP5VTjK401x1N9NWW9E3oI=;
	b=01KQggQ3dcVInXDYN6r03+IOb8JzlZkjrjev0VzU4/dzourWQHIh6DqXdVbl8Pf/Grpo
	 VrtUiBZcQw6tJ+ihneVIGOujojYorSUrarzLrBsJBSi3x35HvmVD7SSu/fjnmIwa8yKVp
	 vkXRFxpOHUxAV4IvJbVrtzJRQX0uQF4yC8uwqIUW79XnPWWD2DKybFq0HP4ZWTdnE280w
	 VnkU0urk3lGhyNaAUTIIswfuUGjsXlqYpB8jR7o+oo2gwPz/wY0qqm+5rE4DFSnIMrWQA
	 Y+DsgELklTwOXkHqitwC/Flwunkq9AHp4WKoCdvyGzsqfKuzAdb0N0tsvbx/83SGnAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ly/jKgl0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A4606A31C;
	Wed, 18 Nov 2026 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ly/jKgl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562BA1F000C4;
	Wed, 18 Nov 2026 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019682;
	bh=IUVwmlzvEG4Pzcxbci/htBP5VTjK401x1N9NWW9E3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ly/jKgl077DV/16t9a0wcr1ZbAQbaLQXunle4dBdtSWQAXlMgn1XLcsU6Nfdz0fmD
	 M20shT8rAfZtqZpMm1iQugRyP/l5IXPoQPtCxLiQ3FUiQ7FMFW6Ol1I0/IoXEPw+13
	 ZG/9rOdk4hvSp4ppOz04H/NlR4sfzVFt7osnfNE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40b06a86af225236fdb4@syzkaller.appspotmail.com,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1683/2651] ALSA: hda: intel: Dont free card in the probe work
Date: Wed, 18 Nov 2026 15:48:43 +0100
Message-ID: <20261118150348.271217142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit fbaccb1b19c79e79220e3bcc5bb18ca54ffb017b ]

If the delayed probe fails, azx_probe_work() frees the card and clears
the drvdata. azx_remove() reads the card before it waits for the probe
work with cancel_delayed_work_sync() so when the device is removed while
the probe work is running, it frees the card again after the work has
already freed it.

Only disconnect the card in the work so that its slot is released right
away and leave freeing it to azx_remove().

Fixes: 39173303c838 ("ALSA: hda: Free card instance properly at probe errors")
Reported-by: syzbot+40b06a86af225236fdb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=40b06a86af225236fdb4
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Link: https://patch.msgid.link/20261012162841.1879278-1-aliamemis@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 2b5b5d555f2cd..6b80b59b87430 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1737,7 +1737,12 @@ static void azx_check_snoop_available(struct azx *chip)
 static void azx_probe_work(struct work_struct *work)
 {
 	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
-	azx_probe_continue(&hda->chip, true);
+
+	if (azx_probe_continue(&hda->chip, false) < 0) {
+		hda->init_failed = 1;
+		complete_all(&hda->probe_wait);
+		snd_card_disconnect(hda->chip.card);
+	}
 }
 
 static int default_bdl_pos_adj(struct azx *chip)
-- 
2.53.0



