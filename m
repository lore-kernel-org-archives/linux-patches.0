Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E28257431;
	Wed, 25 Feb 2026 01:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983002; cv=none; b=o262xRA94horq0zvpXXpNZ20351RWEfF79Wn9wEl4Lhf/DRzddGSJi7r1WPrVBT9uT8ygfUeaXNHQt/MM8olh0/PZcCxFKviOvdSVBl3Q1f6TZrSs4UxRfhyywMEIEsvIkUgWvy6ztE19Q8kN2MvL+Xsubex+D2xt1F7CI5dP+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983002; c=relaxed/simple;
	bh=JEAJlxfhGRp9PPCMKrJw4HSb2ShxFoxF7k3pzV9Wlaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT/TXps6mDfjIhpSOhy+7kNJ6LGUQ+Q/k69sMBeIKXn72yoY+RlNn/KafW+fVJdmRZgsH7jPsjDxcgiAhKUd499ZaIuwtgiHO2dzvleUXEVMatem2Hm4D52Z/t3+MTADd83jp67Jy6/007VnX91rLoPMzhP+pQINn5wrtDRn3u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIEQPTER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIEQPTER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D24C19423;
	Wed, 25 Feb 2026 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983002;
	bh=JEAJlxfhGRp9PPCMKrJw4HSb2ShxFoxF7k3pzV9Wlaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIEQPTERDBvduspAnfhmxl5xylLx/eUcYtaaj5OejFu/g05A3YeaDlch14diL5BYT
	 UGnLS9isIhQigiEh2qvYxRVZbbA21papqPndhv5MDiSekMhJkqTidB8kk/+1tLfxNC
	 cfuDeFYE1iWt5CUqB3NSYMdMZ5ZFHXuZbvbxw9U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 173/781] soc: qcom: ubwc: add missing include
Date: Tue, 24 Feb 2026 17:14:42 -0800
Message-ID: <20260225012403.891658650@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit ccef4b2703ff5b0de0b1bda30a0de3026d52eb19 ]

The header has a function which calls pr_err(). Don't require users of
the header to include <linux/printk.h> and include it here.

Fixes: 87cfc79dcd60 ("drm/msm/a6xx: Resolve the meaning of UBWC_MODE")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20260110-iris-ubwc-v1-1-dd70494dcd7b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/qcom/ubwc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/soc/qcom/ubwc.h b/include/linux/soc/qcom/ubwc.h
index 0a4edfe3d96d4..f052e241736c4 100644
--- a/include/linux/soc/qcom/ubwc.h
+++ b/include/linux/soc/qcom/ubwc.h
@@ -8,6 +8,7 @@
 #define __QCOM_UBWC_H__
 
 #include <linux/bits.h>
+#include <linux/printk.h>
 #include <linux/types.h>
 
 struct qcom_ubwc_cfg_data {
-- 
2.51.0



