Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880D3C465;
	Tue, 30 Sep 2025 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243924; cv=none; b=o+nCkV3k/9bKXWg+l8oRcMcOq9ghIHOJ6syP4WWBebsFY/IpkshbUDJVpAzZml4Y0+FlqMDy6y5c/WVBvnk+nsU6aQoxZEaKb+9OJuPVQ5KodaMYeNssEGE6v/f9O3W0/XvgtQ6Sv/nCByjdeakGlMwpbax0oexuMeU1K6jDr3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243924; c=relaxed/simple;
	bh=l/HgeIS/O1J7a7/baoEZF1HEhpSW9euSvIUC8ii8Uog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyOODLclTDzCU13g6BC4lqvTlPqG/9zhji8PY+AnS9vpC7JH0m49LYGqS+jcrs5y5Vvy5PM5NDhNd1xpupqzOmv4jEmkNoMk4GVc7QQ+rd30W4B00gkqPmpaE0fVB9bR4nqRqTBwUQm6TU/tTeSH3u/Vo+hmALPqgWzovnJ957o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ynu+XoWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ynu+XoWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4FBC4CEF0;
	Tue, 30 Sep 2025 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243924;
	bh=l/HgeIS/O1J7a7/baoEZF1HEhpSW9euSvIUC8ii8Uog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ynu+XoWeZmPGayVcnDFSgKxDiEMRZn0UBGVIQDUaaMbxNHREmz1A2LYSF/yteZa3I
	 a1NjCGmtYl5Ayi5LjrCkdG2D5DgpuueeAvKo3lTZy5bLuIpwOlvkj6kZ63IK+e/ZjJ
	 c0oS/yZ2cae88exDy+cwHwN8zDjVHZZRVfXgyAZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/81] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:58 +0200
Message-ID: <20250930143822.024231027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 03ddd3bdb94df3edb1f2408b57cfb00b3d92a208 ]

Handle report from checkpatch.pl:

  CHECK: multiple assignments should be avoided

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-6-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 96397a4fdf873..22f483fee5f8c 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1592,7 +1592,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
 	unsigned int pval, pval_old;
 	int err;
 
-	pval = pval_old = kcontrol->private_value;
+	pval = kcontrol->private_value;
+	pval_old = pval;
 	pval &= 0xfffff0f0;
 	pval |= (ucontrol->value.iec958.status[1] & 0x0f) << 8;
 	pval |= (ucontrol->value.iec958.status[0] & 0x0f);
-- 
2.51.0



