Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DAC28DC4;
	Wed, 20 May 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298506; cv=none; b=FNj85rZEN3pS1HFxgbBedz3xoRvdDJ8ZdNpNh7r8i5ESvusK42vF68f/kIm/WqvGLyBlxZXmaXFW1zVTyDTR0hjO5Mp0HJ7nizvphLOqCISSNFvoQxF+KBAFKKNF2FuxnyjFQIQ9/yfoXgDE24p4zhrZNQ9cyIOEAOFJOpzXB6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298506; c=relaxed/simple;
	bh=W3AuZketVAtq0s0X/d7r3jgp1+cO8m57Eudi6x72f94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7Yj6uBjx0ea/6iw1jAGm4ANPh8JmDQstYbSgwoCPZyCpQ+cMq9mOB6m+Jc6Os9l5Z6Qj7D2TXvJ6a7WdRfC44LSIz6JtnjFwMu32HRIczmJQzc+kwdDlXciapd4cjKtTp2rCd/Mg/7/5fQC8ilriMnxZmnVL1drTvPBdp+8TME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7H7Kx1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7H7Kx1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1FD1F000E9;
	Wed, 20 May 2026 17:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298504;
	bh=WumE+9f+JJG4TDA892vK7HGpuz2yHKBw70LRm1pk1jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7H7Kx1FwZ7O9koJdU9ftv/r+np4YIz6jji55bWjspPZJ2mTY+s+wRgXsTzWce+3V
	 g3+6etSwTjvXxwOxIDIqKdbGSnemvURkT1nNK5W+W7IFp91z6GVavV+dN/BPN2JiVa
	 vr2t9JasWByil/L8Gos65QbGl/F2Q1LUrFp/spl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/957] soc: qcom: aoss: compare against normalized cooling state
Date: Wed, 20 May 2026 18:15:17 +0200
Message-ID: <20260520162143.933524830@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a543ab9bee6c4..c255662b8fc3d 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -355,7 +355,7 @@ static int qmp_cdev_set_cur_state(struct thermal_cooling_device *cdev,
 	/* Normalize state */
 	cdev_state = !!state;
 
-	if (qmp_cdev->state == state)
+	if (qmp_cdev->state == cdev_state)
 		return 0;
 
 	ret = qmp_send(qmp_cdev->qmp, "{class: volt_flr, event:zero_temp, res:%s, value:%s}",
-- 
2.53.0



