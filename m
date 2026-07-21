Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACEF415F3E;
	Tue, 21 Jul 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656522; cv=none; b=IN3TZSPOhBhSZ7b1/9ZauNb3F3WuomuNInqyDGdMoRTscQLxKE+P3FLsHirXEOJMXH3qlhEw1pI0lZPr3/q2Z440ol3aqaUz0cM/po/7m3lqBA+/MIDrorrW4fInTIyLXQOMVf2bPnUCobnvuwu5yu8mRcUnNvaijS9DHcgFZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656522; c=relaxed/simple;
	bh=hrQiq1QVUla84dQV0nGHtcvOPYqEcjB+DML/PVAe0ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAGMt9up4oO8tHxN3LasvtjneH3x+0kSxBHrISE6CSO3R6lhOB6+glS5xnU50rt8zllPg1ytdQt3qotA+KgNjtVmk6S2PVaYLDpnSGYirsPzaBy+O8o6St+BM3uLGrCgujzhvFJn8nJpwhoXPSsdQqdO36PCwvLVUZz+ADYDkPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFiu8O1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFiu8O1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B061F000E9;
	Tue, 21 Jul 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656521;
	bh=z2kKheDVe29J+pijHLiuZXC3PqrrkHb8R1GPD7DlyE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFiu8O1EpSoJJnKTlQyXJAWQXvj/fWHo+fS1Mw+VGV4m3l5yTkkYD9oD8K6wUOSAY
	 TxrUkwb+n3Mxir2QrwffjXXEJjT6Nq7Rt/bDUeolNiLEyXm3JgiVY9nW0c8rzhUCoO
	 Rl6UTzW/3EONSiBD5OM+mo5SSa2mlSmOck+VpnOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0417/1611] ALSA: aloop: Drop superfluous break
Date: Tue, 21 Jul 2026 17:08:53 +0200
Message-ID: <20260721152524.641418989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 123fd13f35ccaf7d2b98f5a8cc6c8a3de378568d ]

At converting the spinlock to guard(), a break statement was put in
the scoped_guard block in loopback_jiffies_timer_function(), but it's
obviously superfluous (although it's harmless).  Better to drop it for
avoiding confusion.

Fixes: 1ef2cb6b29c2 ("ALSA: aloop: Use guard() for spin locks")
Link: https://patch.msgid.link/20260609074907.726593-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index a37a1695f51c7d..3f8488716a0827 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -728,7 +728,6 @@ static void loopback_jiffies_timer_function(struct timer_list *t)
 			if (dpcm->period_update_pending) {
 				dpcm->period_update_pending = 0;
 				period_elapsed = true;
-				break;
 			}
 		}
 	}
-- 
2.53.0



