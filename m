Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55812054F8;
	Thu, 12 Dec 2024 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017092; cv=none; b=Fjvu1O2p+harzVi2hdVPCcNYmyEs3XKHWf56xqOkjtZ18isZ+Msf5DtVZMqbnoctBCzPmQ397Me7Law0MhFJmIPyMV4wbFF8iQL668IdLv2oPOGHTlJSAl+eBv9wkE8B4O9422dNH5MVjEVYjlcs0OXdBQhVEtr/Qpz0QQLwqZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017092; c=relaxed/simple;
	bh=xnNA6kTDmmurNlEocplvt6KIgCbfb72Nf5SvVLfofEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zu8LTRbOU6RN4Sp0zReDC47JGWRYKotqkL9h+oT8dKfphvKmW0p0JpzSjVxDEd69Gz6mgYB946ymy5m3cB1TuoI6KSe3+uECnvbXnXFzzifexQ6Rl0ug4b92Ea7ZEBGNMjq+MdvcBsijYtoZSzwRe2MSCreYalaXXWXSzyJ60ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qsezbo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qsezbo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4267BC4CECE;
	Thu, 12 Dec 2024 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017092;
	bh=xnNA6kTDmmurNlEocplvt6KIgCbfb72Nf5SvVLfofEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qsezbo42PzcQOQiKzQphqENbr8oVIZVki9+EZ01ErvpqWgNhDCXVQ6oOtr53HURF
	 1Qn2pcGUfv9ddmRK0HIZAWGM0dDH2IVxzg6TZIcMTVArWKm9D6wQ9jtukH5mHr9R7c
	 vMrWcEXbS1UwN9j9WjElr53griqLTJqath9cc0pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/466] pinctrl: qcom: spmi-mpp: Add PM8937 compatible
Date: Thu, 12 Dec 2024 15:59:09 +0100
Message-ID: <20241212144321.785469035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit f755261190e88f5d19fe0a3b762f0bbaff6bd438 ]

The PM8937 provides 4 MPPs.
Add a compatible to support them.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/20241031-msm8917-v2-4-8a075faa89b1@mainlining.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c b/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
index d16ece90d926c..5fa04e7c1d5c4 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
@@ -983,6 +983,7 @@ static const struct of_device_id pmic_mpp_of_match[] = {
 	{ .compatible = "qcom,pm8226-mpp", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8841-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pm8916-mpp", .data = (void *) 4 },
+	{ .compatible = "qcom,pm8937-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pm8941-mpp", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8950-mpp", .data = (void *) 4 },
 	{ .compatible = "qcom,pmi8950-mpp", .data = (void *) 4 },
-- 
2.43.0



