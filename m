Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD54C33B97A;
	Wed, 20 May 2026 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300791; cv=none; b=X0nphP0Mrdn0Tj7CH9jiDiZvnaKXQoAA5YkbleOp70+R1oAgmFiUdaU3zFtAbeuf6HiSGeVP0cN6XhwCT0Dc7kqkPuAf30pLPDS26SHOzSL+9McL8Az0ECZszk0cBMrNXiCg6qs9mzS6rnyrR1LSSv6FlxUJhYX9I4LaeRBMRGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300791; c=relaxed/simple;
	bh=7Doxv2gg7s4no+jIVfQsTb83/TNXX986jFmykH5uXE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIE5SQDZ2kfb85GsZoCEW3NqeRh2F8iWJgqzkefWhIi/dGnEx4AnuhLh8+MLOk6iO2pA7m3C9VTFaOd80a/6D5nFU7XnLazh7BrbNpw/FJYzi7G6OqKPY16suAEgNcVYHESmiXf55BZuFht/wxbohuQ5gcrJGMr6C200a99wnBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2q1fbT9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2q1fbT9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9CC1F000E9;
	Wed, 20 May 2026 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300790;
	bh=1sBAwiANU/hjx1tHf4xmXFVLF9y6xsuN6yiFHRuDZ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2q1fbT9bnWtnMjTyIQK9vpvt6QF3596VDCJZ1cOLizcWOEd37oAkqGiwtcbIJbbcz
	 vQK6HzLOqqPQsaaYeaXM15CZD7fRF+wOaRvQA0ezwM98PEXp1mgcn85elq77zwZ+YB
	 r0gbSgzBuWNBfQOFxsijnOV0djxtwiSMOp2/VebE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/666] soc: qcom: aoss: compare against normalized cooling state
Date: Wed, 20 May 2026 18:18:41 +0200
Message-ID: <20260520162117.941053301@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 0320ad3b91483..d7cd449c57b69 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -354,7 +354,7 @@ static int qmp_cdev_set_cur_state(struct thermal_cooling_device *cdev,
 	/* Normalize state */
 	cdev_state = !!state;
 
-	if (qmp_cdev->state == state)
+	if (qmp_cdev->state == cdev_state)
 		return 0;
 
 	ret = qmp_send(qmp_cdev->qmp, "{class: volt_flr, event:zero_temp, res:%s, value:%s}",
-- 
2.53.0



