Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC08F1FCD11;
	Fri,  6 Dec 2024 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497737; cv=none; b=kRNwe84PlEubNwpwhcg/OHxEaVRcfsWBvXv0shDeeSQkhLcgsl0oZ4P/wpRgfD80eNHdYFDktHe+e0kWRD3eR4C6yrOYUQ+cp7JoZwHarGL7ItgeuMolakXNdoKCGRG7GNwePXn8AnIeKUrPpoHaX+3uYmro2vaisKjE1YiVCuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497737; c=relaxed/simple;
	bh=XD7wwVZJstpv0cUMdmPLtjMbKPch/fwVXpBNsnBkwIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrTuqyNPMHsBRCxPC7fEOIUw+aTQiQPxGSdRzS+fdflR9Wi8dopin/v5+KiOkKcUVaFSoEvbxbjZws3muQq5Mh2Ij3vzgz0LXCiKxVgDPR3OXsaE+dPwyGAnOircCPN4HkSh7QexoFBJ4WAUmwKRtW8abc8jslC3wkTXG2FSGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYsCJHdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYsCJHdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B6AC4CED1;
	Fri,  6 Dec 2024 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497736;
	bh=XD7wwVZJstpv0cUMdmPLtjMbKPch/fwVXpBNsnBkwIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYsCJHdPEsVXhqYWHLuKp3aavemrsAJSZeU3fuXl5OuLVCPmoxBm3p7/luiUKYMBb
	 5X8VVLXNK9rUJ565kSNGzPdlwq7Y9rkbbwIFejGc0oyOQA7RQBzmoxQTrjeFVt/bHN
	 5bH/rAl4SdSvEp6QjCqkyqwP1q+wdClBuN8qEJP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 377/676] remoteproc: qcom: pas: add minidump_id to SM8350 resources
Date: Fri,  6 Dec 2024 15:33:16 +0100
Message-ID: <20241206143708.071885890@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index b5447dd2dd35e..6235721f2c1ae 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -832,6 +832,7 @@ static const struct adsp_data sm8250_adsp_resource = {
 	.crash_reason_smem = 423,
 	.firmware_name = "adsp.mdt",
 	.pas_id = 1,
+	.minidump_id = 5,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"lcx",
@@ -973,6 +974,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
 	.pas_id = 18,
+	.minidump_id = 7,
 	.auto_boot = true,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.43.0



