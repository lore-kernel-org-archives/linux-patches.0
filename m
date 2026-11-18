Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043306;
	b=bKK/7UzeM66mZIzWJQ+ry79A27f1Rkik0dIX1H5AFKe4EOYNtk+QSlZex7d23PuNoQXR
	 XnxU+EGeQu8jOYUZpU9kOQFRhWF9/yVALJDrh2XZbMBQLLlUpweLs3xxzNKCkUELgCGAg
	 CkEyWqidmv5c6KL/KvlzD5MQ+zMP67Fv8CPJJgUzhi634zBNJ9VaoKrKNSfuOwblh/wc9
	 g5SuijmWydDil99SL6L4hU2I47PLQhMCZ6g0hD17BsEeC/IrJ5Nep7Fz0pdRwRFSgAzxZ
	 v+FnePoUCLY4M3Yx0Mx6kNvUiYXNQ5yDh/910ygQmY5z9BWoqrsFw0VAlFHGIutIiAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cLmoqe5cdYAM9zeU+g2bdQ+OYajJzBozHEUrCZurmiU=;
	b=lacXKFb9BIf3Lqygu1T4PQBMaWG6CwU2+on0ihYxK+PpyZnvPD05rpY/ifMqhJ2Ce0GV
	 1z8E5Ec2JjVqp5eRjXHNX6ANimBLpHIP8lvBA6TrzaHCU6kCiS8iUZOcRBJMIx4lOiNGA
	 GwlyEOKqJmoJdRpU0b9ouPfVOQffr/iUJLUXWm6m/ZbPPNOzx/TOnQSxZa+kGWTPxZ3aV
	 wPi8xzWDp6hvZlEmyUNdK4WMiOx6YzRY3I9sXaKncWxL9NAbHYgARySu0srS6xtqlixf+
	 GkNi0lXO4HQQ5lEyEKToVbv4i6lQN8n//b3eGNuxmu7ckFrD3toqHK/Ab/GeXEwBqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbHann7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC2606A32A;
	Wed, 18 Nov 2026 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbHann7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270DF1F000C4;
	Wed, 18 Nov 2026 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043306;
	bh=cLmoqe5cdYAM9zeU+g2bdQ+OYajJzBozHEUrCZurmiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbHann7hyR06csPYtHJE69tbrHYduLC8fEkmdrOZcg/Fa0YM5eHs7OvEyR2zbxuWo
	 z4jF1lGIgbqYZX7GwsPStd76/ZX/0nIfrMPW7dxypd4f7HouagZF37vJUYDEGhkcah
	 T1p3i8/ZaJ5tghbZCgm5rT9Gh2tFwyWX9BXj5pB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0165/2857] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Wed, 18 Nov 2026 15:19:59 +0100
Message-ID: <20261118150207.294956524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a2ebb8789bb3..44b1d5c3ff993 100644
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



