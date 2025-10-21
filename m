Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354ED350A0D;
	Tue, 21 Oct 2025 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077409; cv=none; b=jZ5/5dmYWg87yWC//pYBQT4W2ro5QOGmitEQoDGz34d8HTeTYuP4E/kCqZ6Q7h8T6d+KtympbvLAXrcFwWgCqrmykqr8WJP/YFWel59JnnMgJGZiS3PtkOWFRXawnatwBjU8e/zwRry1YlAqZwlAg39ID1eiqceMMrlvu9L0EFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077409; c=relaxed/simple;
	bh=ng4rekKwuBfKqLd5ZuxSeaqrcffjzOW262wuGcZbQNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpw9qcB73zUDBNj/ELyg3sz1nvQbxibIqmaU68yPmiQR3l1hS7dh7v00MvHCxNpwTz/NXI/EjZ2HkBbubFMqb8e91th3RTRnVxhHrwsIHAmcO88svUmn5zCzH4RrfDFeDYShwZH9Mvb4zv/btNhim3UjK83slFwQ06ffxSI3VNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k21urNBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k21urNBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C33AC4CEF1;
	Tue, 21 Oct 2025 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077409;
	bh=ng4rekKwuBfKqLd5ZuxSeaqrcffjzOW262wuGcZbQNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k21urNBwVjyHXMd37OvBjJ7TxkEixNq9+g8uxMJr1r9Ld+ZKQNlk34Q/0xZbG/R9y
	 kTOp84rrRcSBKqsWN557gIDYawwFnBlrjZEIk822GZcqAIsHjp9vRZTcXVHeS1lEUb
	 u0sAV0CdLhR0kOTvo8d+BJbjQsbnjXGbr9pmo8ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 097/159] ASoC: codecs: Fix gain setting ranges for Renesas IDT821034 codec
Date: Tue, 21 Oct 2025 21:51:14 +0200
Message-ID: <20251021195045.515994742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 6370a996f308ea3276030769b7482b346e7cc7c1 ]

The gain ranges specified in Renesas IDT821034 codec documentation
are [-3dB;+13dB] in the transmit path (ADC) and [-13dB;+3dB] in the
receive path (DAC). Allthough the registers allow programming values
outside those ranges, the signal S/N and distorsion are only
guaranteed in the specified ranges.

Set ranges to the specified ones.

Fixes: e51166990e81 ("ASoC: codecs: Add support for the Renesas IDT821034 codec")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://patch.msgid.link/2bd547194f3398e6182f770d7d6be711c702b4b2.1760029099.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/idt821034.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/idt821034.c b/sound/soc/codecs/idt821034.c
index a03d4e5e7d144..cab2f2eecdfba 100644
--- a/sound/soc/codecs/idt821034.c
+++ b/sound/soc/codecs/idt821034.c
@@ -548,14 +548,14 @@ static int idt821034_kctrl_mute_put(struct snd_kcontrol *kcontrol,
 	return ret;
 }
 
-static const DECLARE_TLV_DB_LINEAR(idt821034_gain_in, -6520, 1306);
-#define IDT821034_GAIN_IN_MIN_RAW	1 /* -65.20 dB -> 10^(-65.2/20.0) * 1820 = 1 */
-#define IDT821034_GAIN_IN_MAX_RAW	8191 /* 13.06 dB -> 10^(13.06/20.0) * 1820 = 8191 */
+static const DECLARE_TLV_DB_LINEAR(idt821034_gain_in, -300, 1300);
+#define IDT821034_GAIN_IN_MIN_RAW	1288 /* -3.0 dB -> 10^(-3.0/20.0) * 1820 = 1288 */
+#define IDT821034_GAIN_IN_MAX_RAW	8130 /* 13.0 dB -> 10^(13.0/20.0) * 1820 = 8130 */
 #define IDT821034_GAIN_IN_INIT_RAW	1820 /* 0dB -> 10^(0/20) * 1820 = 1820 */
 
-static const DECLARE_TLV_DB_LINEAR(idt821034_gain_out, -6798, 1029);
-#define IDT821034_GAIN_OUT_MIN_RAW	1 /* -67.98 dB -> 10^(-67.98/20.0) * 2506 = 1*/
-#define IDT821034_GAIN_OUT_MAX_RAW	8191 /* 10.29 dB -> 10^(10.29/20.0) * 2506 = 8191 */
+static const DECLARE_TLV_DB_LINEAR(idt821034_gain_out, -1300, 300);
+#define IDT821034_GAIN_OUT_MIN_RAW	561 /* -13.0 dB -> 10^(-13.0/20.0) * 2506 = 561 */
+#define IDT821034_GAIN_OUT_MAX_RAW	3540 /* 3.0 dB -> 10^(3.0/20.0) * 2506 = 3540 */
 #define IDT821034_GAIN_OUT_INIT_RAW	2506 /* 0dB -> 10^(0/20) * 2506 = 2506 */
 
 static const struct snd_kcontrol_new idt821034_controls[] = {
-- 
2.51.0



