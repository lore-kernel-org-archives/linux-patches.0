Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0EF3B9930;
	Tue, 21 Jul 2026 21:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670882; cv=none; b=QeXr+SX7dTByqVBgjmbtmbRnGkJPag3UVzq7AWVT2FaGJK5YJnv7c5Buo9GsS/Kn45F9FzIB5TbE0c4QF3AETAcrtqyqhwF9B5pCgBrnU7HwzCHV8CzJ+xY/JKOr9XAor3X+dNABvYnBGSRD2z7tPk/C1cnqm2HxoO+f83pZ+L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670882; c=relaxed/simple;
	bh=ukjBHwRyGzCvfJY63W9QCT67nLUBXNtgHZ40RepHU1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyKQBJ10RHTSKeDImlwLXJAKAioH8jadLIjk+EsIie7rzqAvc/SSRErrkCnuxlPrQYBNckyN8cokrjnOhwYoOKOYur0MU3xDpK1X3xbswChibniKA3znihshCh3A6I5KsPs85rI1T9e7bdYgTMMhWrfrNsrMkYqMLlBmIPbOVFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=op8J8TVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="op8J8TVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E131F000E9;
	Tue, 21 Jul 2026 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670881;
	bh=CdGRRY5skakYT8UlASQHZfhP//fwOc+bapjvyFj0bDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=op8J8TVbaEtMcG4OcYuihIbT2zMqd6CKMUtFi/Mt5J+QYLpg7O8v1xFJLdo+JQFxQ
	 zj0dmeHq6+Ss6ytHP3SqMiIR/XVwFMAng1+SdZvAp4wuauzXt4od1eiPSu5oAFpZ69
	 S0oXw/wgfTg+KE1LCqmrRGCIL8P5ZWEWfaWr9rqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/843] slimbus: qcom-ngd-ctrl: Correct PDR and SSR cleanup ownership
Date: Tue, 21 Jul 2026 17:14:06 +0200
Message-ID: <20260721152406.208831439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 960b53a3f76fa214c2fc493734ae7b3c5e713bbf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 0ee537576b8204..91e9a39c6dcf03 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1601,6 +1601,9 @@ static int qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pdr_handle_release(ctrl->pdr);
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
+
 	qcom_slim_ngd_unregister(ctrl);
 
 	return 0;
@@ -1611,8 +1614,6 @@ static int qcom_slim_ngd_remove(struct platform_device *pdev)
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
-	pdr_handle_release(ctrl->pdr);
-	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);
 	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
-- 
2.53.0



