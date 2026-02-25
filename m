Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385D25A655;
	Wed, 25 Feb 2026 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983878; cv=none; b=fjwn4gR/W5Y9IessK2xhAW/72sYuKzrJpqz8j7hPckSvPE+AQlMtBaeM8iivfxIODjjYlNL7tqXkjVraFGreStqAKR5lhW6BfoUnCSalA7tJuU+p7sW/URS1olWD3na7bKvsn/Nl5qh5UYtzaaXDosamx/PXmdHBvPdZR7heNn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983878; c=relaxed/simple;
	bh=vZGF+P4f6cUt5ZIaRUN/GtlFpTilclWaSzAaaR4z30E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He+u6SaXn1yQyjBmMftTf0ZpePJa5goSjoMMwuKxsKYt2s7oMri588t1E+ueZN1IviaanwSPCZQ/nlwX1FZYwxrstqLK40bM0aX0P3L4wTc0TUxkuVFJyjdiaUbYEUnJnQpL8sCoy9F2KXu8xNymiddm+789yMY31ODwETOP7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qrewv/C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qrewv/C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA51C116D0;
	Wed, 25 Feb 2026 01:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983878;
	bh=vZGF+P4f6cUt5ZIaRUN/GtlFpTilclWaSzAaaR4z30E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qrewv/C7g5Zo8Xw8sluipR0q/W4/kh5LCyKGtmeNy1sB7+YULNU492Kr4zcr5DK6s
	 sBSX8M8UTvp199uBYD3TY2zx9zl7fGuuMBoxfxsXhiIRWU9HrgAKQziLuic5PRJwLQ
	 SpSjudVdWPi185b+jxHZlRGSDyZO9uXJdmOXn7ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/641] soc: qcom: ubwc: add missing include
Date: Tue, 24 Feb 2026 17:17:59 -0800
Message-ID: <20260225012352.796730030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 1ed8b1b16bc90..d9dfc9edc1b2f 100644
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



