Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699C2143895;
	Tue, 23 Apr 2024 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908630; cv=none; b=kg5YkuUxOKbYH7ZFSpLzAyF1/V0IYQoF9iEUkr/V1kVaCsv/LQKtIVnoNUlfWLvl7qQUIsvFWa1OstJfcH2nKZd0i3qKnSadaTHVjttfyZcKBOj8KkCHLEe6br/638iQzDFIzN2n4mIBDwuSMvrFWcizsaXsQmCvHiEHDsmWCAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908630; c=relaxed/simple;
	bh=cTldsEPYIxGg/Gyn1YFb/3eF8zCP95BaxL7cmExIeek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkd83S510BVbGkEqe5Ezb5ay3bQIAL852hFnzwizNEgJKV4D/Q7uibd/OTw2s6NuUMrmksOIUQczexv34YNAlXDXs+vpCjc9Z3UB6qQxGZm7V1S4osxd47xFNEDuITjBhw6KpaQ8l9ZFzh/+GoagH3f+EqTNJC+qQmyjsjeNgb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r834XD+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r834XD+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4C4C3277B;
	Tue, 23 Apr 2024 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908630;
	bh=cTldsEPYIxGg/Gyn1YFb/3eF8zCP95BaxL7cmExIeek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r834XD+HcWRj+0+exGjpuFf3LGCpldE9bVlK75+ukb7NBXgZoN7Z0E/iloSmbObfA
	 UfKZ8QzgpKrqqGYPwMrEy56a81Od8vBoYrVCkzPPj5X69Fyzq9kZKQfYnToVvRkb+F
	 oMnXCw2B5H86/YYNZxERzA6V0bnaOgT0RX0mhGgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 101/158] ALSA: hda/tas2781: correct the register for pow calibrated data
Date: Tue, 23 Apr 2024 14:38:58 -0700
Message-ID: <20240423213859.037359218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit 0b6f0ff01a4a8c1b66c600263465976d57dcc1a3 upstream.

Calibrated data was written into an incorrect register, which cause
speaker protection sometimes malfuctions

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240406132010.341-1-shenghao-ding@ti.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -420,10 +420,10 @@ static const struct snd_kcontrol_new tas
 static void tas2781_apply_calib(struct tasdevice_priv *tas_priv)
 {
 	static const unsigned char page_array[CALIB_MAX] = {
-		0x17, 0x18, 0x18, 0x0d, 0x18
+		0x17, 0x18, 0x18, 0x13, 0x18,
 	};
 	static const unsigned char rgno_array[CALIB_MAX] = {
-		0x74, 0x0c, 0x14, 0x3c, 0x7c
+		0x74, 0x0c, 0x14, 0x70, 0x7c,
 	};
 	unsigned char *data;
 	int i, j, rc;


