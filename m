Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7425A334;
	Tue, 11 Nov 2025 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822913; cv=none; b=nwqPl3dwy4D3q0o3ZGu4Z/cQPdVlO+pN/y3DV1f58ubi89nA0Hghjv0wnxcB9r+HjBq7KQ/kNz4I75jnPUX0gorQq2uWumm4FJeT6ZBrqJgfYTtGpZ7F15T7PybaMsfLAERN6MdpNNdsH85XvY3XQ/ov/tqnSuDbmqYJr7DfJXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822913; c=relaxed/simple;
	bh=IsOCcuVctrSHBbIEA3OSFjBOrFSg2SYI4IH51XLZVcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDGO9CwfRy2SmQfkJtiGAt5uBaR/LocJPMP4TTBycVtGOO7YWxQXVSeTS5U3QCL+fAvHEOSm6ktaCrhsZjHdaWqXkMM+BXPU2WQCqqtxjAthb2P5f1/54C4T+R2/HLoQbUDwuReRw7JOIB9OR/2OlUGmYsPc5yFZvnWjkdBcqgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xuov7w21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xuov7w21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E4C4CEFB;
	Tue, 11 Nov 2025 01:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822913;
	bh=IsOCcuVctrSHBbIEA3OSFjBOrFSg2SYI4IH51XLZVcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xuov7w21tlJ5UrMW6fStvsaLzTV5CyG+u3qjD0rYVI+ahSUDUM99KGKWtKgqiWHFe
	 aj9LEf+0+nBAQoNXNeGCECYVieAT9pWVhDFlI4vK5Y7uZgMp+z41jOHRslKMyKRgkQ
	 hvBscVJ1pv7vBpKPKFbJWio5/RLlfz6CUM5HTjmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/565] firmware: qcom: tzmem: disable sc7180 platform
Date: Tue, 11 Nov 2025 09:39:48 +0900
Message-ID: <20251111004529.918825662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit 3cc9a8cadaf66e1a53e5fee48f8bcdb0a3fd5075 ]

When SHM bridge is enabled, assigning RMTFS memory causes the calling
core to hang if the system is running in EL1.

Disable SHM bridge on sc7180 devices to avoid that hang.

Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250721-sc7180-shm-hang-v1-1-99ad9ffeb5b4@trvn.ru
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_tzmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/qcom/qcom_tzmem.c b/drivers/firmware/qcom/qcom_tzmem.c
index 92b3651782355..f8fef622e48fe 100644
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -76,6 +76,7 @@ static bool qcom_tzmem_using_shm_bridge;
 
 /* List of machines that are known to not support SHM bridge correctly. */
 static const char *const qcom_tzmem_blacklist[] = {
+	"qcom,sc7180", /* hang in rmtfs memory assignment */
 	"qcom,sc8180x",
 	"qcom,sdm670", /* failure in GPU firmware loading */
 	"qcom,sdm845", /* reset in rmtfs memory assignment */
-- 
2.51.0



