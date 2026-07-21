Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25145306775;
	Tue, 21 Jul 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649612; cv=none; b=MOYLPwazg+xen02fuxJOywRuNuPSSY5PgdTpULCdolqvcVXVrD88ZjQNWEv4DPJRdmVouvydOBr8dvhsjTPRD1dBb8VvFck6VJASuizDQKfv80cjxBBf27woDmOcl80QjYIR3N8WwKbmHWEhdJkuTlv3pAbjUpgZ8osEel87q6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649612; c=relaxed/simple;
	bh=7Tsj7poYXZ18NHNnflQgkkFOk0bjJweRhagm/3mnJHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgumFtD4LGGCwPpMiVfFkyDi3ptDhfSjrB8e+0lMW4+0DrajoOJ8BxJpenAIRiEu4ur2ImdMEQYNdHcFk5veOEWpKOBk1iRkowLa7Vqyqq5hDu+e/cm3qjhLO4eT/13qkX6X7WGttcGgz4+FBW/ZEf5bNmVnpw7Ig1AGxMrH1uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzvUQtTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzvUQtTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4146C1F000E9;
	Tue, 21 Jul 2026 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649609;
	bh=gdtTdoccRjnh7uuICR2YKRI5UIEqxPXan77HrhKQJpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzvUQtTUUbDfNOgXMFOXCvZl7F7LLk5rUXDsOkA0mISvXib9QLqTzfq5mumc81uFQ
	 dDLvhBP+eFTrLXbWqAyGFO34gr0pl5ubfNSZ/kQBYtk5UmKRCsQ52b8pu4OtuWid3G
	 KtJuJsMdeTazXboDJV+541Rmmu67YCPm9NvtdVa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0598/2077] ALSA: aloop: Drop superfluous break
Date: Tue, 21 Jul 2026 17:04:31 +0200
Message-ID: <20260721152606.910258350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



