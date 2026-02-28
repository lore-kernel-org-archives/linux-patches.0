Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D733A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302240; cv=none; b=hRUryJLUimxShMzUx2ZQsRYDPx9sM14JMfGjjCCSRNDNlAnYuugLgWYjnkTXbEqOWUk6CEICuP/gg0Zj/Dx4EAxHIwtCH/DQ4CpLEAT21ZQtURr1DoTJFDYd7b8qv2SYvF54h+RzwrWGBNHoGYoBKMw0rUlHGtIfQy3sGPlt9lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302240; c=relaxed/simple;
	bh=SnCo9s7GphGJtEX+BIwUKZYott4qnZNm4M35yIZca3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s37OJN0QEXBjeUE6VFm/6QU5KsLMZz7lnqhXUo+BmznYIjOtSqm5EOIRhg6v6oKH31esveLu4nxdDs1Ej3LeUs7m/7wnlAQTubv76idwiIPNjb7CcCtXzyonpj5+Nsad5GyQGRxlEBGbu6IqnAUaYd3ZEa2LtuyCF5yPSMMVGS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWP91ZH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWP91ZH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A40AC19425;
	Sat, 28 Feb 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302240;
	bh=SnCo9s7GphGJtEX+BIwUKZYott4qnZNm4M35yIZca3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWP91ZH4mCotH0JeG0o8T5ZldNlNRwYSmybGT8dEeJaHQT6AGjyNVFNHFwj+k5RFi
	 z95mzxJmpvZoj11wOwF+aljxhhmQ6D47/ZX8kLT7P4hZSLA1nACWNyR7FvEAtJUk7p
	 9EwMG4Q0a63M5GqVVwmfnL30DHu4IHWoUJfKZesIIpCt5NNATUbFmEQVoxZa1/W4/G
	 WJk41H7PWhHb9HCU956qBBeosQKPUNXgTyjylpyRnkGYElNmzHzCnvDl6lMxPKfo1T
	 qJonlz0992RcOWYVpNU9YpyHVMZCzNN4lX31UujsAq328fn//rFCn+K/e7tjXdbhlo
	 NaaXCVrB89lPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/283] backlight: qcom-wled: Change PM8950 WLED configurations
Date: Sat, 28 Feb 2026 13:06:33 -0500
Message-ID: <20260228180709.1583486-251-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 83333aa97441ba7ce32b91e8a007c72d316a1c67 ]

PMI8950 WLED needs same configurations as PMI8994 WLED.

Fixes: 10258bf4534b ("backlight: qcom-wled: Add PMI8950 compatible")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260116-pmi8950-wled-v3-4-e6c93de84079@mainlining.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 79337e84069fb..0d55818f554ec 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1455,7 +1455,8 @@ static int wled_configure(struct wled *wled)
 		break;
 
 	case 4:
-		if (of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
+		if (of_device_is_compatible(dev->of_node, "qcom,pmi8950-wled") ||
+		    of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
 			u32_opts = pmi8994_wled_opts;
 			size = ARRAY_SIZE(pmi8994_wled_opts);
 		} else {
-- 
2.51.0

