Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F055614EC4D;
	Tue,  9 Jul 2024 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524041; cv=none; b=OKTU0LiAcVdWY76FOehfXVcDMGa1Pm2gVLNxa6BS87fVSUSkenkIjWRF5MSIZ9O6FS41Hk8ibJjiQ/jmYLStsx/Btubc1otmQmt6WUu6jCSH4faI/pIKQ1b0Mo6njLhS0QRFCZblwucwNnLAn5YzF6bsU3MrApw4h5I1omYXpwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524041; c=relaxed/simple;
	bh=xkjqiRBKFArgAAN8MITe47KLbWANXXeoD+0jxFoR3Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Xtr7z1IikF+tzUkrRU7Hj/AhZeMGHS8oeoiLp16FD4yxSECK/IesEo29nvsrTNUwNAP0qkTr88dLQt5Npgu5cAr08v5RTIYJjS+0LaFsU3mAGZNgkkfXMMxjiWTTM5ihAfhTDOQvVfLO/8UVJAr1Ev7TGgMsSfDkvMTFvqh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyQm60h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyQm60h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755FEC3277B;
	Tue,  9 Jul 2024 11:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524040;
	bh=xkjqiRBKFArgAAN8MITe47KLbWANXXeoD+0jxFoR3Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyQm60h3/NlInvBK42xNT4Hjng3FViGJbAmqwp2rnIC04JdM3Cnm7SaTht/WMqqib
	 InzfD5fwLrkJnOoNQo6QT5eO37FfJnmylMgPVnXugQkAnuxcvVaUWpkO4aBiJjdoTI
	 bSTW2EJg00pecMJZMIBNhozbz/sDJG1NFdHmUEAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 051/197] media: dvb-frontends: tda18271c2dd: Remove casting during div
Date: Tue,  9 Jul 2024 13:08:25 +0200
Message-ID: <20240709110710.939357407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



