Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D2309F1E;
	Sat, 25 Oct 2025 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408968; cv=none; b=jHOv08rMCw8uAraXTq6OPLMVMHrTKDVnHR++DdJu3Sm+xuIgrP4JQTqnRVE7+bHO/R+4tU5qFmYRZe/4FeLjhRW/kELV18V4biQktfUY5QMZOeKlGangyCOGZ5LKgeT5zetokwCriQkqp5GJtNhGBlTrpsf9KrSEu1MQs6EHyYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408968; c=relaxed/simple;
	bh=rsWNTG25FhSE1nJRwlXwFhFi4xH/hL0IACkrwJQOo8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyvDOZSe6KFaerCES74NiKKWlhRIAoQUtKmPufqilpeE4ooZ0nByoLPWDkw3jv1ofzbe4BeYAlweATmdc6s5ack+0Ox4UeHmdIGXsxpN5GARJe3R/gogTi0XU9ZdvYo/qgjnxmx4Xnt/6EcYo3pVHzHA7NOe/bFo1WB/4vxNRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=psQpycTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="psQpycTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74076C113D0;
	Sat, 25 Oct 2025 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408968;
	bh=rsWNTG25FhSE1nJRwlXwFhFi4xH/hL0IACkrwJQOo8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psQpycTYgXF9sTWYosr/exFaNIkYHw19O+aHvZOPfiqhcIugAOsHxF7PtLthBx9dA
	 UMDP7q4Z+WG673aS5tm2yGeXPGoL5XkivirOWbFGW0MP3MXopEDArjISTCTwrXNYQF
	 LK2OpCYtvmk78WU1HY0QMcLW7sig9wV80ZS/IgrmfXLzHtNzERylNfDaUch0bj0NQM
	 /lLzy0KXfruC5A2Ty4zNzfq9xlt9H5kFPLnfHMsDxa1JZyz6P9aHNZQk3OqAdj1rjL
	 X8dGXoF5FaEemn3lpsfTaKyWkYGz10HKHzD+KxQazvrpZZIO78Ti1++qxtOJn4ju6P
	 LIopo4lv6/2WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.10] ALSA: usb-audio: add mono main switch to Presonus S1824c
Date: Sat, 25 Oct 2025 11:56:28 -0400
Message-ID: <20251025160905.3857885-157-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit 659169c4eb21f8d9646044a4f4e1bc314f6f9d0c ]

The 1824c does not have the A/B switch that the 1810c has,
but instead it has a mono main switch that sums the two
main output channels to mono.

Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Adds device-specific control IDs and state slots for the 1824c mono
  button so the driver can address the hardware selector correctly
  (`sound/usb/mixer_s1810c.c:94` and `sound/usb/mixer_s1810c.c:124`).
- Introduces a dedicated `Mono Main Out` control wired into the existing
  switch helpers, replacing the bogus A/B selector previously shown to
  1824c users and restoring the intended functionality
  (`sound/usb/mixer_s1810c.c:542`).
- Updates mixer initialisation to choose the mono switch only for USB ID
  `0x194f:0x010d`, leaving the 1810c path unchanged, which confines the
  behaviour change to the affected device and avoids regressions on
  others (`sound/usb/mixer_s1810c.c:637`).
- This is a hardware capability fix rather than a feature: without it,
  1824c owners see an unusable control and cannot toggle the mono
  summing from ALSA, so backporting improves correctness with minimal
  code churn or architectural impact.

Suggested next step: verify on an 1824c that `alsamixer` now exposes a
working mono main switch.

 sound/usb/mixer_s1810c.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index fac4bbc6b2757..bd24556f6a7fb 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -93,6 +93,7 @@ struct s1810c_ctl_packet {
 
 #define SC1810C_CTL_LINE_SW	0
 #define SC1810C_CTL_MUTE_SW	1
+#define SC1824C_CTL_MONO_SW	2
 #define SC1810C_CTL_AB_SW	3
 #define SC1810C_CTL_48V_SW	4
 
@@ -123,6 +124,7 @@ struct s1810c_state_packet {
 #define SC1810C_STATE_48V_SW	58
 #define SC1810C_STATE_LINE_SW	59
 #define SC1810C_STATE_MUTE_SW	60
+#define SC1824C_STATE_MONO_SW	61
 #define SC1810C_STATE_AB_SW	62
 
 struct s1810_mixer_state {
@@ -502,6 +504,15 @@ static const struct snd_kcontrol_new snd_s1810c_mute_sw = {
 	.private_value = (SC1810C_STATE_MUTE_SW | SC1810C_CTL_MUTE_SW << 8)
 };
 
+static const struct snd_kcontrol_new snd_s1824c_mono_sw = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Mono Main Out Switch",
+	.info = snd_ctl_boolean_mono_info,
+	.get = snd_s1810c_switch_get,
+	.put = snd_s1810c_switch_set,
+	.private_value = (SC1824C_STATE_MONO_SW | SC1824C_CTL_MONO_SW << 8)
+};
+
 static const struct snd_kcontrol_new snd_s1810c_48v_sw = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "48V Phantom Power On Mic Inputs Switch",
@@ -588,8 +599,17 @@ int snd_sc1810_init_mixer(struct usb_mixer_interface *mixer)
 	if (ret < 0)
 		return ret;
 
-	ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
-	if (ret < 0)
-		return ret;
+	// The 1824c has a Mono Main switch instead of a
+	// A/B select switch.
+	if (mixer->chip->usb_id == USB_ID(0x194f, 0x010d)) {
+		ret = snd_s1810c_switch_init(mixer, &snd_s1824c_mono_sw);
+		if (ret < 0)
+			return ret;
+	} else if (mixer->chip->usb_id == USB_ID(0x194f, 0x010c)) {
+		ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
+		if (ret < 0)
+			return ret;
+	}
+
 	return ret;
 }
-- 
2.51.0

