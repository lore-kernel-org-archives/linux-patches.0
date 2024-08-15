Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF26B1714A8;
	Thu, 15 Aug 2024 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729209; cv=none; b=go/AhQqTCn4YRwUbbv0hVryyn0nWnkj8JciDT3sPXXTJbFq4KbAidQ11GAiP27HE3U63yGEV9ZzLhUJ/stB4vmei9OlW9ySXehyDoFlCr43Cwz3/ip8+E7N8JJ6zomF/z915zEWILkFgyQvvlz2d7BYrosG54ikocmU33tosjNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729209; c=relaxed/simple;
	bh=bXfav2P56VxPTGvtniJQPSA/Tq2lz49cHQI+d9bYhms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLE2VbMK3r6oHMmBrMisuiGkzLgPXMMfL3r34HzgiGTnrc5YLcyXLPEspWCkNdQRgLAI4ijr6YyKSxoX1wrv3aB9nv6qqt4HNum+JCrARE6dyNa3s0PteVqGp0jONYTuA7hcc7j4Bf3vsocZvmV4ksbxmY2qPQ0hL1K0eORF6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LstjNtYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LstjNtYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36338C32786;
	Thu, 15 Aug 2024 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729209;
	bh=bXfav2P56VxPTGvtniJQPSA/Tq2lz49cHQI+d9bYhms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LstjNtYpkTIlsb/YRZukAqlsby51NHxn5yitLvS3QtShFGFxIxbqXtIAua4DLCL/N
	 56uv9WB6JGzE0tN9d+0EoqOaSUM8wrVSznAIs785aTNR5/Itgo9GFaxpecVcf0c2Rg
	 u9cd1yBBWHvGtJxMVlbkKUTFbw8TTBzEA41JhXGY=
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
Subject: [PATCH 5.15 025/484] soc: qcom: pdr: fix parsing of domains lists
Date: Thu, 15 Aug 2024 15:18:03 +0200
Message-ID: <20240815131942.247448153@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b308d942bbd6c..e20d97d7fb658 100644
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



