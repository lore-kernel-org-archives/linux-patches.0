Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A819753F;
	Thu,  6 Jun 2024 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683170; cv=none; b=W9DQLemNLRDYydmiecIHJjcD4ziEJRSEMoaVwAMIg8nMkMgFjaJAJT5aXfA+6JiZW2uNJvtNsKlA3mIT1vM+fQ2QcZU16tCPogla8K7ZXpyWdW+Y7Ul8PaPk1FxXIgOHQaObHJywr9BbZ1PbaARRHaVtK9KhjiikbAG1M4a7ezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683170; c=relaxed/simple;
	bh=24tsOvnpnkjplcRYE+cFk5K0OL6cVl9XKApnT9OcDnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxoOb2OnIugOEWC0BRNrGrn265TZZTqunPlU4t7Z7xdKBPtwG4ztCvQE5Pfau/GiMnBnTqHSaqDng2ETwBcG9CuSvBYpLrrMDCK6BM/0xItns0WrO91SXQLhcHdG25si0fgICJPD/TNTAQckmrqSUPjBCsvt0BiOF6d0H9FwEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpBD4ycZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpBD4ycZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B29C4AF09;
	Thu,  6 Jun 2024 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683169;
	bh=24tsOvnpnkjplcRYE+cFk5K0OL6cVl9XKApnT9OcDnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpBD4ycZ6SGnqt1k6yIY0lmgFVd6FSPFQLRtj+1iFypK5KjWTFbPp4sudlYmQQ8JH
	 AP4xIRXXM8uVwsIIORV1umqr6IaHHCBiBAunbStWsq5MYFhMYObfDO4qbDBvBwhuP5
	 pw+gVHH51r1iZ0TWNnV5dbgwiHMefo5FAbAsYm0k=
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
Subject: [PATCH 6.6 114/744] soc: qcom: pmic_glink: notify clients about the current state
Date: Thu,  6 Jun 2024 15:56:26 +0200
Message-ID: <20240606131736.057521045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c6dca5278e61b..062ff7b12de6a 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -86,9 +86,14 @@ struct pmic_glink_client *devm_pmic_glink_register_client(struct device *dev,
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



