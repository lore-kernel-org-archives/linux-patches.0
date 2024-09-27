Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125711779BD;
	Fri, 27 Sep 2024 12:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439881; cv=none; b=tijT4078CdPFVSjP5UqZsrsqIlWUaGzPID5Ob2lz6fswjq2bVCX3XyGYyud8tEmUCgD41wPyk62P9HzCeFUQob5oDrAYAgm0XntHw9e/6FnmVoGddQuJnhA4AL5Dn7lisJQmobmryQ4cOK+E9fShoRP/weRBL2qdynsaWH6NoPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439881; c=relaxed/simple;
	bh=wGq+QIJdhMZyqr+dAVBxtKlvSoQ91cw0T+Npf42IONQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UB0o2LfixSn+2M/YL+wdk/lLveADz3YUl6N4dwifRIdK+z1NOk1FsCQjIcbcuEHQPoYoBu4eQW2SgZlVwWLwC9K+NuFMZVNkZr0A3YIWdnJl5ciIbL6ScEM+lpTpeWn3W/Dl8NpmCkyKYGhctFysutgh+EcxH92yUGfyRUPCdFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laI6/Jeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laI6/Jeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F46C4CEC4;
	Fri, 27 Sep 2024 12:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439880;
	bh=wGq+QIJdhMZyqr+dAVBxtKlvSoQ91cw0T+Npf42IONQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laI6/Jeh1fM7KjlOUwLx3fj2lYCNltgjVSxYvL9oMey7k7VtYOi9jy8qNwVTLEkX9
	 Gh+J78AjMFOBSyIcMJR5fudNF7KdIdobfl8OC1KH31kLW2rBQsQMCoz3gAg1VZThuA
	 xj9HLBI3y+GXnODCR+zMPKSvpmx7unLA2SsKOC2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Albert=20Jakie=C5=82a?= <jakiela@google.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/54] ASoC: SOF: mediatek: Add missing board compatible
Date: Fri, 27 Sep 2024 14:22:53 +0200
Message-ID: <20240927121719.772546337@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b5b4ea854da4b..94db51d88dda0 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -625,6 +625,9 @@ static struct snd_sof_of_mach sof_mt8195_machs[] = {
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



