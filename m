Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F525A357;
	Wed, 25 Feb 2026 01:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983471; cv=none; b=aHYYK4DkcsBODBBpHW8D0IncL/gKJUxkHgYHUFtNAC/PrE0u5PWSNxKK0h+88HyLQhnR9tWVTtKiAys56FeeAlOVsOO4bB7LHGo9fZHQOTaScS3mMtLdFaRNfQhww4DUu6u+zZ7tyaR0jOFXMTcpzG2fS9684cxpTZ6fqFHuu8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983471; c=relaxed/simple;
	bh=ogzwiv+o6fhV/3RSSIyYGB8rkazzWDPCK58i8CVbvQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2LbkcAXGR3DdBGae8xxCv3WnE+KpoKqzhn8gx1MvnclVrfZmjmj3+Hscpl3OGZpWszy0UrTRFHdoqEMk+aHiHwz2SqzIaBJ1KoHZ1RPjqE6I6bHpPJ5Vw2asofGtsPyuMdR49GI2i9/KCihiZDNkCamgkNFHBZ9kmSoji8gInw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFBBxQgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFBBxQgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E63C116D0;
	Wed, 25 Feb 2026 01:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983471;
	bh=ogzwiv+o6fhV/3RSSIyYGB8rkazzWDPCK58i8CVbvQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFBBxQgJA1eTJjZmz58kXP6jgVu9up7g4N5ASMGcAg7sKvmc92yy3ySHhsLvTD5ZU
	 olviwuBLaqhin9gqNBQutsnM/u+w/Ru75Y3UYukpJGUAnP9jDh5YoApjSeC6b08xtq
	 qy7DahYHZVdaAyFeFFGMPDSXNqWQpyWcP8eg6lm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raviteja Laggyshetty <raviteja.laggyshetty@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 586/781] interconnect: qcom: qcs8300: fix the num_links for nsp icc node
Date: Tue, 24 Feb 2026 17:21:35 -0800
Message-ID: <20260225012414.175133604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raviteja Laggyshetty <raviteja.laggyshetty@oss.qualcomm.com>

[ Upstream commit 3dc4092fe5c8baf6bf4e882b44615f19564a5076 ]

The qxm_nsp node is configured with an incorrect num_links value,
causing remoteproc driver to fail probing because it cannot acquire the
interconnect path for qxm_nsp -> ebi. This results in the following
error in dmesg:

  platform 26300000.remoteproc: deferred probe pending:
  qcom_q6v5_pas: failed to acquire interconnect path

Set num_links to 2 to match the two link_nodes, allowing remoteproc
clients to obtain the correct path handle and vote on qxm_nsp -> ebi.

Fixes: 874be3339c85 ("interconnect: qcom: qcs8300: convert to dynamic IDs")
Signed-off-by: Raviteja Laggyshetty <raviteja.laggyshetty@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260120-monaco_num_links_fix_nsp_ebi_path-v3-1-536be21ce3ff@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcs8300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/qcs8300.c b/drivers/interconnect/qcom/qcs8300.c
index 70a377bbcf293..bc403a9bf68c6 100644
--- a/drivers/interconnect/qcom/qcs8300.c
+++ b/drivers/interconnect/qcom/qcs8300.c
@@ -629,7 +629,7 @@ static struct qcom_icc_node qxm_nsp = {
 	.name = "qxm_nsp",
 	.channels = 2,
 	.buswidth = 32,
-	.num_links = 1,
+	.num_links = 2,
 	.link_nodes = { &qns_hcp, &qns_nsp_gemnoc },
 };
 
-- 
2.51.0



