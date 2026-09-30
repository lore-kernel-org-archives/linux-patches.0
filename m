Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792973BC68E;
	Wed, 30 Sep 2026 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794797; cv=none; b=DbM5CfAsgawGNqwe3j82MxBY4H4gageFltnQiRVQ77hNEctyhrpwD0ziBNqxq3Qq22lAhJCYGcRanMyEeSJqOjsfsZRf0eNupjG7pdxHIXWEaoTOc2iUVflaiT+oL9xkCLvRxVmPiM3GPZ+BuiRiM5IB9qYaYV11SNKAO/lDQvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794797; c=relaxed/simple;
	bh=94UdaaEUkxFfnVqHOZ5cIvOzFGuUohNpaUf5OIgxaB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2WQ0dylZjiXloQMjxpjXa34gtDV+sCz59q0AxV3knuF/vCQXKr02+BtaPtJSDX6HL4sxLA4IAvHQqXv2vo9xKQTnKOzCibMI/Qx6HEUEijY6tM5MCrEU+/aV/LCsk1ALE6xM9MnGvR67rhpJUzmXmW1HPnIJK3noKZRrKze0o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cx9XzNSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cx9XzNSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53481F000FF;
	Wed, 30 Sep 2026 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794796;
	bh=e+Oz/s8Y4Ab+Iu90cvGMuRxG9/PAmaawtZ3Oo17Ihp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx9XzNSEiZpdEsXLoBDgduz/sTJlcsSclnMB8jGb+vfFwSX/BZOEpNJ84/k5pbMe4
	 6A7vb/SZsWAv95wh3ZD6vF4EquP8FKbWnNyWmiiqajiK943SNw4nOhoUBm/5wHeldk
	 e/fSvbpcBz2uFbhQVtKvbBVjBcUXzeAhp/56t+80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	CuerdOS Dev Team <cuerdoslinux@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0338/1193] ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx
Date: Wed, 30 Sep 2026 17:17:02 +0200
Message-ID: <20260930152441.666012896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 38417f5fc8e3323218c19bd7e419eec4fb0697bd ]

Add DMI quirk to enable ACP6x sound card for HP Victus by HP Laptop
16-e1xxx, which fixes microphone not working issue.

Without this quirk, the DMIC on acp6x device is not properly enabled,
causing the microphone to not work.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218926
Link: https://github.com/CuerdOS/linux-kernel-nhs/commit/b29ba27a0ed672664071b4b345e63b62a419d31d
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Reported-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Signed-off-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Link: https://patch.msgid.link/20260730123920.104525-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8699ad79f060e..ed99d43fe0592 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -668,6 +668,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Laptop 16-e1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



