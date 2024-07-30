Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0A1898E4;
	Tue, 30 Jul 2024 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355816; cv=none; b=Y6dfUVihG5OBt0z9+2qF/D8o2B57HVT+v+UmyWHcCXYbIXKHU04iw3F0byiAW/maJ0vRuhqPoWltu8J1b2qpEEU9AmT76KSQz9GOghzIKPGnIu7lhq4UA9FyfeP/k2hViAGJuhRrc0nmxKbsGGYZyxTxxn8qxRr+gR3gQxTRox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355816; c=relaxed/simple;
	bh=nBw6duCCnpEIQESR6vjsz9ekvqcTkKrlexaZ1qgQyN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJL2cnEvJweQyS95B+Udb3t5IpJBnTf4+gNNQhEGU/9mBBSW5ez3W5dJB3tF8bo/6riFt87uD2yTogpXZr7OOACM21VEtjBHLHuYyzZbsJKRBKcRzHpkxOgsL1XTCVNCtFIXXugm24wLahIicqAubCOxv5kk/yeNiMGrycIInvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDHICvCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDHICvCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A881FC32782;
	Tue, 30 Jul 2024 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355816;
	bh=nBw6duCCnpEIQESR6vjsz9ekvqcTkKrlexaZ1qgQyN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDHICvCJRf0KzB3u545D870c+2dkz2jwtZcJdepHsBxmB/oZNz+D6B3DV/Zi0MToY
	 rQTCfXPFysH87pvpN8Y3iMwVoOP39jQ1oTF828/dCXv/3C8m2qZJbOHy/JqyrLgtmE
	 GKNp67AmFZLisk+xWmBPLzslmFsJ7DIoHI/Qh2y4=
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
Subject: [PATCH 6.10 091/809] soc: qcom: pdr: fix parsing of domains lists
Date: Tue, 30 Jul 2024 17:39:27 +0200
Message-ID: <20240730151728.232869155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76a62c2ecc58a..216166e98fae4 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -417,7 +417,7 @@ static int pdr_locate_service(struct pdr_handle *pdr, struct pdr_service *pds)
 		if (ret < 0)
 			goto out;
 
-		for (i = domains_read; i < resp->domain_list_len; i++) {
+		for (i = 0; i < resp->domain_list_len; i++) {
 			entry = &resp->domain_list[i];
 
 			if (strnlen(entry->name, sizeof(entry->name)) == sizeof(entry->name))
-- 
2.43.0



