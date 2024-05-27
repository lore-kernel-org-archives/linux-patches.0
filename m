Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72F168C4;
	Mon, 27 May 2024 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837781; cv=none; b=jN289qh0m2RLW6GczZff9n0mulNHrFhtgL7vtv4yk0jn5Cd8f8jG718Ewq3rTcqGjB/H5PsZwexn+Sc0nyc0mDQmvcVeDeyBFW+w1RNS4U8xxKWNQd6Cff6V6B60RCMGvPMN7FoxMU2nwRWf9NZ1eWeqq5BsRAQvJyG40uFerVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837781; c=relaxed/simple;
	bh=rtZVAXClLNyONWJqzXXfb/R8ivmVbZdmel8w0MKbwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBJVsyFXlF3KBq+xNrXQZQnUd5O3KKSS9j6iqK+f6kjOkB7Ovtsb2+dO4gzqRf4lwGzxtOnK2PxBqwqPPMEPJDZqKAYCn6AsgM+mgrPtN8oVkynpQWUzVAejYNNVfAv3kUe6/pZIdHAx6qrovvYFDJmlZADVU0jDqUUThUEiX9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+PwQgv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+PwQgv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E1BC2BBFC;
	Mon, 27 May 2024 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837781;
	bh=rtZVAXClLNyONWJqzXXfb/R8ivmVbZdmel8w0MKbwcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+PwQgv2urBf8gHmkU2DEYUWFu83K/7yyXoE8O7IheUC8pnlLsBBcV0srFHTUOfEP
	 pkkiYK7W96wRo6McUl/rnIhczo6f8OQkXlQdFqtW15aaytN1jr4B4PlEQ0o6lGTi1z
	 GAZTB6e8wZNUbz7CRX6NqrD1pnr96VX5VMGfhgJ8=
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
Subject: [PATCH 6.8 143/493] soc: qcom: pmic_glink: notify clients about the current state
Date: Mon, 27 May 2024 20:52:25 +0200
Message-ID: <20240527185635.122613547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



