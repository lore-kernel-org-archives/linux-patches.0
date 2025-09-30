Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864D0217F55;
	Tue, 30 Sep 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245471; cv=none; b=Dcf19sHJsyTrJtGfimpyCg8wys7fiKjqp0b1nPoYxMnTSJ10zrQ4m8PqcPE7ptpR6wC0uVpA4RfX/rQqhcq99D66XLr5YIrt+zgq60EuiV90FiDWszTeRmRB1/iYhwhQ07kYf7qhjLdl4tbrBvUm0LDsguDaW91O/STNmEFOeU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245471; c=relaxed/simple;
	bh=VELBvQ0lcTioq3cOcEkULi35E/Z1+3R+NBp2u8b1N1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz2br4n6Zm7+X1Mx8YAOhSjQPy8aHcmViuBlOo8JlqaoE/FLjQKoO55b6d/q53v+GK/6frMtgKN9JeXv/TQ0gqGseh8fyodHYvsD9ZQuzrr1avFf6op9m/Wgn+snW5schM5fh3YoQuiFR7WOxnHQptDhOUP8dRH+YVu1OvTsN6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4mLLSdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4mLLSdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DC7C4CEF0;
	Tue, 30 Sep 2025 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245471;
	bh=VELBvQ0lcTioq3cOcEkULi35E/Z1+3R+NBp2u8b1N1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4mLLSdKHY2CbMnor9TORHHd0Covynn6ebkbsKGkrE4W4BttECu7U5ntmkuZDIECU
	 991zAvGE80CAsD7Wq2v09hUTbJA/T13RFUAJuFfBFiF7/fQbmjoLIHhsAlliswrY5o
	 7zfPi74l4cwoLQqbpHmnF60Pk79lUhGrDb4pvwiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/73] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:07 +0200
Message-ID: <20250930143820.681641036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1ab517e26b36..f91dbc9255f12 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1734,7 +1734,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
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



