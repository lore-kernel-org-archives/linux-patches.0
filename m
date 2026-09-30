Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E81D374A16;
	Wed, 30 Sep 2026 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787036; cv=none; b=tGt0/RGfU85Bi4+nORvvsFhU6a/IxXF6W8ROps0bIqr8uZ856ZasAhI8brnNglb+2+DICPfHn7INoUa2BTW70zs2O/v+xm/KmE6qu/r4LjJFN2Et+VAfr1idEZJUUHocT/ZO+f7agffEGU7lK0a1lFbAso1GeofKUtC+8LBVN88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787036; c=relaxed/simple;
	bh=aiwvTkW/LVbnS+sYBcrCdMOK+g6lXMwnwtVcofoZp4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9lsQkd6y1U8UZRh68pS6Qn+pHZ4W1JCY5XFrY1D8dEmwJyLOlwP7iHDI0UEw9zfGpvnLl8gIg/l9dmYYCp1GPRAoBLZGL8Dan/wZABnlpPVkKc6C00iHgX3hZoEk3nRL2pmH4EnWoq80NXEcKDFQadMrBxPI+0n0jcxt2uJFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgN81hn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgN81hn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F0F1F000FF;
	Wed, 30 Sep 2026 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787035;
	bh=KmeJeXGGzXREP//y+NUuBa2vB9ckucQ0vPHr+axwO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgN81hn5pRMYmQcf9c+BWmy7amLJCeKqNX1K3dxbK7QRDb3DBVqobTf/tIGmuk1Ek
	 8cyVzLyBcE32KskL0EaJFlZ391qo883yTAVXv+uXWKe8swdphgS7zd2D8Ga3odiGzj
	 TSctSHe07UlzOqUIBGJI8KdJPw/PWr4KyhiU0Nbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 088/457] pinctrl: qcom: ipq5210: Publish the OF module alias
Date: Wed, 30 Sep 2026 17:23:13 +0200
Message-ID: <20260930152347.951573764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 447dcff90557748a5ac384aaf5d70b2c7e3b961d ]

The IPQ5210 TLMM platform driver can be a module and matches through
ipq5210_tlmm_of_match. This table is not published for OF modalias
matching.

Publish the existing table, preserving arch_initcall ordering and
the shared MSM pinctrl probe.

Fixes: a549fe22376f ("pinctrl: qcom: Introduce IPQ5210 TLMM driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260905134340.67477-1-hppiscas@163.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq5210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq5210.c b/drivers/pinctrl/qcom/pinctrl-ipq5210.c
index 827a4ad07a6b0..d5b4eb3e73435 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq5210.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq5210.c
@@ -867,6 +867,7 @@ static const struct of_device_id ipq5210_tlmm_of_match[] = {
 	{ .compatible = "qcom,ipq5210-tlmm", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ipq5210_tlmm_of_match);
 
 static int ipq5210_tlmm_probe(struct platform_device *pdev)
 {
-- 
2.53.0



