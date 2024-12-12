Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CC0215795;
	Thu, 12 Dec 2024 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016581; cv=none; b=ctOHQFQYBQlmHwRsBlKn4Q9+JjchuT7uzBzBQgJbvWQVzVTmFBXf21hZ+ZF6ONtwgsf4Vfa3ONf+fZb3X1h8SkX5R3c2wdRnNOJzQGeIM2o24PuaHCNTK7hGMCjpZC6ZUJxpndrDZCRuickw/mxI64nNAJuo9HW86x+j0Sr14GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016581; c=relaxed/simple;
	bh=GWpMa40uK0zaQvz3VSqnjq3n5SoYxXiYdNkpZlvKsFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJhDs1Ci2URtxfDqN5CIVMTm9qDjLEU+p4MNXQNBaUMQ83v8PTBgQLP1H7KvuQWRJhb53an4Q6hwAahGtUvL/w+GDe012uK39uwbxkc6euP3Jc4C/lwNsxZlj2uJPeqXBLgra68ay1uDtPMmXEJxEAkPmNTxdR4ohF+esAPaKcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrBVAs1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrBVAs1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FD4C4CECE;
	Thu, 12 Dec 2024 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016580;
	bh=GWpMa40uK0zaQvz3VSqnjq3n5SoYxXiYdNkpZlvKsFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrBVAs1Dtj56JLviiGwAZkAcNrqyS7QnlC4daGJhZifaedTFBUw41hdGR3SyziVx4
	 r146qQr0j1bC1hQXbwpLXytcGO32CA2hg7fIYyVI7OfclDfuF/9CtWNoJFVEaEJBs5
	 TTYFU9bfZhk/B61zN4LnBUz0HeqQHtfRN1d7ZH4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maya Matuszczyk <maccraft123mc@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/466] firmware: qcom: scm: Allow QSEECOM on Lenovo Yoga Slim 7x
Date: Thu, 12 Dec 2024 15:56:48 +0100
Message-ID: <20241212144316.224510846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maya Matuszczyk <maccraft123mc@gmail.com>

[ Upstream commit c6fa2834afc6a6fe210415ec253a61e6eafdf651 ]

Allow QSEECOM on Lenovo Yoga Slim 7x, to enable accessing EFI variables.

Signed-off-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240919134421.112643-2-maccraft123mc@gmail.com
[bjorn: Rewrote commit message]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 2e4260ba5f793..f019e0b787cb7 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1745,6 +1745,7 @@ static const struct of_device_id qcom_scm_qseecom_allowlist[] __maybe_unused = {
 	{ .compatible = "lenovo,flex-5g" },
 	{ .compatible = "lenovo,thinkpad-t14s" },
 	{ .compatible = "lenovo,thinkpad-x13s", },
+	{ .compatible = "lenovo,yoga-slim7x" },
 	{ .compatible = "microsoft,romulus13", },
 	{ .compatible = "microsoft,romulus15", },
 	{ .compatible = "qcom,sc8180x-primus" },
-- 
2.43.0



