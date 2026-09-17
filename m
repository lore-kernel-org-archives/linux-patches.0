Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB85502D72;
	Thu, 17 Sep 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665017; cv=none; b=jH7V8Blx5FtNvdanTrl0YZbu3KL1fI6Y4ERaMfODFoC9AGpcmSCwV/dw8mzsweWzk18RLBK78zjFxcAbbGeZeRiaY+d0W9lJxaNN/ddABHgEREwgL3QnKCCt/pboVx/bKZLyAiNDf3IMKBS0L5neyCeezvXGRZn/egHFGSNx2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665017; c=relaxed/simple;
	bh=OZfcUSpvAKMr0M+ynNEQmTY8RZPV2vFxc1bm/JrKlLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaBQwk8DiTNHMWViSueEcF/P58iHcotMwwQUsqxK9CTzb9UCgfJf8jYIQAMvTYIjqbV6B0gUb4Y3kOeUAWVNrCARx966kJN8CWoqi1guIUafoG9qyG21NqK4zA0TUA9vuCYIyM+gYVVOLtj5voDY2ayB1nX85aRXa5NwUQKr2rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WraM/ori; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WraM/ori"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F541F000FF;
	Thu, 17 Sep 2026 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665014;
	bh=quWxMe4jUMDcOZPhpXUFvr3oKqHLk9VAzaqrWaHAH6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WraM/ori8CSyYF3X97O7t0GCl1v+jCwAs7IyRkf3EH1mEPrNbqji/h4sXPA6gTNY8
	 w3Y4+NCBQbaY2sAdI7DziEpQh92J3oIUbMuJ1jgEBF+zA0fglIOFaqyINoDhWCXt0x
	 egT/ZsyYVlMtEoX4dfMWcEivscstlQuE9MTl9CvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Xianglin <1021538027@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0565/1250] ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx
Date: Thu, 17 Sep 2026 16:06:00 +0100
Message-ID: <20260917151607.236523302@linuxfoundation.org>
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
index 85ef6dcbaa17d..8abebf17bac5e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



