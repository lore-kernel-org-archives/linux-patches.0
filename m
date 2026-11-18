Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033934;
	b=jjabih+c6gpzNsIs5m0IG7qfK7f+wzhIlEsvDRtgn+Ypf9Dls0Jv3maJRV7lfH9XC7Dx
	 Tm9CiFhDxfH56aExaEePsSCGMo9tHjqB46nY4CapupU9IldeEyIytqMhCdlr0VuOGV5i+
	 Djt0v/VYjX1GthvsLE5IBP3YiAMI/4iutD39XASytyNVPUfz6GCJm7iZfieZbJQXm5htS
	 v4AGNv4fdgp3tQ02xnDgvfnRckRyR+k+ostVPnqTwP1u/VZbAS9J0Zaf3Anv9CrpglANV
	 JvI++qZ0Q4yL4K3MKcgLdCcsuq3CnHXO/OyFt36vHorPQJo1MCpmuxw81xx+87jY/jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7MBpBvmJ9jmBTE0pk0BlmfvG7waFXWjCuA1rs6XJmU=;
	b=d0bFJLJoPjelee+PRnKIdW8XUQPC9HDqiDIzy2Rc7gsmvoNSIKwJGoulIepmbyxkR04T
	 wEcqm6jjb7hpevyaHzvv8aO7iLeStTs+8HS0yhVoDgsmWC2smv/LHYpbK+YCntok6YXeq
	 pZf7SVEIiPxoD3WXVCczl+lKv59oHT4cd+8R92eJ5cLfE/4WIDyZNZyWDQXk1zNXk6MaK
	 SFHs9xdRZEKXO0ksQoXSqa8zIytDeWbqtalcfBHtnAapcVF07kVUWd2belqv229K8lAH+
	 SjTiWxDcL5FqjqsTYLLci6t/XOC3FpyZrOoLZg54ZJJScjneoW98px4fCEQU29nBX4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBIGgCK6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72291606A325;
	Wed, 18 Nov 2026 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBIGgCK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B51F000C5;
	Wed, 18 Nov 2026 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033934;
	bh=C7MBpBvmJ9jmBTE0pk0BlmfvG7waFXWjCuA1rs6XJmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBIGgCK6CK99+q+DxUKFhiBZlgRFEgthuolL6D5/uq+cj6h1re/s4bRBSDBS5kFq9
	 QROi3m7kP45uJupJS/kLleafQ45JtTWc76xkKGlSPFfGOz8XQJyrCc+dXxh/+3RrEE
	 vyQhKgY+blefJEU5xf5ZGrtp6IPZd8fRaYOzz69g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0190/3318] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Wed, 18 Nov 2026 15:13:32 +0100
Message-ID: <20261118150320.488170901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 273806f38ce95c95c288a03d3de1e423cd3e5543 ]

snd_hda_add_new_path() returns NULL when no path exists between the
given NIDs, but olpc_xo_update_mic_pins() passes dc_mode_path
straight to snd_hda_activate_path() which dereferences it without
checking. Add the missing NULL guards, same as the local path
variable already has in the same function.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 25cd3283906a2..7000245f083d5 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -467,7 +467,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -503,7 +504,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 		update_mic_pin(codec, 0x1b, 0);
 		/* enable DC bias path and pin */
 		update_mic_pin(codec, 0x1e, spec->recording ? PIN_IN : 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
 	}
 }
 
-- 
2.53.0



