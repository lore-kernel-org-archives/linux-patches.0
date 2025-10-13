Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C430CD85;
	Mon, 13 Oct 2025 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369910; cv=none; b=EVEhAP4rfF5v3RewQeR9NfPpnRbp4YtpwwftQ3e+A8p0MdUm5dta+U1MkBLG8iwI+24Xey/cqvssYtiqB0FRUnyzjpUrro5H0TfZ8pMwyFremVRyKRKZxPI42jr2wetDB3xxzgH8pJ3xcgSTuPstKvbcRvuM3GDl2D1x1tUbEhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369910; c=relaxed/simple;
	bh=D63vR17dUvi2DmAqEVjM1NScfai5San/quFb3zu7vfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Olr8Kjhi31yf2sGuRK+7Lew44cuq9tM7Gzcejj5snJW3olHt4hcmPP/0Rn6KvsuHFmeDcKcX9YfcS9OXF13bjmDzWU12YSXcId2zgSBhP0Ts0xZLPtarVf/PkgyvieJkMblfRaBS8geZxNtbW07G7V/VPS7DQc1aHdnJndmgGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukzds9eW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukzds9eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163F9C4CEE7;
	Mon, 13 Oct 2025 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369910;
	bh=D63vR17dUvi2DmAqEVjM1NScfai5San/quFb3zu7vfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukzds9eWE2otMG6FP5smxCz3H404YiAbsPMHCt7gsCBErM8jBdlMogI/D+q21Yebc
	 JomtfC2DEy8hGIJywNAv1UIJ2fwAx1xhtk4z1uqlNrM/9ZnPJitzqCz5HnLuNq5pwN
	 1Jowk0E7+l7rRIoZ8GqbCWRbf2/u9X9fvRcGSL2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 410/563] rpmsg: qcom_smd: Fix fallback to qcom,ipc parse
Date: Mon, 13 Oct 2025 16:44:31 +0200
Message-ID: <20251013144426.139193568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 09390ed9af37ed612dd0967ff2b0d639872b8776 ]

mbox_request_channel() returning value was changed in case of error.
It uses returning value of of_parse_phandle_with_args().
It is returning with -ENOENT instead of -ENODEV when no mboxes property
exists.

Fixes: 24fdd5074b20 ("mailbox: use error ret code of of_parse_phandle_with_args()")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Stephan Gerhold <stephan.gerhold@linaro.org> # msm8939
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20250725-fix-qcom-smd-v2-1-e4e43613f874@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 87c944d4b4f31..1cbe457b4e96f 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1368,7 +1368,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 	edge->mbox_client.knows_txdone = true;
 	edge->mbox_chan = mbox_request_channel(&edge->mbox_client, 0);
 	if (IS_ERR(edge->mbox_chan)) {
-		if (PTR_ERR(edge->mbox_chan) != -ENODEV) {
+		if (PTR_ERR(edge->mbox_chan) != -ENOENT) {
 			ret = dev_err_probe(dev, PTR_ERR(edge->mbox_chan),
 					    "failed to acquire IPC mailbox\n");
 			goto put_node;
-- 
2.51.0



