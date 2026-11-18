Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043660;
	b=IY7TaFb3Ndofs7MOgP/cmjVFzIezR5jEQnK04O3PiMBBPaBlLgkcnTdA8rI71LHTeyYk
	 yx76Q7PhQSc4k0OmTIWvbiLJjSVibs5OfwwAGWR78GAz+WV/+ZwsPMCkUHrQMSmOQAqrw
	 f0IUvNPMSP6+m/WU4nz4fU2L8aRiE/2QaRQ/TxNyjfoDNezCSr6QdWMSI2zDD3ffN07NV
	 pwL2/omz9EN0wZr4KfjKJ1B7HtgRfDZF5t+nV7t0SjFWBTp0yTmpUf4KCE5YqAO9ubesl
	 mCsbJJKBOwDIAH2fb7fq0Oehu97R7hxeuT4Q9xjwlQLSVI/tVtuL5h2gFF4JfEfXnGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULaRN92UnahkSeRx5peZDXGpRRRXbCQyJZo8uW0fHwk=;
	b=nBazfCPbUnqAYzEYcq2hH+QJszsjxAPykaNILk+uLRn/180h4NUMtJYS6l7rFJ5KLWYl
	 wVoltIXbkR/UCaWtgZ22Zd3+EkM05Nt5m7vyYZuGfSi3t6P1vpaE4UMLYwNFgXdlK9eo5
	 CFMd6gpP8OsKFOShltRUP5TZg1V6VaaXeZgqUaZACDuADQ0+sTtSuBdWNWlkcaZtUAEL2
	 CLBlhdv9gI4Y30mbOJbF06dwzQx8ILUqZjOFLAMebxi2XsggLtsMjdRK5qravCK8bHJUQ
	 MLpK2QDzo9NBP9lNXkV5GQuT8RkL75DLNx0a0kqciUaV1XtpIoB1uGdxKyJH3hMksgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pE7I9rl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E85606A31C;
	Wed, 18 Nov 2026 23:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pE7I9rl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2611F000C4;
	Wed, 18 Nov 2026 23:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043660;
	bh=ULaRN92UnahkSeRx5peZDXGpRRRXbCQyJZo8uW0fHwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pE7I9rlqPIianupqQOodaaTVkJrQisdHO0jBY4McCB+3+LuD79TtgNxkAPYKZ8zQ
	 fmOkDFIVXKCeGLG1Tt5JlpfxPObBgh6P6VnaHp71t6BzKr31Hyn2CZQqL1bmW7GJ0x
	 zA7JKu0vCdXeOJulcWLrj01sTSpI+zMHOW1cDBSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Firth <jasper.m.f@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0290/2857] ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings
Date: Wed, 18 Nov 2026 15:22:04 +0100
Message-ID: <20261118150211.859762016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jasper Firth <jasper.m.f@hotmail.com>

[ Upstream commit c5a8fc2abe05cf6db71f57ff0177fddc59861a1a ]

Some Chuwi Hi8 tablets with model number CWI513 ship with a BIOS
(American Megatrends 5.11, dated 05/21/2016) whose DMI sys_vendor and
product_name are both "Default string". The tested unit is labelled
just "Hi8", but its model number is the same as the existing "Chuwi Hi8
Pro (CWI513)" entry, and it needs the same quirks. That entry matches on
sys_vendor "Hampoo" and product_name "X1D3_C806N", so it never applies
to these units.

Without its quirks the internal speaker, whose amplifier has a
differential input wired across LOUT left and right, cancels to a faint
distorted residual for any centred (L == R) content, and the headphone
channels are swapped.

Add an entry matching board_vendor "Hampoo" and board_name "Cherry Trail
CR", plus the BIOS date since those two are too generic on their own.
drivers/platform/x86/touchscreen_dmi.c already matches the Chuwi HiBook
the same way.

The quirks are those of the existing Hi8 Pro entry, except for the
over-current detection scale factor: 1.0 instead of the 0.75 from
BYT_RT5651_DEFAULT_QUIRKS. With 0.75 and a CTIA headset (inline mic and
one button), loud speech into the mic, and headphone playback coupling
onto the mic line, were reported as spurious KEY_PLAYPAUSE presses, one
of them held for a whole 8 second speech window. With 1.0 the same test
gave no spurious events, and 3 real button presses were reported as
exactly 3 press/release pairs.

Tested on a unit with the generic DMI strings, with a module built from
this patch and no quirk module parameter. The quirks were applied via
the new entry, the card components read "cfg-spk:1 cfg-mic:in2
cfg-hp:lrswap", and the following all work: speaker, headphone left/right
order, jack and headset-mic detection, headset button, and the internal
and headset mics.

The problem was diagnosed with the help of an AI coding assistant, which
also drafted this changelog.

Assisted-by: Claude Opus 5.5
Signed-off-by: Jasper Firth <jasper.m.f@hotmail.com>
Link: https://patch.msgid.link/20260925-hi8-quirk-v1-1-ffd00b0447f9@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5651.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index b9990cb1181ff..4386ced94435a 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -409,6 +409,23 @@ static const struct dmi_system_id byt_rt5651_quirk_table[] = {
 					BYT_RT5651_HP_LR_SWAPPED |
 					BYT_RT5651_MONO_SPEAKER),
 	},
+	{
+		/* Chuwi Hi8 (CWI513) with a BIOS using generic DMI strings */
+		.callback = byt_rt5651_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			/* Above matches are too generic, add bios-date match */
+			DMI_MATCH(DMI_BIOS_DATE, "05/21/2016"),
+		},
+		.driver_data = (void *)(BYT_RT5651_MCLK_EN |
+					BYT_RT5651_JD1_1 |
+					BYT_RT5651_OVCD_TH_2000UA |
+					BYT_RT5651_OVCD_SF_1P0 |
+					BYT_RT5651_IN2_MAP |
+					BYT_RT5651_HP_LR_SWAPPED |
+					BYT_RT5651_MONO_SPEAKER),
+	},
 	{
 		/* Chuwi Vi8 Plus (CWI519) */
 		.callback = byt_rt5651_quirk_cb,
-- 
2.53.0



