Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6BF4C97;
	Tue, 11 Nov 2025 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822585; cv=none; b=N6AgBKpAct86Wkoe8d3fxo4giO9Vt9ZOjg+HYZBbk9V2ZGT8kN0wulSnU/YQSBDYTHQe9mg7QfOXw6E8EESQE640onv0S0+Nky0AQ0qEpLO8Xnfkg0vzIGYYCFWdcOqBBD4vCaXdbITaxMVKBROUdaR9uzOyWRa2pHDmuaTmi60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822585; c=relaxed/simple;
	bh=0votJrKzJq9Mk1kpz6wALd7kIN+jY03kvpy1MeAy1pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKSnd1vOr/CPtprKVVUP7AqRtIN1T8VdGC5O36p+FHue3h7+k9P6aeIshxbWbKYwEmb/oVfScNB+W6ZbzArR/gFO0JnOCHy8/ZSE7lBS6YincvNOZE22a3GqTnOPoVwmYXQ380jXaQfnPedQuiIot1DolkeAIWxrYfQ0gFOJ64M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfFkIy6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfFkIy6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EB7C113D0;
	Tue, 11 Nov 2025 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822585;
	bh=0votJrKzJq9Mk1kpz6wALd7kIN+jY03kvpy1MeAy1pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfFkIy6wQdb/Cs8K0NvNGokWyrJpzXfkSrGPbKaOxbUoqvHalH2MKVAjfvGihfJ5r
	 NLAcgwxwjGArnHKJlXkXM14lvhDK50sNsZTLas9zFFeRKbMu0PAEKRij0JiB0nAT57
	 Z/sWOZRdD2YBNDRzS82rxks2gmEf9IzDlcqD7v2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Laurentiu Tudor <laurentiu.tudor1@dell.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 142/849] firmware: qcom: scm: Allow QSEECOM on Dell Inspiron 7441 / Latitude 7455
Date: Tue, 11 Nov 2025 09:35:12 +0900
Message-ID: <20251111004539.830124662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 30ee285f1e3cdc88ec7010abeaba0cbed800bdcd ]

Allow these machines to access efivars through qseecom/uefisecapp.

Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Laurentiu Tudor <laurentiu.tudor1@dell.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250716003139.18543-5-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 5243d5abbbe99..7f43f12e4e1b2 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1994,6 +1994,8 @@ static const struct of_device_id qcom_scm_qseecom_allowlist[] __maybe_unused = {
 	{ .compatible = "asus,vivobook-s15" },
 	{ .compatible = "asus,zenbook-a14-ux3407qa" },
 	{ .compatible = "asus,zenbook-a14-ux3407ra" },
+	{ .compatible = "dell,inspiron-14-plus-7441" },
+	{ .compatible = "dell,latitude-7455" },
 	{ .compatible = "dell,xps13-9345" },
 	{ .compatible = "hp,elitebook-ultra-g1q" },
 	{ .compatible = "hp,omnibook-x14" },
-- 
2.51.0



