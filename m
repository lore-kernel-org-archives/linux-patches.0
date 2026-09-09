Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B995F492E2A;
	Wed,  9 Sep 2026 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964680; cv=none; b=A9m1kFGGK7OAOc+woG0It+5MI/L9qjrb81RZhnDKMABUGdMe9DuTN+/rQeeh9BAA6wXFPvzsIwHAsTOvbnb8QfwFbbhHiIumvseiTcCCLrD6Vq1/o0Ln1qgLdbakYPvvHvH+hwYkqOK5f2FXLQKlVBMXR+Zf903C/esE6eQtG6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964680; c=relaxed/simple;
	bh=/cxBTXhpexO40naCRKYT3yxMrdwcgEouoq3KM+TzNOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMQ0MtGZd4Y7FFKGvHW0D/IAxBlKKvvMdMfUAGKSgXqKdBbWppuAM8wCCZjX75GKtxPN+Gv8wE/S8ZgeS+P471MzFPdrbd7YfZ6919SlJHth4ndXcRvSftn/IQ5LyhCjL1y4NjztvlGoPO6Z6vZzxeVVbnboqkPyhaWvZmqRG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPCtttJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPCtttJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045701F00A3A;
	Wed,  9 Sep 2026 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964679;
	bh=yHd7q76Yo5flekUjnB3GEk3/UytdXmuA38WGzeq37Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPCtttJ4FgSudsfmMcI/aF+gKAXu0Bc2OjiH3ZVoAPnCPh/7l21W/YuOpTU976PBf
	 YD8QDpz6ySdPts6KhFKWxMFHrR+RxDaGa74ZszqUiaMCAxUOspgEkFuQbtNHCq/Slv
	 nvhSfDt2+Gg6nKyQvz9VquJnuipLzzYu6RFQHe4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/583] remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check
Date: Wed,  9 Sep 2026 15:43:10 +0200
Message-ID: <20260909134255.257534763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit c06c5ab4945392d2c2aded6d832ab6b58cabe351 ]

All other call sites of qcom_scm_pas_metadata_release() for the DTB
context are guarded by a check on pas->dtb_pas_id, but the call inside
qcom_pas_load() was not. Fix this by moving the call to the guarded
block.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 29814986b82e ("remoteproc: qcom_q6v5_pas: add support for dtb co-firmware loading")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724182858.1868271-3-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ adapted DTB cleanup to the older separate initialization and loading APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -248,15 +248,14 @@ static int qcom_pas_load(struct rproc *r
 		ret = qcom_mdt_load_no_init(pas->dev, pas->dtb_firmware, pas->dtb_firmware_name,
 					    pas->dtb_mem_region, pas->dtb_mem_phys,
 					    pas->dtb_mem_size, &pas->dtb_mem_reloc);
-		if (ret)
-			goto release_dtb_metadata;
+		if (ret) {
+			qcom_scm_pas_metadata_release(&pas->dtb_pas_metadata);
+			goto release_dtb_firmware;
+		}
 	}
 
 	return 0;
 
-release_dtb_metadata:
-	qcom_scm_pas_metadata_release(&pas->dtb_pas_metadata);
-
 release_dtb_firmware:
 	release_firmware(pas->dtb_firmware);
 


