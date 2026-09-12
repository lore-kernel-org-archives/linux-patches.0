Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159C282F1B;
	Sat, 12 Sep 2026 07:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199034; cv=none; b=MwV6Finsd+sjtJWAQ+EnsFze1Ssz7glkdiB6Vs4QFOqBsMe7ItlVdsAqtnAK7+cWqy/wtdS8odUC9Sirf5o7AXOqRc4tTCTOQOO2YU6zoaI4BkuNexbSt/gTvrW9L4FfZjHiyjMIj/8fpA9LHwAEzcq2VcnOc69dLPRTonrTW1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199034; c=relaxed/simple;
	bh=gC5oAW8gOTYMW8PzAsNT7Yq4PsAYvbzV5b8JgKL0ih8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCaIyIck/AhrsfrBZmxy7AhbXhe5/isO3/lviXhoU/Xj9CFe9sPxbUW3nqJc/3ATHP6uHH55sC9JEsgk5WWve5e72KlcJXZoLYH6TyqBTSOVELXMSiyU2UQIN9kNWpQmzUuN56/F4YuzNOlhmiiGSxJ5YAPa84fBhpKWQw0264Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGcpt/p5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGcpt/p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6631F000FF;
	Sat, 12 Sep 2026 07:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199033;
	bh=i14WseWpTCC29WBk2HtmJCl5HsggNrWwbIwAo4EW7kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGcpt/p5wF2x446pckEtLQ0jExh8agmYCnpbQQ3i/QPug/6T7ZZtgj8XE4qynDcN1
	 LWfJx1e/BsM+G1ofy7k3ASh0HXF2EsJdOD2JLFbIp+eYGBPQrbov/XAiFuWgrWftr1
	 uqu8T5fK4WiDVt09H4n1xQBAzAu3j6Odi0sO501k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0459/1815] clk: qcom: gcc-glymur: Enable runtime PM
Date: Sat, 12 Sep 2026 08:36:49 +0200
Message-ID: <20260912065659.663513853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 8d4f342369d0d77f32a0211692442d3b6d455872 ]

Enable runtime PM for the controller so the common GCC probe path resumes
the attached domain while registering clocks, resets and GDSCs.

This lets GDSC consumers propagate their votes through the GCC provider to
the CX parent domain.

Fixes: efe504300a17 ("clk: qcom: gcc: Add support for Global Clock Controller")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260715-glymur-fix-gcc-cx-scaling-v3-2-72eb5adad156@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-glymur.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-glymur.c b/drivers/clk/qcom/gcc-glymur.c
index 6925c6865089c..2ee4820b6fdfb 100644
--- a/drivers/clk/qcom/gcc-glymur.c
+++ b/drivers/clk/qcom/gcc-glymur.c
@@ -8548,6 +8548,7 @@ static const struct qcom_cc_desc gcc_glymur_desc = {
 	.num_resets = ARRAY_SIZE(gcc_glymur_resets),
 	.gdscs = gcc_glymur_gdscs,
 	.num_gdscs = ARRAY_SIZE(gcc_glymur_gdscs),
+	.use_rpm = true,
 	.driver_data = &gcc_glymur_driver_data,
 };
 
-- 
2.53.0



