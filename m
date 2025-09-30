Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE492236EB;
	Tue, 30 Sep 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245220; cv=none; b=jSqEBkgSFeLT18ys+4lPE35wQiPECfpeUUjzkwUTyAx52Ro+xMAprGFs4IPhsSwNO3kGJ7Sv+UHSKjmOG8KaJ9CZ9J2e77jVliKOYRUADLQ/FEcqu1wRrN7WBhkPyecEenkYj5nWhmZ79p1PzxkhNPlxTr6tAMdwoiHBHgcrwAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245220; c=relaxed/simple;
	bh=NI+7K5ppyiZopkFkSfv4imYdRQI3t09RsXNSEiPX+qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngDlKNgPZ93e1upYRULq77QeeSLLcWeehwot08MLnDxPgdjQIFZpt+MBk5XePqOiB1Lq68tHXE3tT0xE4R2tcP2fQAajpO8aEvBn/FDt+ccnw6iSaZ4I/yPzV1MY+G5Yb/AckPZ1U/RKpdz3OoIkPWEB+S8dNFUjaXzfgSZZht4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNTpUK43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNTpUK43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED01C4CEF0;
	Tue, 30 Sep 2025 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245220;
	bh=NI+7K5ppyiZopkFkSfv4imYdRQI3t09RsXNSEiPX+qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNTpUK43Ni9GuLs/lc2ha5w6HpicKGrP98oGD55PpXRK5gupr/+CWjG4i4sfYCNPp
	 /CU1Kzdqwp4oBtT9ghsiuBWVurhdEuqvMYZgZ4g16bIzvnnSrkufu8cYd9dtRBLO5E
	 X1lyQELE4fxCV2F8MjngB1RBmNNCnN9wWl8Iq4lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/151] ALSA: usb-audio: Fix block comments in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:13 +0200
Message-ID: <20250930143831.705627354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 231225d8a20f8668b4fd6601d54a2fac0e0ab7a5 ]

Address a couple of comment formatting issues indicated by
checkpatch.pl:

  WARNING: Block comments use a trailing */ on a separate line

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-4-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 60269535eb554..0e8cf8b06b8ad 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -76,7 +76,8 @@ static int snd_create_std_mono_ctl_offset(struct usb_mixer_interface *mixer,
 	cval->idx_off = idx_off;
 
 	/* get_min_max() is called only for integer volumes later,
-	 * so provide a short-cut for booleans */
+	 * so provide a short-cut for booleans
+	 */
 	cval->min = 0;
 	cval->max = 1;
 	cval->res = 0;
@@ -3524,7 +3525,8 @@ static void snd_dragonfly_quirk_db_scale(struct usb_mixer_interface *mixer,
 					 struct snd_kcontrol *kctl)
 {
 	/* Approximation using 10 ranges based on output measurement on hw v1.2.
-	 * This seems close to the cubic mapping e.g. alsamixer uses. */
+	 * This seems close to the cubic mapping e.g. alsamixer uses.
+	 */
 	static const DECLARE_TLV_DB_RANGE(scale,
 		 0,  1, TLV_DB_MINMAX_ITEM(-5300, -4970),
 		 2,  5, TLV_DB_MINMAX_ITEM(-4710, -4160),
-- 
2.51.0



