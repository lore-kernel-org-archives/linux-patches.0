Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031F81A08DD;
	Thu, 15 Aug 2024 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732019; cv=none; b=L6k1Ez7DbvwSjaBrUW/gwnSUvof9uREpmiVAJogT7+GQABpd6QpkvROpehQCRaE0Z6vml/FF+L8kYihkh/3RR63aDew3Jl0itdJemQSNqIF+LII/wrWMMC/5cWKq4nEzrIaab0A7jwIaQ8gdLaorfBmjrKaf8Vwfv0aZRrQuJQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732019; c=relaxed/simple;
	bh=rp8OHhY/9dwQ3lOMJCemue/6V957mtYVU+dtIBFmlB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyFJ6/wymw089evnKZmNTR2flwA/QoLQAP2hFMUhWX1BqaEbMOnOIBcwm3WvGWBvIpPr+wxrEjg8kF6raSaaGb3QC10kAwwfNwKM4NXuiU2yQdrm2258RFZpaQozRaDXR+7VNJ0U2HK/sFsribG9cRZtZIy6jfOcL9pI+chKYrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA0q7l+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA0q7l+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D414C32786;
	Thu, 15 Aug 2024 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732018;
	bh=rp8OHhY/9dwQ3lOMJCemue/6V957mtYVU+dtIBFmlB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pA0q7l+hGJBtgNfAkBDNlAN83sEraQoSgki608yWejDQvLEGMLneWfojY6YXr5RVb
	 PdCPWwsGlurLIo/6ZBvNZ3W5GxLAUx5w2XSHvnhkGVYpYIfFNoIBAIDZkrKz1xN4vL
	 rfN7t3hvadvNE3ycboLUD66EGHCu0iRKyzQoiUEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.10 018/352] soc: qcom: pdr: fix parsing of domains lists
Date: Thu, 15 Aug 2024 15:21:24 +0200
Message-ID: <20240815131919.919330737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 57f20d51f35780f240ecf39d81cda23612800a92 ]

While parsing the domains list, start offsets from 0 rather than from
domains_read. The domains_read is equal to the total count of the
domains we have seen, while the domains list in the message starts from
offset 0.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Tested-by: Steev Klimaszewski <steev@kali.org>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240622-qcom-pd-mapper-v9-2-a84ee3591c8e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index 373725b6d5444..6e3cbd8226637 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -418,7 +418,7 @@ static int pdr_locate_service(struct pdr_handle *pdr, struct pdr_service *pds)
 		if (ret < 0)
 			goto out;
 
-		for (i = domains_read; i < resp->domain_list_len; i++) {
+		for (i = 0; i < resp->domain_list_len; i++) {
 			entry = &resp->domain_list[i];
 
 			if (strnlen(entry->name, sizeof(entry->name)) == sizeof(entry->name))
-- 
2.43.0



