Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC127C158;
	Tue,  8 Apr 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116527; cv=none; b=K3dx9IZQzKL4ktdMuwnCJDRiV+wQg7lU3zjdORBGZVgX0wugom6bkWfMUuYaLvcSokqHUzh9XeLtwHbvuTY5ytWc/xnk92UF6pRoWpvvfjKeCem34CezxH8u2gNdGax7+82QhO+N8PsdN1yQ84upOvPX5o3ArtrE44saVoKys08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116527; c=relaxed/simple;
	bh=n7o+zVknzt3bjgJRu4SFXVM1iJ7cB2Qo1UhAE+bu9nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CO129e3AjFF1HLU5nU5NYdBmIzS6wLfFWQjvK4T74QOarWEAfdnlgu3LHIxpeAXquL8MUJ+1h3fWOfSazVlHaEf3qR/4pIMq1emccuT9tXgSxPQMf7D/IKV7eJCOXWEJeEk6LeikMpxKFkXQBDmncoMJ7dIigECmO77Z7kiXY0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoDuZ3W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoDuZ3W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D2DC4CEEB;
	Tue,  8 Apr 2025 12:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116527;
	bh=n7o+zVknzt3bjgJRu4SFXVM1iJ7cB2Qo1UhAE+bu9nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoDuZ3W4LjYwvny7jLsCQo2AOqY6qKDgFDEevHUKmLUAT7IU/WQsNZrbsSQgcCdea
	 ACeNnHqlrab2kMOqFKL3h2rEO9j2E4j1i/6yigxzLxtwerWRB+62gCPgn2Qspe0voh
	 d3nf26L914hibqu3vH3wMhMn31RKOO8ASPBYPi04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Luca Weiss <luca@lucaweiss.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/423] remoteproc: qcom_q6v5_mss: Handle platforms with one power domain
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104848.873527334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luca Weiss <luca@lucaweiss.eu>

[ Upstream commit 4641840341f37dc8231e0840ec1514b4061b4322 ]

For example MSM8974 has mx voltage rail exposed as regulator and only cx
voltage rail is exposed as power domain. This power domain (cx) is
attached internally in power domain and cannot be attached in this driver.

Fixes: 8750cf392394 ("remoteproc: qcom_q6v5_mss: Allow replacing regulators with power domains")
Co-developed-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Luca Weiss <luca@lucaweiss.eu>
Link: https://lore.kernel.org/r/20250217-msm8226-modem-v5-4-2bc74b80e0ae@lucaweiss.eu
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 32c3531b20c70..e19081d530226 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1839,6 +1839,13 @@ static int q6v5_pds_attach(struct device *dev, struct device **devs,
 	while (pd_names[num_pds])
 		num_pds++;
 
+	/* Handle single power domain */
+	if (num_pds == 1 && dev->pm_domain) {
+		devs[0] = dev;
+		pm_runtime_enable(dev);
+		return 1;
+	}
+
 	for (i = 0; i < num_pds; i++) {
 		devs[i] = dev_pm_domain_attach_by_name(dev, pd_names[i]);
 		if (IS_ERR_OR_NULL(devs[i])) {
@@ -1859,8 +1866,15 @@ static int q6v5_pds_attach(struct device *dev, struct device **devs,
 static void q6v5_pds_detach(struct q6v5 *qproc, struct device **pds,
 			    size_t pd_count)
 {
+	struct device *dev = qproc->dev;
 	int i;
 
+	/* Handle single power domain */
+	if (pd_count == 1 && dev->pm_domain) {
+		pm_runtime_disable(dev);
+		return;
+	}
+
 	for (i = 0; i < pd_count; i++)
 		dev_pm_domain_detach(pds[i], false);
 }
@@ -2469,13 +2483,13 @@ static const struct rproc_hexagon_res msm8974_mss = {
 			.supply = "pll",
 			.uA = 100000,
 		},
-		{}
-	},
-	.fallback_proxy_supply = (struct qcom_mss_reg_res[]) {
 		{
 			.supply = "mx",
 			.uV = 1050000,
 		},
+		{}
+	},
+	.fallback_proxy_supply = (struct qcom_mss_reg_res[]) {
 		{
 			.supply = "cx",
 			.uA = 100000,
@@ -2501,7 +2515,6 @@ static const struct rproc_hexagon_res msm8974_mss = {
 		NULL
 	},
 	.proxy_pd_names = (char*[]){
-		"mx",
 		"cx",
 		NULL
 	},
-- 
2.39.5



