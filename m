Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5EC4508E0;
	Tue, 16 Jun 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624413; cv=none; b=rK7/x+J9uSs4TGHV1wFfyFLN4GAtvsXnI6Y2oU7C9fsrgx7fIm3yylTmUGfmP+xZqLtamTXpHQzzBcBCvsZAUHgRmERXW/yRvx6Kw01iaU9kmZpQBOICj9VHCQZxMf9NVMoSZnno8nfSHy8tnE4q5bQBR/JksR6FfGExxAxEM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624413; c=relaxed/simple;
	bh=5XQYkSq9tG+bV8L8SkEtDbrnB0NNj/dwtqZghp2/A+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQs9j3s00LEOwthFYkqUybUXM79mtdqqChxAPAqzPvuxj+VAteaIWhOOdOqN2OKpDZXCuTjxJDQw6BWst3QJtM+pFvOQlFsKnAoplHHv9Bx7Uu2E3SBKvM0fjAyy719b+3jtyYFAtzZ3SysjVSFzgSzku6uZNeLsYemnnLapxfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEZo3IQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEZo3IQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B0B1F000E9;
	Tue, 16 Jun 2026 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624412;
	bh=Ql8J89dND9mycU7mJD5b7bV0m+FZl4Y0wWPCpAboNjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEZo3IQBM0RZwbTvgspUMQnx4Zl32Nq/qjWcXaK/xsfljKU1QwiVqr7sYEAXHV4QH
	 gDKX9+N/tWOn9f0hXvDDF71UIiUWsJAwx/iqmESJwG63CYCma0q8KryrlCB0tj8f3b
	 x/KGQNPSMmhE7CBll3iajT14l56ktlLszGX/rrNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.0 330/378] slimbus: qcom-ngd-ctrl: Correct PDR and SSR cleanup ownership
Date: Tue, 16 Jun 2026 20:29:21 +0530
Message-ID: <20260616145127.591321856@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 960b53a3f76fa214c2fc493734ae7b3c5e713bbf upstream.

PDR and SSR callbacks are registred from the controller probe function,
but currently released from the child device's remove function.

The remove() function should only be unwinding what was done in the
same device's probe() function.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1684,6 +1684,9 @@ static void qcom_slim_ngd_ctrl_remove(st
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pdr_handle_release(ctrl->pdr);
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
+
 	qcom_slim_ngd_unregister(ctrl);
 
 	destroy_workqueue(ctrl->mwq);
@@ -1694,8 +1697,6 @@ static void qcom_slim_ngd_remove(struct
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
-	pdr_handle_release(ctrl->pdr);
-	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);
 	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);


