Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9FF3C1401;
	Sat, 30 May 2026 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166419; cv=none; b=qCdSa/EdUq0+nZ5lijDVeEcPRz/xPx5g50pn1nASOShG1H1r9Alh2f+7NtoJpz4ed6E5uV2rbxMnP2G9LaBt4JB/NPpNd0XSadkHCHJJpcaMG3bNW5w6CeJrzpjVIlK9hsNRh+zezeHzv0GWk2dT3Bppq+c5MVF2rMCivUjliF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166419; c=relaxed/simple;
	bh=3sBheGnbgFmnaNmwtNZmosIh7psBf5UakHhd4q2q7co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/ZuIchiNnwlsJRMEPBM0EmLYnms560FJQBkl7kEZ86MYX1kIR959FtVFvbG6VN09tVwDzbTIoWdUz0ZcWb33sISV+m6YKg/1xXLzIXaufVDw8oics58SQV/E3YHKp1sKd+fUoZrSM/VrQcG39LpmTGRObnZlQtDwmo1ArxoM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntqgpCp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntqgpCp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A63E1F00893;
	Sat, 30 May 2026 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166418;
	bh=EOinN+rLUhPF+aQKe2Eowci80b3gkVFMmPwfj3OULg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntqgpCp3bOJvDq57o6NW96wF4zr/UgJk5f/CL001FrBy7UdyPgRGsCFetu6eSpwBP
	 28LzKjDVm5n5L9oDlithQQ0fH0tYFo/HkUPG5euMIEhhFslT+J4TccAGykx5Wg8r65
	 168YS2o7/ofKA7pNBVYSfif/808ItWe+96X82HKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/589] soc: qcom: aoss: compare against normalized cooling state
Date: Sat, 30 May 2026 18:04:09 +0200
Message-ID: <20260530160234.502446708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit cd3c4670db3ffe997be9548c7a9db3952563cf14 ]

qmp_cdev_set_cur_state() normalizes the requested state to a boolean
(cdev_state = !!state). The existing early-return check compares
qmp_cdev->state == state, which can be wrong if state is non-boolean
(any non-zero value). Compare qmp_cdev->state against cdev_state instead,
so the check matches the effective state and avoids redundant updates.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake up the SoC.")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260329195333.1478090-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_aoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index 401a0be3675af..6e00a82742a14 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -430,7 +430,7 @@ static int qmp_cdev_set_cur_state(struct thermal_cooling_device *cdev,
 	/* Normalize state */
 	cdev_state = !!state;
 
-	if (qmp_cdev->state == state)
+	if (qmp_cdev->state == cdev_state)
 		return 0;
 
 	snprintf(buf, sizeof(buf),
-- 
2.53.0



