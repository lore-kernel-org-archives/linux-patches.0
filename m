Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA8566C5F;
	Mon, 31 Aug 2026 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184084; cv=none; b=R3Pb17ejqXGEwbzv72P78Kt57Zfuz5zRTsH8xDB+onUG8a1g6sVvWLW3Yoft6xtF13YyG+jKeYgdsM9VFvtfUOQMdO+2SWuSuoH41dEuLkAjbcf6978vWHMp9f/bY+xV0ph+TpC4KUs6kUgVsj+bf9c0xxLryChPUjrmrhYrnZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184084; c=relaxed/simple;
	bh=U2XRPCwkqkuVmWTwo/jYyyU/gK4LXxE20jBT0wMIklM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpggX4kihBCbPoWKWA5b2nACqc1ZNukpc97sxngORj3X5iN2d92udmINr1CTmjRqwXw27As9/+sRMW/OrUZ690oJh9aX90zGmU+PZyyezy6bKL3lN2roY/l/SM1h0V2o1N4Kr/UzfOeV44f5Qkl6zujDe1HDyZfv0VqUJREocZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5/Ice3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5/Ice3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFB1F000E9;
	Mon, 31 Aug 2026 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184081;
	bh=5N3H78EAsd0BCuJJJPPGx3/ziWzyxkZx0c0StmECtgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5/Ice3n7CEDB8uKhmVZwONvbFSJoBMLIrHYyuKHV1PAC6tMZSvwoPNH3C1MdruK6
	 gOTlSVcc2Q4Hwpi12i+AGpx33e4IKGLFH8evM8s2NCkaT1mAbzYnBB4aBmg6X3hGPX
	 30WuKg/1TS8yY93fIb/cZ0If5Hqiq7TOxsMz87fJxT0mjOPmBdV4zb6b2xPhSaVpiQ
	 GLwfn89+glqa5MYUgGOymXn9CgNVWCzYhBqkkSA8L0yZ2VJNPjGalEobuOuUv+z9+l
	 IObvPSlC44xWbayBRE6dbRQEd1o8uUeGN55nDiJcTVU25+KX4MqcNpzloZj7y9i+Df
	 /W4Saa76wh9Jg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gleb Sonichev <sonichev555@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mjg59@srcf.ucam.org,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table
Date: Mon, 31 Aug 2026 09:28:28 -0400
Message-ID: <20260831133314.4125787-480-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Gleb Sonichev <sonichev555@gmail.com>

[ Upstream commit bfe91a80b13f8068f6fa07aa8c468d284150d4ad ]

The Inspiron N5110 needs the touchpad LED quirk (Vostro V130 quirk)
to properly control the touchpad LED. Add its DMI identifier
to the existing quirk table, next to the similar Inspiron M5110 entry.

Tested on Dell Inspiron N5110.
The touchpad LED works correctly with this quirk enabled.

Signed-off-by: Gleb Sonichev <sonichev555@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260525100047.20046-1-sonichev555@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished; they don't change the earlier
**YES** verdict.

- **N5110/M5110 grep:** No commit for this N5110 quirk in the tree.
  Broad `--grep="N5110"`/`"M5110"` hits were unrelated (WM5110 codec,
  `dell-wmi` on M5110). The touchpad LED quirk for M5110 is still only
  `2a748853ca395c` (2011).
- **Author search:** Gleb Sonichev has no other commits in this checkout
  — this looks like a one-off hardware report.
- **Similar quirk history:** Found the usual precedent commits
  (`a2174ba29a302` typo fix, `89a8f23fee5ef` Latitude 7520 quirk), which
  matches the established pattern for these DMI table additions.

 drivers/platform/x86/dell/dell-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index 053f40572bf6e..89e85c7f7132a 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -222,6 +222,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron N5110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N5110"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Dell Vostro 3360",
-- 
2.53.0

