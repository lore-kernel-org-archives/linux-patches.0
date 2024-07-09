Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16D157A48;
	Tue,  9 Jul 2024 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523570; cv=none; b=cKM4hP6+LWykE5TO1yIqS/7PxvLBnZ8t0+fV3Iu1Aj89GM5DBeb+ZOZWm82s6VXS3SYEgrTE+8KMybEFQk8N7mXP1TlQFc7Vk72ZfFQs3v2qSRXnNtXWCwyYzZKMBhnjyid2DTEx9+VeC7fKOyc8pTGd2qg1UJzNC3xyjoD67Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523570; c=relaxed/simple;
	bh=KMnNMP6Tvq5kGuy/wAGnXzg6WrzE1WLedY4I59ysf3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgxkQAIhmB7vih2Aq6HILNPqr8gWfv8Q0BClCr6RvnwR3NnxH4LTVZDvKnmsHtri+rAa4tnj677CH2IrEMonnAEqBlXp5leGe3hO8D1rqK/e5oMLjx6HbCi+ZAzJok/KJQvDmzCf8bsdw9bsP6VTeHuVff+joRT5TP6u1pdkou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqwEzezc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqwEzezc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F81C4AF0A;
	Tue,  9 Jul 2024 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523570;
	bh=KMnNMP6Tvq5kGuy/wAGnXzg6WrzE1WLedY4I59ysf3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqwEzezczdGQzVfGRON1iS5WREvi2zaw7m346PmBchouoMARsbIgeJDiCfE3ULJau
	 Uk1Z+V3bKsWVyCSq4yKsNtgBIvtA4LY4+ZYuBoyflvmJTMjVOUPFlz0/F3yJlpnsbQ
	 Hq9ApdfJS/FLJlZyvWGgJ8Ka+F8OghHP6RRIXB/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/139] media: dvb-frontends: tda18271c2dd: Remove casting during div
Date: Tue,  9 Jul 2024 13:08:56 +0200
Message-ID: <20240709110659.559099071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit e9a844632630e18ed0671a7e3467431bd719952e ]

do_div() divides 64 bits by 32. We were adding a casting to the divider
to 64 bits, for a number that fits perfectly in 32 bits. Remove it.

Found by cocci:
drivers/media/dvb-frontends/tda18271c2dd.c:355:1-7: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.
drivers/media/dvb-frontends/tda18271c2dd.c:331:1-7: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.

Link: https://lore.kernel.org/linux-media/20240429-fix-cocci-v3-8-3c4865f5a4b0@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/tda18271c2dd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index a348344879433..fd928787207ed 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -328,7 +328,7 @@ static int CalcMainPLL(struct tda_state *state, u32 freq)
 
 	OscFreq = (u64) freq * (u64) Div;
 	OscFreq *= (u64) 16384;
-	do_div(OscFreq, (u64)16000000);
+	do_div(OscFreq, 16000000);
 	MainDiv = OscFreq;
 
 	state->m_Regs[MPD] = PostDiv & 0x77;
@@ -352,7 +352,7 @@ static int CalcCalPLL(struct tda_state *state, u32 freq)
 	OscFreq = (u64)freq * (u64)Div;
 	/* CalDiv = u32( OscFreq * 16384 / 16000000 ); */
 	OscFreq *= (u64)16384;
-	do_div(OscFreq, (u64)16000000);
+	do_div(OscFreq, 16000000);
 	CalDiv = OscFreq;
 
 	state->m_Regs[CPD] = PostDiv;
-- 
2.43.0



