Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A123CE;
	Tue,  3 Dec 2024 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241801; cv=none; b=mEVv8EPx04h6dD7JAtSEIKDwEAR19y82m44tTitXtsrjFI93OEpdOXwueDwDnwJqRmwcZKcASz5ZRaR6AvjIKyQuFfErEh3TmqcB9cAPq8JwhkS28azoTUkssc/T04ECHxQFHv7G08fBzkd/isP1tYAnBoMTk+ehFe5siW5fbSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241801; c=relaxed/simple;
	bh=nhHPyBsbZbxozTJ4ze/xL0cM78VQM6+MGyws4tZgUBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9/3qlFSqqpOv2XwiXTCqih/8Seau4Mc9KqSJkrb57nsnr086dOmVLoqyWcq/uPshTsenC6pCVEItLBJrVng4dhF14VS06QlCet9MRJHBqV9c7A7yDXjO5T+S0BVe00g4nHBuEWtPk3GpqaoRtclekJ88aJZzGdvpRfmLO9Tuck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3J9VDg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3J9VDg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105ADC4CECF;
	Tue,  3 Dec 2024 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241800;
	bh=nhHPyBsbZbxozTJ4ze/xL0cM78VQM6+MGyws4tZgUBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3J9VDg01p8c9Prynb+4Wu0kmp3XHV+5biKnY3ZnFrQCVvf3tHJW0ZO6h/DpbjAv0
	 ole/FMpuMgpnY/C4vjzgkGPn72xtjZ0vf/gl7WU2vx9G8qK1PeLkFQAmYmwcNO05XA
	 Pn1/JbVNefA79E7ecLWMOv6+mty8mVJ+G1cmwYn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/826] remoteproc: qcom: pas: add minidump_id to SM8350 resources
Date: Tue,  3 Dec 2024 15:44:08 +0100
Message-ID: <20241203144804.085819917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e8983156d54f59f57e648ecd44f01c16572da842 ]

Specify minidump_id for the SM8350 DSPs. It was omitted for in the
original commit e8b4e9a21af7 ("remoteproc: qcom: pas: Add SM8350 PAS
remoteprocs").

Fixes: e8b4e9a21af7 ("remoteproc: qcom: pas: Add SM8350 PAS remoteprocs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241027-sar2130p-adsp-v1-2-bd204e39d24e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 27b23a000c7ae..f4f4b3df3884e 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -917,6 +917,7 @@ static const struct adsp_data sm8250_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
+	.minidump_id = 5,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -1134,6 +1135,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
+	.minidump_id = 7,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.43.0



