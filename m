Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD561F7561;
	Tue,  3 Dec 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240324; cv=none; b=GzWvVLcSG/Dlfw9Zqk9bwEVe6NZL2VXAFI9fI2zIQzTWSBsmtNTgfXmxeW1Iojep/fIsZnuDndxgNnQBTwenMrQhoiwuvlHjnPNriVqf5dIkdoi0FoV5s/M7B6rqs4v85OMPTEIp62LErWFmdFJCGyu31bEhnpf9h3QbRoL3vY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240324; c=relaxed/simple;
	bh=qC08bPcE5PTvBpqeQSuK46WZG093RAnEN3qdRSTeJS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJkUoPdUDo0BsHk4+UyJH3CCmyCYs1h/rSDdCWnrOr0GanddvYLTvI7EEJ1oMoyXN06KzCfFA2/hIAToYxQ6x8JoodSqaIPHzrdR3wH1molMFwNZ3Q3SDkbOTGVp/u73sxLXOiZ0sI/EDJNNFU4QfGA+5XPBPJtKg6YwC03OHa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeXKwyaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeXKwyaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EC1C4CECF;
	Tue,  3 Dec 2024 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240324;
	bh=qC08bPcE5PTvBpqeQSuK46WZG093RAnEN3qdRSTeJS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeXKwyafuQrV4OL5eKSDRjQ8Be6wmsiu0NCrOaclR5djh8BcFYBhiMiN2NhhpzA8C
	 VqpDGp3TZzUIK1WppqQ3BXecq4Py1iUj6ak4PS/ju3GWw1rRWSrkIank2e5GmRj9kS
	 BYI61Nj+MPmWxH8L9Gn022MEDtxLlihYAV5pls+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/826] regulator: qcom-smd: make smd_vreg_rpm static
Date: Tue,  3 Dec 2024 15:37:06 +0100
Message-ID: <20241203144747.594340456@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 18be43aca2c0ec475037923a8086d0a29fcc9d16 ]

Since smd_vreg_rpm is used only in
drivers/regulator/qcom_smd-regulator.c, make it static and fix the
following sparse warning:

drivers/regulator/qcom_smd-regulator.c:14:21: sparse: warning:
symbol 'smd_vreg_rpm' was not declared. Should it be static?

No functional changes intended.

Fixes: 5df3b41bd6b5 ("regulator: qcom_smd: Keep one rpm handle for all vregs")
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240926231038.31916-1-minhuadotchen@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_smd-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index 28e7ce60cb617..25ed9f713974b 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -11,7 +11,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/soc/qcom/smd-rpm.h>
 
-struct qcom_smd_rpm *smd_vreg_rpm;
+static struct qcom_smd_rpm *smd_vreg_rpm;
 
 struct qcom_rpm_reg {
 	struct device *dev;
-- 
2.43.0



