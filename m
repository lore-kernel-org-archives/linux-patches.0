Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD171DDCE;
	Tue, 16 Jul 2024 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145971; cv=none; b=bw31PrrvLIBRQUski/yCB5Q21RznkHqCGe2/Nra7oqjQyf8CudyqlFX5dRAHduZPLz4ai6ptuGXjxLrgvALZnbIUev7SkPi1V4G0FkURMIKBDiYCk69luxOeH2gCFMQD472nrKrrbIifx+lI2qTGOEYVTkESQ8YP2Bl27aBid5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145971; c=relaxed/simple;
	bh=bI96JE8jrEfE5+V1FsUk0u9IimizUuofjXNKymrb36c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgT/0zlK9YCK1hE9llJE1aP/nmWipvU4boV6WZ4YRSmmsqvcHIH+2yoCPeobJg4eV2IfaWhx2IA7U+CxCCSu7A9WdWjyqanK0U4fDnq7SWGz3K/kqAsbV2N6PRfLfqAxKboAqpv1nGZJM9S6MPkVHX0JuugTKqm3iW0gDY+SiBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRgoBR6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRgoBR6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D18BC116B1;
	Tue, 16 Jul 2024 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145971;
	bh=bI96JE8jrEfE5+V1FsUk0u9IimizUuofjXNKymrb36c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRgoBR6X+qMu1H8uXXcNliUUiSfWOHkNW9kosv/g3fpkeLBN5U2KpDaXYYR4qJlzl
	 jCoT4VQjg+SjP9PX9DB7JCpJcTilyrfoeLr8TJaF22KL5gHapkxlLSlQtcNhYtgmq8
	 aeqlEf2qBc1TfA86/D1r3xnukeasHeinO2vH1gIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/144] media: dvb-frontends: tda18271c2dd: Remove casting during div
Date: Tue, 16 Jul 2024 17:31:27 +0200
Message-ID: <20240716152753.235099567@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



