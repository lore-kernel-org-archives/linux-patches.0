Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6371898FA;
	Tue, 30 Jul 2024 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355497; cv=none; b=Xx+20LmPWyRkziypq/VbrAB8I67f5Szh/OldqxOHvyHibGycvwWWay3z4tZeI5cblntx3mmUGlMcFxBDuV1jeT2zkpuuuv+kxEK0ZIRanA687O2NTIFfdp8WNg9QYKinbzvzGEdoxtonkbhJzl0zSbiuv9yAKu52jPgktHEewXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355497; c=relaxed/simple;
	bh=vrhvoVakcQlHdYVRCh6XgFdMtKQ2EH5NB2UYhE7Gcas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH1JBdQzE3+5lMrQhVFLZ1Zmpi6ahMBYACWuVvDv1J9BjLBK39197acEjXSMqhCEm3TtHsNPk1qbMXSB7xfsgdbOPmjvJr5Rd3lPg06wuGElu1adVoG47cPlW4PCjig7K0i1OkFGZY4Uk5iuQS+bvtEEvWNQDzRzatznw9pimI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSmBzPty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSmBzPty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0C3C4AF52;
	Tue, 30 Jul 2024 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355497;
	bh=vrhvoVakcQlHdYVRCh6XgFdMtKQ2EH5NB2UYhE7Gcas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSmBzPtyii3tQzJcBMU0RhhbLGEIFN2kkqS6lSZYEIwzQyGD5a4Fg4h6vym3GL8P2
	 jDBJDAa2/WBxdpln7eYRxkz84HApRMZfRJrjl5cwzNB+vv8ItCdNIpajkR7GWZWCp8
	 A0gIoZs6ss+jq7OQVCbgetHYYGpUNkVrOgnblB+Q=
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
Subject: [PATCH 6.6 063/568] soc: qcom: pdr: fix parsing of domains lists
Date: Tue, 30 Jul 2024 17:42:50 +0200
Message-ID: <20240730151642.322696738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fbf91d7904482..c7cd4daa10b0f 100644
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



