Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031439;
	b=eCy8R6ntLCr5c1CHjPin5865Av0SP6i8aFkpP0BJjscvgBgX7/wiye+REr1WT8DPlQKl
	 HKUzbv2ZQ3WnfZ+2BYVWEgPGyVfvGCol0sN24uSMDOwaNUOPnF6JFWG74XeBiWJzLw4vE
	 BYP+ZGE8NJ/JNVrSmR8AWtappiIjjYCNSsae+lUEZWMpAz0px69hxlyKfszoXJ8Z6YQzf
	 GoCWfnShKuDpvS8dEnS7JLV4j6561m0M2+/qD5uPGQ8PKDPcK3mtzKBxidoLhP0Srr0s4
	 g69hqvkIQ3bfx/dCBpyn6TzNxtcUhFtw2G+YNYqireGmRMEOmmQP7tZsfD3AdtirmjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGTl8htDMzbGGXVe4wNu7+q+noFafqWvXWzQ9bP593k=;
	b=eAMYUpvvRgaIv/5Qh3D8biembVfSP3v5AmiLaOqvoA3Y6SrgAz3Nn/Oz+1XHpNFycyMx
	 8P7UudGofD6WKDPHkTZqWpim2HHf1ls7pXRhAGKZkSJNg0x3tcLwnq5sPGPhVWudHWNks
	 lIs/CttOKldApm+AqGkvvxfvQu4bI+ffHcC4kos87QxHz21t4QVS6v422JbXssqf6VP0N
	 7yN5mmNpZz9Fpe+cOc5LcsvuQ3sF6klH3fCTnc2iQvLGpo2vlDOcVQpbKDmYV8pHTc2DE
	 8exDC6OvUq97Ro+u9wMcCnQpbWsmVUQpwodE/d8Nh9Ir3+TrMeEren9pQENdanlQV6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbGo4B77;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186E5606A31C;
	Wed, 18 Nov 2026 19:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbGo4B77
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710161F000C5;
	Wed, 18 Nov 2026 19:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031439;
	bh=tGTl8htDMzbGGXVe4wNu7+q+noFafqWvXWzQ9bP593k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbGo4B777rr2Y6nHHPyitu8XjHKIwfGYQ794uOVfzk7Z+ADgmya+KqB4IaRm517s3
	 A94H4sbkA0P4kY/lks2j6qIbBkxL06MJAtFNnXZqxRQFYPmc9fX//BHO+Qn650QilV
	 LaV2dEQuSIBMzPTed3lbUcDMkHMmyCY0O1lSo84g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1016/1756] ALSA: usb: mixer: use snd_kcontrol_chip()
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150050.577907508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 3abd2e168d69c7bbd80a622112065e0577a8cca0 ]

We can use snd_kcontrol_chip(). Let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/87msbpaud1.wl-kuninori.morimoto.gx@renesas.com
Stable-dep-of: 589fccbe1e9d ("ALSA: usb: us16x08: Fix racy accesses of mixer elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index b69b04777c6a3..08f2cf9f9b7cf 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -547,7 +547,7 @@ int snd_usb_set_cur_mix_value(struct usb_mixer_elem_info *cval, int channel,
 int snd_usb_mixer_vol_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 			 unsigned int size, unsigned int __user *_tlv)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	DECLARE_TLV_DB_MINMAX(scale, 0, 0);
 
 	if (size < sizeof(scale))
@@ -1389,7 +1389,7 @@ static int get_max_exposed(struct usb_mixer_elem_info *cval)
 static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_info *uinfo)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 
 	if (cval->val_type == USB_MIXER_BOOLEAN ||
 	    cval->val_type == USB_MIXER_INV_BOOLEAN)
@@ -1421,7 +1421,7 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_feature_get(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int c, cnt, val, err;
 
 	ucontrol->value.integer.value[0] = cval->min;
@@ -1453,7 +1453,7 @@ static int mixer_ctl_feature_get(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int max_val = get_max_exposed(cval);
 	int c, cnt, val, oval, err;
 	int changed = 0;
@@ -1502,7 +1502,7 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_master_bool_get(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
 	err = snd_usb_get_cur_mix_value(cval, 0, 0, &val);
@@ -1570,7 +1570,7 @@ static int get_connector_value(struct usb_mixer_elem_info *cval,
 static int mixer_ctl_connector_get(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int ret, val;
 
 	ret = get_connector_value(cval, kcontrol->id.name, &val);
@@ -2382,7 +2382,7 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 static int mixer_ctl_procunit_get(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int err, val;
 
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
@@ -2399,7 +2399,7 @@ static int mixer_ctl_procunit_get(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
@@ -2736,7 +2736,7 @@ static int parse_audio_extension_unit(struct mixer_build *state, int unitid,
 static int mixer_ctl_selector_info(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_info *uinfo)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	const char **itemlist = (const char **)kcontrol->private_value;
 
 	if (snd_BUG_ON(!itemlist))
@@ -2748,7 +2748,7 @@ static int mixer_ctl_selector_info(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_selector_get(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
@@ -2765,7 +2765,7 @@ static int mixer_ctl_selector_get(struct snd_kcontrol *kcontrol,
 static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_value *ucontrol)
 {
-	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
-- 
2.53.0



