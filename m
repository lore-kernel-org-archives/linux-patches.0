Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5EC1519AA;
	Wed,  5 Feb 2025 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763737; cv=none; b=EDGKBjpel469Zov++ZSLaeNVZ5YB2KqucLbIejY9Ug3rT+1L4qwwIDLNO0TbwDyUaxGKDFmV0yVk6w2x/cQHv8IA2TVFcinZXqI/9i/Q51DqOybnZ3bEormpiKP+vTvw9RbfI7wJGziwi56GlyVV2jk6rIyZy9ahbHnYAWizYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763737; c=relaxed/simple;
	bh=9M0i7zQaLJ4BEp7Qs4PUE/qxnawlLiCHX4eTDP9TV8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNv+QvleAEu5xJUkbYDWCmHps4nySP6/W4+EA1/7K4SWmikUhPDRcTeozstA69XksAD6T0DWjWok8cXWjEZLF+C37OU4a9i+QILZ4fjmJKCrCPyVM0itTe3nMlHrwhC74flS8HEZK2k5ZsB+4hHGsJNZ8HRUZdWPu26Yw62qVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nq1U7Rdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nq1U7Rdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449FFC4CEE2;
	Wed,  5 Feb 2025 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763737;
	bh=9M0i7zQaLJ4BEp7Qs4PUE/qxnawlLiCHX4eTDP9TV8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nq1U7RduxzYN7ErEKPPQTQGFGJRVVN+zZo8W2fYa9Om4iUWUXvpvwVkzU9/FnsS7+
	 YBw/+1XojXI/Tz5EHDpNJnJkqmPJ6nIfrhFRmcTRBO8dXAwjGZoItj3JCCM5/uZFYm
	 1CYdeqq2HW6lMZSvTbc5O2agTbLPZW9SFgZUCJpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Nie <rex.nie@jaguarmicro.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/590] drm/msm/hdmi: simplify code in pll_get_integloop_gain
Date: Wed,  5 Feb 2025 14:36:34 +0100
Message-ID: <20250205134456.746851981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rex Nie <rex.nie@jaguarmicro.com>

[ Upstream commit c1beb6f75d5e60e4e57a837c665a52eb79eb19ba ]

In pll_get_integloop_gain(), digclk_divsel=1 or 2, base=63 or 196ULL,
so the base may be 63, 126, 196, 392. The condition base <= 2046
always true.

Fixes: caedbf17c48d ("drm/msm: add msm8998 hdmi phy/pll support")
Signed-off-by: Rex Nie <rex.nie@jaguarmicro.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/624153/
Link: https://lore.kernel.org/r/20241112074101.2206-1-rex.nie@jaguarmicro.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
index e6ffaf92d26d3..1c4211cfa2a47 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
@@ -137,7 +137,7 @@ static inline u32 pll_get_integloop_gain(u64 frac_start, u64 bclk, u32 ref_clk,
 
 	base <<= (digclk_divsel == 2 ? 1 : 0);
 
-	return (base <= 2046 ? base : 2046);
+	return base;
 }
 
 static inline u32 pll_get_pll_cmp(u64 fdata, unsigned long ref_clk)
-- 
2.39.5



