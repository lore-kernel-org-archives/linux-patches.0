Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EA746C4DA;
	Tue, 21 Jul 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657961; cv=none; b=bTNEH8RSM87UPzveyskkpVDu/s2h67px7aZLhPqXQuKFVk/zb7SVkKCoWAyHM+ouX64Y6K8DGy9WW5N4TGUfK82KENfbnnVY4XJIBYGJZ1+YdFOXYwzkeipzSpaiP8Y5PxAVxejb1LeHPUZ+in9Eg//3TKCoFXOgttypthMuyxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657961; c=relaxed/simple;
	bh=uhi27AvYDthsbb8B4hcbMNeSyerwcpRRVFV0RfWP1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUOPwwi9xGnizJ1STIbvS2IZKllNoHfeZRsJenbhCYatr2U22S+s8Na12lx6xQdo0NheRMwsCdIjnmvfM802YUmU6pacnxN45S7omJBFxT0scwx/LX4YC3RHOXpgWN7HgWy63+BuatowOWrWBO4QBHxkpzJzIpA/p+DzcS98PwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlpFZ49/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlpFZ49/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D6B1F000E9;
	Tue, 21 Jul 2026 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657960;
	bh=ec7n9cA/84HAwnzGLVlAz5/S7SLfR6OY1RpqAs5TzXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlpFZ49/k84IYTApTaPh04b42GawlsYk6AMlD5GuS8DO+smyr1OnSEcHORnrg3a0Q
	 M1zukPwOj3m7BcWliMFidtOZbGaaD5J06g07DI7mn/aJT9jP04hhIjny5ibfKVjlFY
	 mRguNaHQrI6DyvmatYo3GZUHFOEMXWmkuS+/zpyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0962/1611] ASoC: codecs: lpass-va-macro: add SM6115 compatible
Date: Tue, 21 Jul 2026 17:17:58 +0200
Message-ID: <20260721152537.033047916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 893e2fd509e968cc1d76caadee0f5d2f2c72f137 ]

SM6115 does not have "macro" clock, so its bindings differ with existing
SoC support in va-macro. So add dedicated compatible in both driver and
dt-bindings to be able to address that difference.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20251031120703.590201-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0773610eef71 ("ASoC: codecs: lpass-va-macro: Fix LPASS Codec Version for SC7280")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 92c177b82a0218..4e537e2f4ff18c 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1723,6 +1723,7 @@ static const struct dev_pm_ops va_macro_pm_ops = {
 
 static const struct of_device_id va_macro_dt_match[] = {
 	{ .compatible = "qcom,sc7280-lpass-va-macro", .data = &sm8250_va_data },
+	{ .compatible = "qcom,sm6115-lpass-va-macro", .data = &sm8450_va_data },
 	{ .compatible = "qcom,sm8250-lpass-va-macro", .data = &sm8250_va_data },
 	{ .compatible = "qcom,sm8450-lpass-va-macro", .data = &sm8450_va_data },
 	{ .compatible = "qcom,sm8550-lpass-va-macro", .data = &sm8550_va_data },
-- 
2.53.0



