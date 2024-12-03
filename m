Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94E21F6696;
	Tue,  3 Dec 2024 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239211; cv=none; b=DsUaT713PRPZkX7UiOadcZNPKPHesr50qJ4RT3EQyEPS8bU5as3mpyEsE2hylJqC+MaKZP+HZ+RAUkWM7IsxHkDvpGpqLjvV/6OGzHQT7pj9xmUVzmJHroE71l1daUK5ZHRAW7kC+6oFR4BCBr3kaxzoxR5Zw76R8rXy6VoBRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239211; c=relaxed/simple;
	bh=Frn/a7UpvEDZ9h0mO1tU2pdP0q4et8HQC0KqLH3t0kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCHJeWTA/zZcH8e0rmw6lJrdzxN6euEhQO3eLpSdqNhVOCEiuhknHPBDZFO4oFxy8Qzfeld2F56pnq2rpwqvSmzDxunaljXcl7Mw1YsD1bd4ykuV3UtGc7XHJgUZ4cAUcCRGv77YsUBnga5QJHeqJa6ej/bJN9uGKo5AuY6kGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRBcH1NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRBcH1NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA36C4CECF;
	Tue,  3 Dec 2024 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239211;
	bh=Frn/a7UpvEDZ9h0mO1tU2pdP0q4et8HQC0KqLH3t0kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRBcH1NXrc/odX/7AkuwNwOS9B2aq2hOWmjr4BCvDMXkIs2RlQjw4E98NUS9ACaQR
	 ON4Iz8GDNBiPOqrVvduworDziP+o+2ked4DnylyvUviiGafR9v9kxW5vYh20lojxdT
	 +/5UizJ9uJMHdRGGvsQMoMNGGPo17y3vcXxg4VaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 536/817] remoteproc: qcom: pas: add minidump_id to SM8350 resources
Date: Tue,  3 Dec 2024 15:41:48 +0100
Message-ID: <20241203144016.822448210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 65467876f09e2..a4abec1e1e846 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -900,6 +900,7 @@ static const struct adsp_data sm8250_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
+	.minidump_id = 5,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -1081,6 +1082,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
+	.minidump_id = 7,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.43.0



