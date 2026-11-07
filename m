Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061153;
	b=lRZ5aFT9hwCDSeEbPc7kGpIT94lhXKsXr0M15C2uR1kMpPHRV9+IvpmcberKX7a/BvAV
	 F2K14vV4ACNLFb6K7dr2QIKN0AnY8jw5AuzN89cVNHZuUMw73n/nBIsH7QPtNHlebFdT7
	 XOBe3xO/AnwNplh/DdjqeYwA4fOipknp68r5/fHIGWANchGVCd6aySyVvBUlg+m65qJAQ
	 /X1ZH4A6Z8HuSNwbhN/lL04/MD8nC13wmrDhRDuJJfzct3FXEO7o0YeDWTCG7X/HqJqFj
	 Cdc8PDa4KkXIU6UlJoIdGNuRkCXLR0X1nWdCU47tcLHwciLU2tnv1pkkGs0NOHE0Edg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ccLKGg9gYhFY8GNslR4nt4wDHXCuSMs4ipYHznSs9q0=;
	b=Z1IusNDq/TRwIx849dd/xYgCqreP9AahBMm3Kd3hedDI25Wdy7FccwI9af+sKYWbPDQx
	 OmjjLFgz7LpigFzW4xNU3Rba0xMTBgS2fk7uyISbaXdX9kAlXsCdeIudVuoIb/EafcyrA
	 mg+8jj0TxPzJhNS4ByeYxmQldOGSxHPoXpP9Re8ELOkdS5UC1dLIY5cwES4btjFQ0qxpD
	 2J0gGBa6PjKXL7t0HMsWA6rX81Jh/tTR86xbfKrKfC+2c838HRTUyett/rLE6iAANKdPh
	 EMyISjtH61IcKoLcCN/HG4TL5nkrEc8IMIBTPedRyLWsAXjr3+SBN6q3F8+41XQ1v3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myfT0RZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F7606D805;
	Sat,  7 Nov 2026 14:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myfT0RZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EC01F0089F;
	Sat,  7 Nov 2026 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061153;
	bh=ccLKGg9gYhFY8GNslR4nt4wDHXCuSMs4ipYHznSs9q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myfT0RZz+0w6b3qKTtJSXo4gF1GdrJNcxyVfiWCq6kaUVsL+i74eAVWIjO2Dsh5lr
	 vuPCwtAq7SECjhr1fwoatJ2OtwlPqR8euyDyEykPqQklwCtOoP6jvqhsRAWuVC5NhB
	 dCdTLbSpx6L1BJawYq/1ut3noCBQn6s/6pvqzBBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Firth <jasper.m.f@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0411/1536] ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings
Date: Sat,  7 Nov 2026 08:40:27 -0500
Message-ID: <20261107135009.117687468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6860ac41e6b32..eb66f22461047 100644
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



