Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEA5CA40;
	Tue, 16 Jul 2024 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144047; cv=none; b=FkPcuj4ZNojTx6yB1QDWck4M5DhKSGm+SwYEF9qYDI099mjkLLqnbw1Fqp4O0LxpzS/Gi3rxnTvIX0Tu+ka2iLducQF0xJs8YEIcqBDRoaJnoC+h/0YTEUIijAludZ8Dcfjl6Q9Yxh/aec/VwQFQ2XSsHVwcedjoVN8lzhNNdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144047; c=relaxed/simple;
	bh=MVm8RJbDgJFoEbcbO03zviJLDq1JusZe44rKOiuOgw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIWs58Z2odgnlhjwFlAdwJZLIWSinuEXGG6asaIb8lJd7WZ4pReLe8MT5IeXTsYCxjO4Mu6UwcGhhVllqyPhRHkhfp+SLTG9dHHDpzuE59z0AvYZEH1wPuB5MaSz04wpZ4bAjfmVjUCgNRLMO3rctu1laYt0ALvqH0CD99eQPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZYXzVOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZYXzVOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7859C4AF0B;
	Tue, 16 Jul 2024 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144047;
	bh=MVm8RJbDgJFoEbcbO03zviJLDq1JusZe44rKOiuOgw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZYXzVOqmuEh26bDL/OseDSJDS14pfxSQMfyW8fxo2FvQwV9N9mldwww+OGP33OPX
	 KxZwAxtqIwNsIM9aos0F3p/4K6gUGeL2c7Brle3pnZQIQkx0HStztTOxp1j94yq/YB
	 TyzxZLTneNQ5HWNdE/8qXmuAnW6MkDABGa1qq/8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/66] media: dvb-frontends: tda18271c2dd: Remove casting during div
Date: Tue, 16 Jul 2024 17:30:45 +0200
Message-ID: <20240716152738.559333938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5ce58612315da..c399338908d0a 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -345,7 +345,7 @@ static int CalcMainPLL(struct tda_state *state, u32 freq)
 
 	OscFreq = (u64) freq * (u64) Div;
 	OscFreq *= (u64) 16384;
-	do_div(OscFreq, (u64)16000000);
+	do_div(OscFreq, 16000000);
 	MainDiv = OscFreq;
 
 	state->m_Regs[MPD] = PostDiv & 0x77;
@@ -369,7 +369,7 @@ static int CalcCalPLL(struct tda_state *state, u32 freq)
 	OscFreq = (u64)freq * (u64)Div;
 	/* CalDiv = u32( OscFreq * 16384 / 16000000 ); */
 	OscFreq *= (u64)16384;
-	do_div(OscFreq, (u64)16000000);
+	do_div(OscFreq, 16000000);
 	CalDiv = OscFreq;
 
 	state->m_Regs[CPD] = PostDiv;
-- 
2.43.0



