Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638DA13B5B6;
	Tue,  3 Dec 2024 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237640; cv=none; b=jQJwcLOeIihybQY9bjH7064OkgmfwitbnD1IChEF9ES+FJ58Zcw40zwjErGf7/y9gQqw9FHKEmlrbMTNNvnECcSPrOPP2plszGzHL8HYHgkHuVnJOJppiwg8lqIr5qTOt3WjVI/ofuvnilWn3QEkvoDkMEufX+nU01yTFmXgRog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237640; c=relaxed/simple;
	bh=MDDjdUcHHs4UZF1C9Oacn53iJ5+0ku0SvanTwNKnIWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfEv8pcv1TRVmnx+XK14uZlJB5V1Sfxq7K3xUoxqtz4PaGVdK90fk60zMB4Iy0k9+HGCHJC5bpWAlgf7yyf93i9dhgB45uBoeOC81C5J1S7JTht8swJHjZ6yU/9RfQPb1sLsC4a1Op+1s5aVss1n8XXxLsAzXc3l1REaIzA4pkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shLTml2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shLTml2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A822C4CECF;
	Tue,  3 Dec 2024 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237640;
	bh=MDDjdUcHHs4UZF1C9Oacn53iJ5+0ku0SvanTwNKnIWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shLTml2JQ5LcH37aRAvB4GOO5C8Jq1up0xu+BOwg9vCFqvD3YOluZUB1Du06eezi+
	 o4XatjPugIB4L3N5yd13RN9gDmMnI+TT5XUDOOHzbHDOhf3QEewP1vow0QUGb4OjBq
	 zFDvYAg2trI/Oclu6NwcDwVdOaxI837LAHLG9SO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/817] ASoC: tas2781: Add new driver version for tas2563 & tas2781 qfn chip
Date: Tue,  3 Dec 2024 15:33:20 +0100
Message-ID: <20241203143956.748634770@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit fe09de2db2365eed8b44b572cff7d421eaf1754a ]

Add new driver version to support tas2563 & tas2781 qfn chip

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20241104100055.48-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index f3a7605f07104..6474cc551d551 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -1992,6 +1992,7 @@ static int tasdevice_dspfw_ready(const struct firmware *fmw,
 		break;
 	case 0x202:
 	case 0x400:
+	case 0x401:
 		tas_priv->fw_parse_variable_header =
 			fw_parse_variable_header_git;
 		tas_priv->fw_parse_program_data =
-- 
2.43.0



