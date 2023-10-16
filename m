Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395B1798F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDVssqgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1546FC433C8;
	Mon, 16 Oct 2023 08:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446683;
	bh=MnkTaBb/QNk2x7zaIxNlBYj3Tr/qX8zCz29Oyr25hRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDVssqgGHRUkl2VCMenhpNqx8CB0XIXx+FBDi83co5SbbPaDe8Ze0akHrMTMqP8aL
	 NuGbKaVVHId66ZttVtEzqfEwSKLqnckkNCOiy30wJMXG833Ks6uTmpA816+BORrX/D
	 I7N/yuavjvTUQxHa7avq6CVQPqiHbYX14CKimPBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/131] drm/msm/dp: Add newlines to debug printks
Date: Mon, 16 Oct 2023 10:40:21 +0200
Message-ID: <20231016084001.017295443@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit eba8c99a0fc45da1c8d5b5f5bd1dc2e79229a767 ]

These debug printks are missing newlines, causing drm debug logs to be
hard to read. Add newlines so that the messages are on their own line.

Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Fixes: 601f0479c583 ("drm/msm/dp: add logs across DP driver for ease of debugging")
Fixes: cd779808cccd ("drm/msm/dp: Add basic PSR support for eDP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/554533/
Link: https://lore.kernel.org/r/20230825230109.2264345-1-swboyd@chromium.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 36bb6191d2f03..cb66d1126ea96 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -1068,7 +1068,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 		}
 	}
 
-	drm_dbg_dp(link->drm_dev, "sink request=%#x",
+	drm_dbg_dp(link->drm_dev, "sink request=%#x\n",
 				dp_link->sink_request);
 	return ret;
 }
-- 
2.40.1



