Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928472D7DF1;
	Tue, 21 Jul 2026 20:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664676; cv=none; b=L2uhGWLKglqW/9bZ4ieKWfMfac/vkgYv7kU9BBb6E3HgBYx8QdBNfnw4xLKiRYUXkKeUcAiBxz6ZJzBpAtD5iOxEmFUyPxQnsvRMYN3mKQJj92fSP0T1nNf2ct0i/08yZ3O7Zbi9btsiZncH9ZGLq/meTQWQrvgxUQ4grwnW8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664676; c=relaxed/simple;
	bh=/OQwhy35ZCg2lM0sWVWQwkZBSE1ws2jpfFU1S1QEO1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r889m6fuo9hYK2fDbOOwdjhGxwna7jYzakz/SZ67Ef/MIYJlAMO5f2OF+3wLo6sjphul8N/bW1591/23S/gaL9lB5+7JevswglqpnMfoC393aJwJaTah3NH98CpEjtyqFlxYeT1weU95IXWgb4ZXdhd9O3XRHaZLazvbrs47f20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPFkm+Q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPFkm+Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D20A1F000E9;
	Tue, 21 Jul 2026 20:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664675;
	bh=qMbHUStibE+Bz9NEY9VdRxovImqCxC3X+uOopaoYe7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPFkm+Q4yu3rjCyst2gBrksmu8dFUddKqTG0V+LtCW/DbNotMwUp3kCcQKVr8qfVG
	 /HOAn47/WxaBSzXMGwVKN0YsyqsWiH9n8VYHDJG9YA9uZOjBClfpP+HgS37wkEg8a8
	 RXfN74JVA/2ocU+uo50wZ7O61wVxnSzRxzrHMDZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0017/1266] slimbus: qcom-ngd-ctrl: Fix probe error path ordering
Date: Tue, 21 Jul 2026 17:07:34 +0200
Message-ID: <20260721152442.173939313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 2c22ff152d380ec3d3af099fa05d0ac5ca9b4c1e ]

qcom_slim_ngd_ctrl_probe() first registers the SSR callback then
allocates the PDR context, as such the error path needs to come in
opposite order to allow us to unroll each step.

Fixes: 16f14551d0df ("slimbus: qcom-ngd: cleanup in probe error path")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index de1834d52cb831..6a3c1cf06b81a3 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1663,22 +1663,21 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(ctrl->pdr)) {
 		ret = dev_err_probe(dev, PTR_ERR(ctrl->pdr),
 				    "Failed to init PDR handle\n");
-		goto err_pdr_alloc;
+		goto err_unregister_ssr;
 	}
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 		ret = dev_err_probe(dev, PTR_ERR(pds), "pdr add lookup failed\n");
-		goto err_pdr_lookup;
+		goto err_pdr_release;
 	}
 
 	return of_qcom_slim_ngd_register(dev, ctrl);
 
-err_pdr_alloc:
-	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
-
-err_pdr_lookup:
+err_pdr_release:
 	pdr_handle_release(ctrl->pdr);
+err_unregister_ssr:
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 
 	return ret;
 }
-- 
2.53.0



