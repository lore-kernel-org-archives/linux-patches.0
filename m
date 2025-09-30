Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CD52032D;
	Tue, 30 Sep 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246043; cv=none; b=dl6bmP+UY8pLrMnbwTT2JS5Us2IY/WGwfBiXKoJczbpzMo7qd6aISjHKUFnzcchz6hSVzBdU6aFIUXGJ4uO3MtYuHYsXeZTY/Et0pdZCXGQjOdsZahXq0F/Cs8Bi/5JwVxfFOn/1fB72enYfGEVnftuoN6I6LBOFDanBawYAjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246043; c=relaxed/simple;
	bh=FQCRqYrqGAeWINtwYbokR1svpp+EPw60qfQmS7lf3PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FexuqhnatRp4Tw6LU2PxbTvGHgLYMo8h8vOnjblLUYQATEpUmI6njiTedNwoNtNEVHPYbxcyFwhZdv2AMyyrYzTCEgsdYhdH2WCl8zB/L00i4Q2fG9FggHqYQnCG8tKB3CJsxtXcM8qAWhUASPyH5bj/hMJFeOfwXbVoOkjJwlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9Zt5urO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9Zt5urO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574D7C4CEF0;
	Tue, 30 Sep 2025 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246042;
	bh=FQCRqYrqGAeWINtwYbokR1svpp+EPw60qfQmS7lf3PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9Zt5urO8vIRIRXZdplEPVhqDmVPVA7le9/1G6t3MeWtGTH7S6z46T3C6JMbo/zZo
	 PwWUTaI5hVFRxY/oPbZLbocoghpwuxarDRDroRK4vdstXDPPxjGO35D+8918+qGKej
	 kVjoSb+7PorfbBRh64mAaIuBuiCb03rgrYB+xIxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/89] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:20 +0200
Message-ID: <20250930143822.126178194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78c0feb7dcdb7..1eae6e83d0259 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1737,7 +1737,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
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



