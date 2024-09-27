Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93518CBE1;
	Fri, 27 Sep 2024 12:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440234; cv=none; b=XRIp5Y+sqVIuYUf+7/MukVlGMx6ulI+/FkFTxU3aKG3Zb4A+/OOrmY88cIIMh5NbNT5TCgyGKRFRSRAeDJzAa8TyyiWIprmPlZCkNuDNErXAMZ2CCV40OBukIfKqagmpHQeAV8M9HXfFvwAmkxqsr4yoAZrAN5HOhobkGNrdzLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440234; c=relaxed/simple;
	bh=ZUm88uh3yYA3MJliO7LBKWWPDDydE5mXA5C5CM5EhY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2esm3X9uiJ6TeZhwkvXQCyclb1xQPA3fKkTdIhItH5pf2jXG0Z49TgH/NJCexjGTc57tJnVNewB2cYrByLwAjdIjJBIEAp0xXAzSn7Ha1J69v6/aycWBFiXkpKa7mwrni034GDojstZPF8yM5nhvEQaLB36OqAkN7HjQ/H0nsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVewIBZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVewIBZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE206C4CECD;
	Fri, 27 Sep 2024 12:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440234;
	bh=ZUm88uh3yYA3MJliO7LBKWWPDDydE5mXA5C5CM5EhY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVewIBZAEPkpU5RSNdQ+A0fjbeySyWsZxNBXyqt7/FOm0lAh0RA7CzPyxMSDGTT2L
	 0rceVkxmk33bnf2Oh9bofeCGo80cui89WitTRr8yR8EOZgkAlfsbNcu7k5B8R+5QoQ
	 JRZzzkrKAvAkOI4T1TEGSa+AfBucSczyNgjLCQlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Albert=20Jakie=C5=82a?= <jakiela@google.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/73] ASoC: SOF: mediatek: Add missing board compatible
Date: Fri, 27 Sep 2024 14:23:12 +0200
Message-ID: <20240927121719.951045950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albert Jakieła <jakiela@google.com>

[ Upstream commit c0196faaa927321a63e680427e075734ee656e42 ]

Add Google Dojo compatible.

Signed-off-by: Albert Jakieła <jakiela@google.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20240809135627.544429-1-jakiela@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mt8195/mt8195.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/mediatek/mt8195/mt8195.c b/sound/soc/sof/mediatek/mt8195/mt8195.c
index 53cadbe8a05cc..ac96ea07e591b 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -663,6 +663,9 @@ static struct snd_sof_of_mach sof_mt8195_machs[] = {
 	{
 		.compatible = "google,tomato",
 		.sof_tplg_filename = "sof-mt8195-mt6359-rt1019-rt5682.tplg"
+	}, {
+		.compatible = "google,dojo",
+		.sof_tplg_filename = "sof-mt8195-mt6359-max98390-rt5682.tplg"
 	}, {
 		.compatible = "mediatek,mt8195",
 		.sof_tplg_filename = "sof-mt8195.tplg"
-- 
2.43.0



