Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5A4D17A8;
	Thu, 17 Sep 2026 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668602; cv=none; b=de6kJosFJP7f9omvCpFewqwzAqNv4y5zF7luj87cbeLpm4ejFgthpkShTri1+qH+KXk7jt6+8z/ANhw9RuMEAerDPO++9bVVReQa/GjIPWVceaqjokKiS65mqzokFDaynIiHkge3aJIkdyrED2KgJST66vTxxObrzPYRFML/BSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668602; c=relaxed/simple;
	bh=lI69ST0VzEb7S8VsfNEpbDEeenRYn2EzOykV+cEpmqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWnKdbIzMxTLPvca8yTHceN12OKNfJBM08KYC9H8CXbjYB5AWw5dAv8GLIOy3l+Yazxx+9x70hweo5hFiBPK4neMcLQO57oeqNBnWZYWo4VOc6otsBhHv6/E1JzTRl0dk/LqdRN6bUYLSmi3wYJDSoDVXpURcbkRIVISpc/+ErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIaXmien; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIaXmien"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCED1F000FF;
	Thu, 17 Sep 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668600;
	bh=q/9eUejTHe2Jz/uh1ftuhEKzo9ad8DZPqhI84HBMz1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIaXmienfYEkBwAB9M/xGEWHZ3JeWoDSiQMyv9+0khdgLi2SBi8D7a/CSnfoQMiUV
	 4cS5xcH0bA97qk8TahR60r+1zpzZ32uBtSmdrucVqc7IItQ8cD+fSGX8TB1r2mdxLJ
	 RKy2Kos8CSBSzuK9q4bdi39Y3o7nKDYyAPVIvOV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Xianglin <1021538027@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0462/1102] ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx
Date: Thu, 17 Sep 2026 16:06:45 +0100
Message-ID: <20260917151551.286979798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Xianglin <1021538027@qq.com>

[ Upstream commit fe21db8c5e7c2a9815a9be54a1f5d556f905506e ]

The HyperX OMEN Gaming Laptop 16-ap1xxx (HP board 8F06) has an
internal digital microphone array attached to the AMD ACP PDM
controller, but the acp6x machine driver does not register the DMIC
sound card because this board is missing from the DMI quirk table,
leaving the internal microphone unusable.

Add a DMI quirk entry for the HP board "8F06" so the acp6x DMIC
capture card gets registered.

Signed-off-by: Lin Xianglin <1021538027@qq.com>
Link: https://patch.msgid.link/tencent_428392223C2AD3BF23E7ABAA7521FE5C0C07@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8ffaceae8fa07..045c1b8fa2c92 100644
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
+			DMI_MATCH(DMI_BOARD_NAME, "8F06"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



