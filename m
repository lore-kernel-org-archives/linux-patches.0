Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA7436EAB8;
	Wed, 20 May 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295407; cv=none; b=UXSlq29UsbW9Ie2NIknogqfjpDHT/KyBC4J5BpSZ3kVzI3hB9npVH0+7w3B7p4zzGucRoBZQ/m1FTAnVfG2A8vWkheklya1gj/kKBp3RRLDmALT3u3Lk1ERzB1lR3vU9DMEJ+UQ634Otw3vPxYRVOjmheSiZhyt9ygY3C4yup0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295407; c=relaxed/simple;
	bh=KquaecswzJ6ATd1bXKKZm/Hp4ASTaPyjR5H82kKdUPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENTgBp4WykIrPoYw15eYqfJwjXE0tCZdFh1At5TIZBoOkugcTKQrqzw+8thXCws6eEFVI3nanHNzncNZeatu5h4F7RLume4VI6Y0q/Hq53TgMRakbAzLmgF9oh59ySkSEhhfLroC/yMKhmdc0v98AcxkQjyCGGArzLHb5Xivzfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqT1GsMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqT1GsMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796F91F000E9;
	Wed, 20 May 2026 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295406;
	bh=1grX5NXIPAwcA3WYVHDLkvkhx/BWbl/2cD/ZTGhANC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqT1GsMxVXx3LJq2snpDFDifjHQhWHkRJNqhKzxEGDPuls7BQzehb0TcTr1VwkIRq
	 NUVDF7R5AIbnimsTrcS33kCRdJOJ/sAxGdRt9fGBM0cH+/EEXGiNfEcF3pMxexHH0D
	 +ppjO6HnWvBA6ckMOmgKZIvgBZcqnmVW8ueHqr9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0407/1146] ASoC: qcom: audioreach: explicitly enable speaker protection modules
Date: Wed, 20 May 2026 18:10:57 +0200
Message-ID: <20260520162157.409439341@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit b481eabe5a193ba8499f446c2ab7e0ac042f8776 ]

Speaker protection and VI feedback modules are disabled by default.
Explicitly enable them when configuring speaker protection.

Fixes: 3e43a8c033c3 ("ASoC: qcom: audioreach: Add support for VI Sense module")
Fixes: 0db76f5b2235 ("ASoC: qcom: audioreach: Add support for Speaker Protection module")
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260326113531.3144998-1-ravi.hothi@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/audioreach.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/audioreach.c b/sound/soc/qcom/qdsp6/audioreach.c
index 241c3b4479c6f..ff8cd55b0d898 100644
--- a/sound/soc/qcom/qdsp6/audioreach.c
+++ b/sound/soc/qcom/qdsp6/audioreach.c
@@ -1365,9 +1365,14 @@ int audioreach_set_media_format(struct q6apm_graph *graph,
 	case MODULE_ID_SPEAKER_PROTECTION:
 		rc = audioreach_speaker_protection(graph, module,
 						   PARAM_ID_SP_OP_MODE_NORMAL);
+		if (!rc)
+			rc = audioreach_module_enable(graph, module, true);
+
 		break;
 	case MODULE_ID_SPEAKER_PROTECTION_VI:
 		rc = audioreach_speaker_protection_vi(graph, module, cfg);
+		if (!rc)
+			rc = audioreach_module_enable(graph, module, true);
 		break;
 
 	default:
-- 
2.53.0



