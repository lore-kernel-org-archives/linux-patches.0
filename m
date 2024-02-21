Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F2262BD;
	Wed, 21 Feb 2024 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525810; cv=none; b=kXUKyw0MCozcUGfFA2lsazaLrUoXGJf3lYMqllOTbuaGTeJGXZsVHq/Lazx1tbg40yDWlBIeqgvMklsxhpdV9ju6VjOdBN/fJaGqqOFqx0mK2oj34StrMJj1O9h/vybFEAwL1MrSmxyZHF6eooGCsZYor9xo6bISV0IyzRl08zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525810; c=relaxed/simple;
	bh=e/ZDjOzqyXtDEuAY1yD6iJfELrAfHJ5VyGmq8YKuoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKthRiLmGxQcOEnnuDaT2uWVMQuLf1sQSE6hi9RGLylFehi4YBKOeYVESM+IQKyOK2VHN+98eAqtqD0hCLwsb/LYERaTs/ycuX5sDdL8KMTqvt3JNKmy/YeLZmiWfHR8SnmUF/vo5WK2Cd8C+T90xJWrn8LxOKsNQVw0yvkLopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnV7b6YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnV7b6YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D8AC433F1;
	Wed, 21 Feb 2024 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525810;
	bh=e/ZDjOzqyXtDEuAY1yD6iJfELrAfHJ5VyGmq8YKuoXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnV7b6YO9txhm/e2Da/tSKio2yQd8nPfrIxg02zqP3arE1eRPt2lTo8QFxxHxtTih
	 83Pg+acPspVwz2LPpR74jVFdhqAvNV5kEU4jaN/1Yh0MlRiifkD64Xn/bcFENALj1p
	 6zKaiYioQgV+wqrjxeSoXWcZBSE07Dgv7pIu0A7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 261/267] drm/msm/dsi: Enable runtime PM
Date: Wed, 21 Feb 2024 14:10:02 +0100
Message-ID: <20240221125948.439173551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 6ab502bc1cf3147ea1d8540d04b83a7a4cb6d1f1 ]

Some devices power the DSI PHY/PLL through a power rail that we model
as a GENPD. Enable runtime PM to make it suspendable.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/543352/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-2-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 3d07a411b4fa ("drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -606,6 +606,10 @@ static int dsi_phy_driver_probe(struct p
 			goto fail;
 	}
 
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
+
 	/* PLL init will call into clk_register which requires
 	 * register access, so we need to enable power and ahb clock.
 	 */


