Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E61E11184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946D4C433C8;
	Mon, 11 Sep 2023 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440910;
	bh=NxS38fLDmPC5hed8OXbHplrxQwMQW5AmnxOE/uDC9SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuuqj4swzSpk22h9ZGaU0QAXPhqlhatasuKs5MLXZ9JO9YwEkruwy2JcQJafeIBhI
	 Zsz3iVfA/t981mTqhvpnslPBCz9Oq8V+EK76MTGBkJzwQsKQd37I81SjKIitxXr1+q
	 5lt/ASpwX1sdI82iQe6+47gaFFXnm63ZFYDEkgy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 202/739] ASoC: cs43130: Fix numerator/denominator mixup
Date: Mon, 11 Sep 2023 15:40:01 +0200
Message-ID: <20230911134656.826840131@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit a9e7c964cea4fb1541cc81a11d1b2fd135f4cf38 ]

In converting to using the standard u16_fract type, commit [1] made the
obvious mistake and failed to take account of the difference in
numerator and denominator ordering, breaking all uses of the cs43130
codec.

Fix it.

[1] commit e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")

Fixes: e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230621153229.1944132-1-phil@raspberrypi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.h | 138 ++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/sound/soc/codecs/cs43130.h b/sound/soc/codecs/cs43130.h
index 1dd8936743132..90e8895275e77 100644
--- a/sound/soc/codecs/cs43130.h
+++ b/sound/soc/codecs/cs43130.h
@@ -381,88 +381,88 @@ struct cs43130_clk_gen {
 
 /* frm_size = 16 */
 static const struct cs43130_clk_gen cs43130_16_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	10, }, },
-	{ 22579200,	44100,		.v = { 32,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	5, }, },
-	{ 22579200,	88200,		.v = { 16,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	10, }, },
-	{ 22579200,	176400,		.v = { 8,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	20, }, },
-	{ 22579200,	352800,		.v = { 4,	1, }, },
-	{ 22579200,	384000,		.v = { 147,	40, }, },
-	{ 24576000,	32000,		.v = { 48,	1, }, },
-	{ 24576000,	44100,		.v = { 5120,	147, }, },
-	{ 24576000,	48000,		.v = { 32,	1, }, },
-	{ 24576000,	88200,		.v = { 2560,	147, }, },
-	{ 24576000,	96000,		.v = { 16,	1, }, },
-	{ 24576000,	176400,		.v = { 1280,	147, }, },
-	{ 24576000,	192000,		.v = { 8,	1, }, },
-	{ 24576000,	352800,		.v = { 640,	147, }, },
-	{ 24576000,	384000,		.v = { 4,	1, }, },
+	{ 22579200,	32000,		.v = { 10,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	32, }, },
+	{ 22579200,	48000,		.v = { 5,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	16, }, },
+	{ 22579200,	96000,		.v = { 10,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	8, }, },
+	{ 22579200,	192000,		.v = { 20,	147, }, },
+	{ 22579200,	352800,		.v = { 1,	4, }, },
+	{ 22579200,	384000,		.v = { 40,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	48, }, },
+	{ 24576000,	44100,		.v = { 147,	5120, }, },
+	{ 24576000,	48000,		.v = { 1,	32, }, },
+	{ 24576000,	88200,		.v = { 147,	2560, }, },
+	{ 24576000,	96000,		.v = { 1,	16, }, },
+	{ 24576000,	176400,		.v = { 147,	1280, }, },
+	{ 24576000,	192000,		.v = { 1,	8, }, },
+	{ 24576000,	352800,		.v = { 147,	640, }, },
+	{ 24576000,	384000,		.v = { 1,	4, }, },
 };
 
 /* frm_size = 32 */
 static const struct cs43130_clk_gen cs43130_32_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	20, }, },
-	{ 22579200,	44100,		.v = { 16,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	10, }, },
-	{ 22579200,	88200,		.v = { 8,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	20, }, },
-	{ 22579200,	176400,		.v = { 4,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	40, }, },
-	{ 22579200,	352800,		.v = { 2,	1, }, },
-	{ 22579200,	384000,		.v = { 147,	80, }, },
-	{ 24576000,	32000,		.v = { 24,	1, }, },
-	{ 24576000,	44100,		.v = { 2560,	147, }, },
-	{ 24576000,	48000,		.v = { 16,	1, }, },
-	{ 24576000,	88200,		.v = { 1280,	147, }, },
-	{ 24576000,	96000,		.v = { 8,	1, }, },
-	{ 24576000,	176400,		.v = { 640,	147, }, },
-	{ 24576000,	192000,		.v = { 4,	1, }, },
-	{ 24576000,	352800,		.v = { 320,	147, }, },
-	{ 24576000,	384000,		.v = { 2,	1, }, },
+	{ 22579200,	32000,		.v = { 20,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	16, }, },
+	{ 22579200,	48000,		.v = { 10,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	8, }, },
+	{ 22579200,	96000,		.v = { 20,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	4, }, },
+	{ 22579200,	192000,		.v = { 40,	147, }, },
+	{ 22579200,	352800,		.v = { 1,	2, }, },
+	{ 22579200,	384000,		.v = { 80,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	24, }, },
+	{ 24576000,	44100,		.v = { 147,	2560, }, },
+	{ 24576000,	48000,		.v = { 1,	16, }, },
+	{ 24576000,	88200,		.v = { 147,	1280, }, },
+	{ 24576000,	96000,		.v = { 1,	8, }, },
+	{ 24576000,	176400,		.v = { 147,	640, }, },
+	{ 24576000,	192000,		.v = { 1,	4, }, },
+	{ 24576000,	352800,		.v = { 147,	320, }, },
+	{ 24576000,	384000,		.v = { 1,	2, }, },
 };
 
 /* frm_size = 48 */
 static const struct cs43130_clk_gen cs43130_48_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 147,	100, }, },
-	{ 22579200,	44100,		.v = { 32,	3, }, },
-	{ 22579200,	48000,		.v = { 49,	5, }, },
-	{ 22579200,	88200,		.v = { 16,	3, }, },
-	{ 22579200,	96000,		.v = { 49,	10, }, },
-	{ 22579200,	176400,		.v = { 8,	3, }, },
-	{ 22579200,	192000,		.v = { 49,	20, }, },
-	{ 22579200,	352800,		.v = { 4,	3, }, },
-	{ 22579200,	384000,		.v = { 49,	40, }, },
-	{ 24576000,	32000,		.v = { 16,	1, }, },
-	{ 24576000,	44100,		.v = { 5120,	441, }, },
-	{ 24576000,	48000,		.v = { 32,	3, }, },
-	{ 24576000,	88200,		.v = { 2560,	441, }, },
-	{ 24576000,	96000,		.v = { 16,	3, }, },
-	{ 24576000,	176400,		.v = { 1280,	441, }, },
-	{ 24576000,	192000,		.v = { 8,	3, }, },
-	{ 24576000,	352800,		.v = { 640,	441, }, },
-	{ 24576000,	384000,		.v = { 4,	3, }, },
+	{ 22579200,	32000,		.v = { 100,	147, }, },
+	{ 22579200,	44100,		.v = { 3,	32, }, },
+	{ 22579200,	48000,		.v = { 5,	49, }, },
+	{ 22579200,	88200,		.v = { 3,	16, }, },
+	{ 22579200,	96000,		.v = { 10,	49, }, },
+	{ 22579200,	176400,		.v = { 3,	8, }, },
+	{ 22579200,	192000,		.v = { 20,	49, }, },
+	{ 22579200,	352800,		.v = { 3,	4, }, },
+	{ 22579200,	384000,		.v = { 40,	49, }, },
+	{ 24576000,	32000,		.v = { 1,	16, }, },
+	{ 24576000,	44100,		.v = { 441,	5120, }, },
+	{ 24576000,	48000,		.v = { 3,	32, }, },
+	{ 24576000,	88200,		.v = { 441,	2560, }, },
+	{ 24576000,	96000,		.v = { 3,	16, }, },
+	{ 24576000,	176400,		.v = { 441,	1280, }, },
+	{ 24576000,	192000,		.v = { 3,	8, }, },
+	{ 24576000,	352800,		.v = { 441,	640, }, },
+	{ 24576000,	384000,		.v = { 3,	4, }, },
 };
 
 /* frm_size = 64 */
 static const struct cs43130_clk_gen cs43130_64_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	40, }, },
-	{ 22579200,	44100,		.v = { 8,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	20, }, },
-	{ 22579200,	88200,		.v = { 4,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	40, }, },
-	{ 22579200,	176400,		.v = { 2,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	80, }, },
+	{ 22579200,	32000,		.v = { 40,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	8, }, },
+	{ 22579200,	48000,		.v = { 20,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	4, }, },
+	{ 22579200,	96000,		.v = { 40,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	2, }, },
+	{ 22579200,	192000,		.v = { 80,	147, }, },
 	{ 22579200,	352800,		.v = { 1,	1, }, },
-	{ 24576000,	32000,		.v = { 12,	1, }, },
-	{ 24576000,	44100,		.v = { 1280,	147, }, },
-	{ 24576000,	48000,		.v = { 8,	1, }, },
-	{ 24576000,	88200,		.v = { 640,	147, }, },
-	{ 24576000,	96000,		.v = { 4,	1, }, },
-	{ 24576000,	176400,		.v = { 320,	147, }, },
-	{ 24576000,	192000,		.v = { 2,	1, }, },
-	{ 24576000,	352800,		.v = { 160,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	12, }, },
+	{ 24576000,	44100,		.v = { 147,	1280, }, },
+	{ 24576000,	48000,		.v = { 1,	8, }, },
+	{ 24576000,	88200,		.v = { 147,	640, }, },
+	{ 24576000,	96000,		.v = { 1,	4, }, },
+	{ 24576000,	176400,		.v = { 147,	320, }, },
+	{ 24576000,	192000,		.v = { 1,	2, }, },
+	{ 24576000,	352800,		.v = { 147,	160, }, },
 	{ 24576000,	384000,		.v = { 1,	1, }, },
 };
 
-- 
2.40.1



