Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075D3A542F;
	Sat, 30 May 2026 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161321; cv=none; b=kJB36MgMcq2BAK5usdZmwVbRVtNrOe7P7qeOv3QyWLM46ByxVHB8cgknYn//tb9APzrwaz2vhSmYY6DOevC1T0rqqUv73pjCzJTYl/0hXY/0vYV4rN8Hv2jCg0bvkx5SZbzMPPuQQYVw5iCcvws0RtiONCk/iIZT6Ac8GyQw8UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161321; c=relaxed/simple;
	bh=N9BJ8xlopD2VH+cEje/hnd/Zq5AwovCJCgwh89ewi1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTxG1q5IjQ9HGTIbSphxWkVgUVbaD//BCOVqckTvHy33iql8ohfL6GqVL15tD2AQu5vSfUqS4sUAJA8d0K79Liib7I5uv5DgFfLyc6EPlA58bySjXBPhun4RF4LlNOEbKRi8etRzUsnP24qeg4Jf48f4w4P5CDANLLM1vo3vcSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uefLz9xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uefLz9xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5689A1F00893;
	Sat, 30 May 2026 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161320;
	bh=yZUrbydsuqbspkyhDIrAeFjcmHM4tlun1qknQskn6H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uefLz9xqD8+lrlfZzh0Qq4fnsV6KII302mmWPsPJWK2yQoRjqt9aO3JVViKUPUvfr
	 U/bRoRI9kLN0fI8YiMODZWqrGokbQQYxp6Tf6K5/1VzXhZisEoSx0eRsC2TrRsPdyz
	 G6WNq0Acfo0rd962FBrlAJjZGHNPF8eIh0gzgv+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 589/969] soc: qcom: aoss: compare against normalized cooling state
Date: Sat, 30 May 2026 18:01:53 +0200
Message-ID: <20260530160316.678214251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 18c856056475c..8b828d7a59060 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -336,7 +336,7 @@ static int qmp_cdev_set_cur_state(struct thermal_cooling_device *cdev,
 	/* Normalize state */
 	cdev_state = !!state;
 
-	if (qmp_cdev->state == state)
+	if (qmp_cdev->state == cdev_state)
 		return 0;
 
 	snprintf(buf, sizeof(buf),
-- 
2.53.0



