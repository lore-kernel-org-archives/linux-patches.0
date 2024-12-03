Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35973BB24;
	Tue,  3 Dec 2024 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236400; cv=none; b=sPDoINU2RLHi3Mv+ArcdwhIN9MnfxSblqbBma5jtkoYVgubNO0RAite6fGQ+UWSYZDcALnwMPC4/CBSxCsb8YrOQNSKliz5aZ6UWsyhI227lLvbHXvkXcXXRXSKnxV1+bk8oPGmIvsmGlAMApqUVmtsj11W5b5ae6ZnRvkTb40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236400; c=relaxed/simple;
	bh=9YqSgEgYK8J6t5N8xhqsjaTZO3fAZTQDrduM7+CJ6G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMe9yqeJmDoP4bf8UNX/nqY5y/CyXboc3j11Odow9fulJofBPeYiSv10GvMBaClm25nZOMRIWw+rhgo5t/VHTpRHaO+XJBD8dlUSxjGHTtM/7BkZ+kxkWUW2LBe/o67BPkZw2HvVmZUQIrPP7s3x7KJt8a6lpcoyyJnLXzmiqSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgFzRzDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgFzRzDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCACC4CECF;
	Tue,  3 Dec 2024 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236399;
	bh=9YqSgEgYK8J6t5N8xhqsjaTZO3fAZTQDrduM7+CJ6G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgFzRzDJKE4pMGcJqYxn633GCteZOcnayE3teZ90Sr9k4r5P7tghNYQgq6O8OdARX
	 PeuR3W8jfZLQyiMkgj3fF1hyeiSCAeUzuUYP46/jSS5OZjkSn27uqk4k1Yqq+N3HK8
	 IvkSnJHorXji2MbaihmWkYINW+3rsM2MxdzDFv+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/138] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet
Date: Tue,  3 Dec 2024 15:30:39 +0100
Message-ID: <20241203141923.933779059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0107f28f135231da22a9ad5756bb16bd5cada4d5 ]

The Vexia Edu Atla 10 tablet mostly uses the BYTCR tablet defaults,
but as happens on more models it is using IN1 instead of IN3 for
its internal mic and JD_SRC_JD2_IN4N instead of JD_SRC_JD1_IN4P
for jack-detection.

Add a DMI quirk for this to fix the internal-mic and jack-detection.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241024211615.79518-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 16e2ab2903754..2ed63866e9cc6 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -879,6 +879,21 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Vexia Edu Atla 10 tablet */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "08/25/2014"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF2 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Voyo Winpad A15 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
-- 
2.43.0



