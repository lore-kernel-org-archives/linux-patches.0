Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025942210E1;
	Thu, 12 Dec 2024 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019748; cv=none; b=KeLk5vWArs0rkq6C4NHZbtFGs3VlLFoXuWJBVKXoi1J4Jhk3spIDXbDAIMYNUN5KKWz3YMsqtjUUI9Axm9w3QNB/FX6kfp47d/XR5SjQuyLIzQRk7WWwhbjG+ShhNJ8wAX/y9kkDPMwxUIq7jr7sFWBxF1JLNpw+igLeqkov8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019748; c=relaxed/simple;
	bh=lYKxQ7QVSjOeYiM4D1MIxWY2adNWfA6crakgT5SqPCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtj2ecA16USb/Bgc8NekyEd/QSUCxkxXIbEX8s0L7uWFwMFWeVy651otWuf4unw6CQJPe75JHbEWhiVAxVOCnlGAxIWWC9GUMLoFrh7iSsXxof4ldzDzns9vMWi3Ucs7hUsqVP5spSvHBxGrl/wD8DFCWoOKE11ppNIWT468+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP+12CGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP+12CGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C0DC4CECE;
	Thu, 12 Dec 2024 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019747;
	bh=lYKxQ7QVSjOeYiM4D1MIxWY2adNWfA6crakgT5SqPCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP+12CGBwlpHrSxAhFqQPUwYhs+JutVOxjrRq/fuvXAygYwbqnSjtYhkbMa7aNBg6
	 cBhNv3iS4Wq90Ba6+MKOGze2kW9NgaPvZ1l2X4IL1u/PwErjZq3iJp08B+EZuraSNQ
	 3iZOcmQyazayg+VxV8WJDoGlEEOrQzawlkd2K4ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/772] remoteproc: qcom: pas: add minidump_id to SM8350 resources
Date: Thu, 12 Dec 2024 15:53:51 +0100
Message-ID: <20241212144401.725788851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 533cee25b18e5..631c90afb5bc5 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -632,6 +632,7 @@ static const struct adsp_data sm8250_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
+	.minidump_id = 5,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -773,6 +774,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
+	.minidump_id = 7,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.43.0



