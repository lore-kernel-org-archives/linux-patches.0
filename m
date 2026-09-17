Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB2058B6CB;
	Thu, 17 Sep 2026 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661216; cv=none; b=bspg7V4Y3+C6BFrcj7qCC4MOAwhwrGt2TPoiX/jResiJsEjvBd0cxAz5FpcFq9aEsyp8XAZhPL2AvqmUMpuac8fWvo5BvQVhbMqIxICBFIrzdrCkxLYWqsFm342DV1I7RRc9gjQp+RkIY9PwxRA1+Jrdl/XBVgtisEsgwGSqUXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661216; c=relaxed/simple;
	bh=36Yx7NBHHLet/vpmBjkmgU4wzRJH2WtypUoOYr9kSnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkBoKK2O+S+mftj8zIkeY1koFdSWDPC2VzURCYNOENrQeNs2OFnp8NsFzbt0LwS8K8MWvaekVtJ9JIMeYxA5QPbE82lp+Y6uKaMbVJZv5LQ7ucw3uRGUotAwQt/a9q/rJeRQEnf2+4XufHLMOtvbQkX9LoL9xDt2FZqoXnCU3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFMDvngZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFMDvngZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2944D1F000FF;
	Thu, 17 Sep 2026 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661214;
	bh=kE8nfsFcmX7agaUtbO4MFOhpnGPTn0umKSRj96ljTP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFMDvngZNO4V72gWUzjT6EnVroFO5uvkXzZ2LQOomqB10aFTvUsl95e6LE4HK3X6G
	 w1eZFyzpIoNH+yzBCkBYYpgvDjXjq9fNZfSVdrKClWea6cJbDeKSO+A1nk02E2E3X5
	 Mhe+4DLCKaE37XipKHZ+u5kCKWmQ/mB06DXlApK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0082/1250] drm/panel-edp: Add AUO B140XTN07.5, AUO B140HAK03.5, AUO B116XTN02.3, AUO B140XTK02.4, AUO B140HAN07.7
Date: Thu, 17 Sep 2026 15:57:57 +0100
Message-ID: <20260917151554.197108890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit 4c34cdb93ea187b46d287a77a8946268a7d24286 ]

The raw EDIDs for each panel:

AUO B140XTN07.5
00 ff ff ff ff ff ff 00 06 af 90 02 00 00 00 00
00 1e 01 04 95 1f 11 78 03 c0 d5 8f 56 58 93 29
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 35 ad 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 35 ad 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 48 0f 1b 7d 20 20 20 00 09

AUO B140HAK03.5
00 ff ff ff ff ff ff 00 06 af 9f 3c 00 00 00 00
00 1f 01 04 95 1f 11 78 03 f5 65 8f 55 5a 93 2a
1f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 b0 36 80 a0 70 38 24 40 10 10
3e 00 35 ae 10 00 00 18 75 24 80 a0 70 38 24 40
10 10 3e 00 35 ae 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 14 0e 1e 7d 20 20 20 01 02

70 20 79 02 00 22 00 14 df 22 02 84 7f 07 9f 00
0f 80 0f 00 37 04 23 00 02 00 0d 00 25 00 09 df
22 02 df 22 02 28 3c 80 81 00 10 72 1a 00 00 03
01 28 3c 00 00 60 50 60 50 3c 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 90

AUO B116XTN02.3
00 ff ff ff ff ff ff 00 06 af ba 49 00 00 00 00
00 23 01 04 95 1a 0e 78 02 6b f5 91 55 54 91 27
22 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 00 90 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 00 90 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 50 05 18 7d 20 20 20 00 7f

AUO B140XTK02.4
00 ff ff ff ff ff ff 00 06 af a8 67 00 00 00 00
28 20 01 04 95 1f 11 78 03 c0 d5 8f 56 58 93 29
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 35 ad 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 35 ad 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 11 23 21 6e 20 20 20 00 8e

AUO B140HAN07.7
00 ff ff ff ff ff ff 00 06 af ad c7 00 00 00 00
21 21 01 04 a5 1f 11 78 03 fa 95 92 56 5a 92 2a
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 56 37 80 bc 70 38 28 40 10 10
3e 00 35 ae 10 00 00 18 e4 24 80 bc 70 38 28 40
10 10 3e 00 35 ae 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 3c ff 0f 3c 96 23 10 28 96 20 20 20 01 66

70 20 79 02 00 22 00 14 5b 29 02 84 7f 07 bb 00
0f 80 0f 00 37 04 27 00 02 00 0d 00 25 01 09 5b
29 02 5b 29 02 28 3c 80 81 00 10 6f 1a 00 00 03
01 28 3c 00 00 8b 11 8b 11 3c 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260506170607.10813-2-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 334d71e282ccd..ad4fd509692d7 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1892,6 +1892,7 @@ static const struct panel_delay delay_80_500_e50_d50 = {
  * Sort first by vendor, then by product ID.
  */
 static const struct edp_panel_entry edp_panels[] = {
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0290, &delay_200_500_e50, "B140XTN07.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x04a4, &delay_200_500_e50, "B122UAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0ba4, &delay_200_500_e50, "B140QAX01.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x105c, &delay_200_500_e50, "B116XTN01.0"),
@@ -1907,17 +1908,20 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x239b, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x255c, &delay_200_500_e50, "B116XTN02.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x30ed, &delay_200_500_e50, "G156HAN03.0"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x3c9f, &delay_200_500_e50, "B140HAK03.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x403d, &delay_200_500_e50, "B140HAN04.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAN04.0"),
 	EDP_PANEL_ENTRY2('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAK01.0",
 			 &auo_b116xa3_mode),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x435c, &delay_200_500_e50, "Unknown"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x49ba, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x52b0, &delay_200_500_e50, "B116XAK02.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x582d, &delay_200_500_e50, "B133UAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x615c, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x635c, &delay_200_500_e50, "B116XAN06.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x639c, &delay_200_500_e50, "B140HAK02.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x643d, &delay_200_500_e50, "B140HAN06.4"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e50, "B140XTK02.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
@@ -1925,6 +1929,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa199, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa7b3, &delay_200_500_e50, "B140UAN04.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc4b4, &delay_200_500_e50, "B116XAT04.1"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc7ad, &delay_200_500_e50, "B140HAN07.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc9a8, &delay_200_500_e50, "B140QAN08.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xcdba, &delay_200_500_e50, "B140UAX01.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xd497, &delay_200_500_e50, "B120XAN01.0"),
-- 
2.53.0



