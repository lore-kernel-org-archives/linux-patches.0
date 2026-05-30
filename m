Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44850341AC7;
	Sat, 30 May 2026 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164341; cv=none; b=iTPRfQMPd4oXEv76k1eZJ9TNKIYWLExvVzRo6FFGgp15/cxXOhTdkLODVTjF6sHOpRgNbPvc775A3gcBjJyMFnVTzgAGtCHlgNpx5wIjAskGY7sao4EfFfJOXEO91wC5ymPNxEhJQE6ya8PFTTEEZQ8DQIHDIY45Akt0hnMv5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164341; c=relaxed/simple;
	bh=cAfyDD/yFuzf1Z4PHlladBaFGA6+peXbM3wq3AXiOkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mohulp7zaMgzhAX4XRIlzPfVaQTJNaslOOaE1wYytWXxX3dCFICTdcidJURPYcegdF40kOUF6jHLm4RrvAnGtWIGb93I5m+OnaeqrpYX7jTGV2bqUZulkAdE7pFEWzCry8EYQScj0Acf8i9jrrTarHPA0AQAIuF4Ipl2l/NeGmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVVYUL/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVVYUL/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DE91F00893;
	Sat, 30 May 2026 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164340;
	bh=HY5V0BNEWtf0Buy0EEu4p15isEg40yD+GnjEufgjYJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVVYUL/+j1sIDRI6+RrHT8m2KdxjCq4o+SNPGCMBkZciXD01pFxwbbB2i4wAmoKbc
	 mNlsTNfnHjvVTUnzI8CUrH7bmliw3Q6tN2/CrZlvlCjONVVLdW1JqmGdtcQzhzASLr
	 3/G2ykOTSTvWMSKC4N0Rc+zVcD+Tp7iRRUlbk7YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/776] soc: qcom: aoss: compare against normalized cooling state
Date: Sat, 30 May 2026 18:03:30 +0200
Message-ID: <20260530160253.124037974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index 3973accdc9820..dbef3b27e594a 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -436,7 +436,7 @@ static int qmp_cdev_set_cur_state(struct thermal_cooling_device *cdev,
 	/* Normalize state */
 	cdev_state = !!state;
 
-	if (qmp_cdev->state == state)
+	if (qmp_cdev->state == cdev_state)
 		return 0;
 
 	snprintf(buf, sizeof(buf),
-- 
2.53.0



