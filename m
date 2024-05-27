Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB031078F;
	Mon, 27 May 2024 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836482; cv=none; b=JBqBVwv6hnxT8e9cgjODa1wthPZiLNWmBirScPVFpDQtO8HO39+7HYCyZXAAhfa1OjYw/1MIuOvlR9KexUNyZNSuoACCqbJaJcmrTWQTNVMg7ZEt8XCSqqpnCB2CBUT6235Qi4aQQ+FFu5oG4qw3C+IXGzvYJvpygKPRwmIjD3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836482; c=relaxed/simple;
	bh=CqXh9y4IojNCARK+GtUw6Bs2dpPrSmbC3Y0QqT4TfYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj8TqOMiTPLFTdMnVRIScR2XVxb4NNRIec9WY7OcZr5rvi+Pbx5CMgOg0dIH+5y5QfCh07ube7+SlLukx6tFX3wBgTlPsKZ3O+Q5dtzgYD8Y+CkXWkSyKU0NawmlTVtlXkjRKFB6AcBUvZa7S3MFVPz3OuC4co8z+rX3B3PB3HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc/4QZjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc/4QZjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346AAC2BBFC;
	Mon, 27 May 2024 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836482;
	bh=CqXh9y4IojNCARK+GtUw6Bs2dpPrSmbC3Y0QqT4TfYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc/4QZjGDLOi7p6Q/eGafsCI58tqRoKHhE5ZAQjZtro0VYkyOxOKBPtwGFh3LMdy5
	 zftNvkWMMrXGe2hTzBZppz61KDoyWpEawhYZM1XPHKUo5TWv98MbBsFg7axzNXPoAM
	 mEP1350fpmfS6R9Uv3m6FASmvQsfVJHBKTy33ZHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xilin Wu <wuxilin123@gmail.com>
Subject: [PATCH 6.9 071/427] soc: qcom: pmic_glink: notify clients about the current state
Date: Mon, 27 May 2024 20:51:58 +0200
Message-ID: <20240527185608.455471912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d6cbce2cd354c9a37a558f290a8f1dfd20584f99 ]

In case the client is registered after the pmic-glink recived a response
from the Protection Domain mapper, it is going to miss the notification
about the state. Notify clients about the current state upon
registration.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Tested-by: Xilin Wu <wuxilin123@gmail.com> # on QCS8550 AYN Odin 2
Link: https://lore.kernel.org/r/20240403-pmic-glink-fix-clients-v2-2-aed4e02baacc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index 2b2cdf4796542..e85a12ec2aab1 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -83,9 +83,14 @@ struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
 	client->pdr_notify = pdr;
 	client->priv = priv;
 
+	mutex_lock(&pg->state_lock);
 	mutex_lock(&pg->client_lock);
+
 	list_add(&client->node, &pg->clients);
+	client->pdr_notify(client->priv, pg->client_state);
+
 	mutex_unlock(&pg->client_lock);
+	mutex_unlock(&pg->state_lock);
 
 	devres_add(dev, client);
 
-- 
2.43.0



