Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023888;
	b=jmSnmZhwti/RJFR0qgrTXz/Jagoww0N3L8QFua2tElAqDuKGDdL4jD7glODOVXvP+GPT
	 hqkVird5rF9WPuEHAbqj0AI3HmdUwbCJ6hlJlwUbxHHniW1T3AqpCPi+qrPcIn2Qs+tq1
	 /HMoX8wF10TSnbABNtQtgGSV6ZfQxu2slQCdkRMmyZubNfdZpV3MrD/l1dTbmvSCe7L+F
	 jLQd/h9UpJZP9Ht9uW1SSgIQN4ixIGLvQSQUIcW6wXMspj6d5YNYI/womAD3qah7XX/rZ
	 rfBL2LMmOMsFBIUvdE9ixro0Y7HDbcgNcWJRxWDDKDzMG18cl6qDIhXBttQ3pxk1v3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDhVQW+zL5QXedMXYKQeyAVhQtkXVJcJmEwfB0sdLzk=;
	b=hP+nBB6TSNT7sklzRvV51QF+UOtx8uXUf69Otv8jwVtXVp/o2exNBXJPbwiWl4pZzoiT
	 afj4URu8VsQsNVzf9+2CWNe2SdPYBUgCepLG01Lu/QWCW2JlyRMF99QkhyeKsORHe8e1X
	 DzuE+BTInXe4hHbAMnxAWmVyl8qTOqtRbWnxIaDRyktE8HD12a7aao6P1Llq6XTRNo9oU
	 Aszelth24VhMJLMzHeQFOQYbn3kLrMdBeFrBY+IxXo5ReNfBIucB65FJIdWbw6R/Idywh
	 K0M3P1lr2n5wIHbZ5+OR8ABroOgA8toRUTbZ8XqSUYMKSo9a/lrcYM+vldKKoOMxp3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NFGrH6gI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93C606A31C;
	Wed, 18 Nov 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NFGrH6gI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D11F000C4;
	Wed, 18 Nov 2026 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023887;
	bh=zDhVQW+zL5QXedMXYKQeyAVhQtkXVJcJmEwfB0sdLzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFGrH6gImeX9keWGmpS20zRdkkJXEshVwUEiFUPMBwqlT6LiUFxlzzENhwhLn4F5g
	 M1zmmhuLqfMNVXZRGiANN0SrztsLE9n9DI6pMxzswbd1FE8ufJ0QyHhcXLnzGg9gPY
	 BbRetTAvOZRq8z8tWGO3Yle4DmmeLX0CDsxQ0Bl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0530/2151] ASoC: codecs: ab8500: use snd_kcontrol_chip() instead of snd_soc_kcontrol_component()
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118150141.331068642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 3827b34564951febc0ffa7ce93c1d9c05888e53b ]

We have very similar name functions (A)(B). Both gets component from
snd_kcontrol, but (A) is used in callback functions which is registered
through snd_soc_add_component_controls(), (B) is used through
snd_soc_dapm_new_widgets().

	(A) snd_soc_kcontrol_component()
	(B) snd_soc_dapm_kcontrol_component()

(B) is using very picky way to get component but using it is necessary in
ASoC. But (A) is just wrapper function to snd_kcontrol_chip(), and directly
using it without wrapper is very common way on ALSA.
To reduce confusions of similar function, let's use common way on (A).

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87plaqt8rn.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0d46182a1be7 ("ASoC: ab8500: Skip digital microphone support on AB8505")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index a0f5663157c38..99e6772efc608 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1106,7 +1106,7 @@ static void anc_configure(struct snd_soc_component *component,
 static int sid_status_control_get(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 
 	mutex_lock(&drvdata->ctrl_lock);
@@ -1120,7 +1120,7 @@ static int sid_status_control_get(struct snd_kcontrol *kcontrol,
 static int sid_status_control_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 	unsigned int param, sidconf, val;
 	int status = 1;
@@ -1175,7 +1175,7 @@ static int sid_status_control_put(struct snd_kcontrol *kcontrol,
 static int anc_status_control_get(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 
 	mutex_lock(&drvdata->ctrl_lock);
@@ -1188,7 +1188,7 @@ static int anc_status_control_get(struct snd_kcontrol *kcontrol,
 static int anc_status_control_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 	struct device *dev = component->dev;
@@ -1271,7 +1271,7 @@ static int filter_control_info(struct snd_kcontrol *kcontrol,
 static int filter_control_get(struct snd_kcontrol *kcontrol,
 			struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = snd_soc_component_get_drvdata(component);
 	struct filter_control *fc =
 			(struct filter_control *)kcontrol->private_value;
@@ -1288,7 +1288,7 @@ static int filter_control_get(struct snd_kcontrol *kcontrol,
 static int filter_control_put(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct ab8500_codec_drvdata *drvdata = snd_soc_component_get_drvdata(component);
 	struct filter_control *fc =
 			(struct filter_control *)kcontrol->private_value;
-- 
2.53.0



