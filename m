Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039890;
	b=ro6hj4/HdPGKyLeLrJqhvozFQLBLMrIb0ug95ynIOaN0cQKr27wCeYMTXm1amhm7Havm
	 8kkkX/CNBq8dvIh/RxprMCR5y4vtsVc/Jkf5BNKtQdAIyc19QA5Ze+4KF/8iULtDcVwSi
	 Au3DAa/albJu4ETXDqAr9/5ERN27/K0rClIm82i0w2smYX+wqYZXJE/+yI3hGOmKpFjpk
	 EpSZZMNHOV1xghvjkkmINtHdnGsTQ4Co+kjukfA8ZJ5UaJho19cbo49CdvqQidM4AA80p
	 dR1v9OJyZLoMqsHh5pVpV5LQEiytY4LIpwQWmY5A9YO9YQpCy9ugNTmeC318sQ+YDJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Q3LyzOfOS01LbNpt+2CvRNaxfJmqoWXMw3xb0x0uxE=;
	b=JUT0qNx1ag8esxhpllmqOiRNyoCJdrKKuSTIGRFsTcV8i94dYcGyjHd+JR9LezMQybw7
	 WlfW8PeW1kCK1VUwUna9ejIkbDhGMqCCm/JRK0No9Uinii2pVun5KZnJl0dS8CIoPqze9
	 gsRtqerGUj1bb0cR23HDLUO5etxgXfno6eEnI1NPtaQ6Df++caGBsEqBg0QycNY3R3inM
	 miUn+fzcKBDtRqVwr7s1bO3QQCvXrd8vlDlu+ZenMjZeqjLx2NjIa6+sgGtADDUyLWoeB
	 AZU2pz8ti5iGhTZIZnBjdIUbRsduICoWeppjRqs/bzjAxfUC4Hk3RxJ2JSivmK3Ig5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WG4WwF6s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA0606A32C;
	Wed, 18 Nov 2026 22:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WG4WwF6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9321F000C6;
	Wed, 18 Nov 2026 22:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039890;
	bh=9Q3LyzOfOS01LbNpt+2CvRNaxfJmqoWXMw3xb0x0uxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WG4WwF6sb6XUsna0iItxrphxWb6DIHTVrZvWw5gQbW3/KMrnA5soxCpezJaeTJysk
	 yUHFHhA7AuTy6y/BVJCIRL3yFaEyBLJVPVKHwiqxybzzD3zFDJS/KkrhYkwkGdyE/N
	 2k35Pw/WKiQpErFFLOobMZFYveOUwFip+Ttx7CsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2261/3318] interconnect: qcom: icc-rpm: Handle icc_link_create() failures
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118150429.647246059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b2079a6b8e8b92c6c45a22930e5b68a9c5c34645 ]

icc_link_create() can return errors. Don't ignore them.

Assisted-by: LLM
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-3-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index e76356f91125f..1f9d31441ed6b 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -529,8 +529,15 @@ int qnoc_probe(struct platform_device *pdev)
 		node->data = qnodes[i];
 		icc_node_add(node, provider);
 
-		for (j = 0; j < qnodes[i]->num_links; j++)
-			icc_link_create(node, qnodes[i]->links[j]);
+		for (j = 0; j < qnodes[i]->num_links; j++) {
+			ret = icc_link_create(node, qnodes[i]->links[j]);
+			if (ret) {
+				icc_nodes_remove(provider);
+				clk_bulk_disable_unprepare(qp->num_intf_clks,
+							   qp->intf_clks);
+				goto err_disable_unprepare_clk;
+			}
+		}
 
 		/* Set QoS registers (we only need to do it once, generally) */
 		if (qnodes[i]->qos.ap_owned &&
-- 
2.53.0



