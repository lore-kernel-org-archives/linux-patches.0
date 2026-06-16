Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6B477E33;
	Tue, 16 Jun 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627798; cv=none; b=k0/MlMmgWYsvkug7ya92fisOOEFLutjGKqtvxgsasOvO9DknlEBnQ5k5KbK9C3ZU6b9hO0yuj8+TffvIqpFsf00sbRkfA9F47qg+YiLV4P0yv69jOM3WBnUTlWN26Cce6V/fju71lRbKb+V30cMOhBSodiJe3vCWnZi3T9xUG/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627798; c=relaxed/simple;
	bh=OppIv1YpyNhdlFD/zjoKfAAObHpyjTVilDdCP9CNysU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbZiZTFnW9wiia4ha10ulh9KRmng6wIC+4SQlmImcaBWvaPsdpq6/POARzUsYJpW/QTveK+DO0M0l0RKpx/OncCN+d6ANF3PPfRdotBw0i+WkKrQVPv74fc2EJov2InyK4Q3JPo6bzdM8UAKunXL3/hKKr39P6VDeFoMhS8/Uvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7ZC8THr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7ZC8THr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4CA1F000E9;
	Tue, 16 Jun 2026 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627797;
	bh=8FOUYN7Il0a1yNVsLQrS+I7tnyb58W5NfIFtt0HUFJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7ZC8THrFA7hjms5VJlrga5lmtnrY82lSRUtR4k3Vx45HYNM3J3SuTB9nhlEHMVGi
	 FN/yVgEGXV9d/V3rVyzACYEYD6a3ePWYsY4gB/ygYeX/C5JDlNRYf/Xg8cRVzeC1uK
	 85aKUPP+3fjnjJwamSGgahXMl0d1hqfD46Qpxzzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 212/261] slimbus: qcom-ngd-ctrl: Correct PDR and SSR cleanup ownership
Date: Tue, 16 Jun 2026 20:30:50 +0530
Message-ID: <20260616145054.863717513@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1690,6 +1690,9 @@ static void qcom_slim_ngd_ctrl_remove(st
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pdr_handle_release(ctrl->pdr);
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
+
 	qcom_slim_ngd_unregister(ctrl);
 
 	destroy_workqueue(ctrl->mwq);
@@ -1700,8 +1703,6 @@ static void qcom_slim_ngd_remove(struct
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
-	pdr_handle_release(ctrl->pdr);
-	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);
 	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);


