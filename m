Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08815DF01;
	Tue, 23 Jan 2024 01:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974415; cv=none; b=nQtDex3JaXv8CrHRa6MefDcSrrIjEyNOq9Ca8JollioUC07dHCpln0QL6ILxGGd0P920z6FB42XDgETU/cCDNoJpIsXk2RLFe0k075J2t3ZLZvQjuYp+hEeZMaHlKen6I523CBsA0guHC/mwcrSzZibBHkrbAeaKcmxggZLZ0FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974415; c=relaxed/simple;
	bh=j39wvLsL7XSAANaYI+4ILaVvLPFKuSuNYgZsTB0Up+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk4VTin6GYN4SiOwlue4oTrP0rvCX12csDYq7LArpcbJQuCS+ak0+534QSuw+iFcwczgtMaPAeLYin/yqQfuHL+foKpJWTA841HeFuSi24mUBENFk3yV5Ia5RmtrRHdP2h5/6IyyqGn8dbc2vJGCOixrhKLBpQEDBIkq8HFs7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKN0LxnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKN0LxnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95604C433F1;
	Tue, 23 Jan 2024 01:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974415;
	bh=j39wvLsL7XSAANaYI+4ILaVvLPFKuSuNYgZsTB0Up+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKN0LxnNuKv/opblHIlWtPi/d40+OCXF5cugc/fxEgXskNqjgfEE6+L9f/A64iJpT
	 HNwXi5g7/tOj3nSgAQjn83SSwUySKIHdMZu2o6zOHzpiOwMjCY8R8nrHGDdHXJGXlZ
	 yJDAKKmycYgmi6fWsMdvFhUh+lqqgmbcsdA04ToA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Michal Simek <michal.simek@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/374] clk: zynqmp: Add a check for NULL pointer
Date: Mon, 22 Jan 2024 15:57:53 -0800
Message-ID: <20240122235752.204829520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit 6ab9810cfe6c8f3d8b8750c827d7870abd3751b9 ]

Add a NULL pointer check as clk_hw_get_parent can return NULL.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20220518055314.2486-1-shubhrajyoti.datta@xilinx.com
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 1fe15be1fb61 ("drivers: clk: zynqmp: update divider round rate logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index 9e535d3e1c0c..47a199346ddf 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -120,10 +120,13 @@ static void zynqmp_get_divider2_val(struct clk_hw *hw,
 	long error = LONG_MAX;
 	unsigned long div1_prate;
 	struct clk_hw *div1_parent_hw;
+	struct zynqmp_clk_divider *pdivider;
 	struct clk_hw *div2_parent_hw = clk_hw_get_parent(hw);
-	struct zynqmp_clk_divider *pdivider =
-				to_zynqmp_clk_divider(div2_parent_hw);
 
+	if (!div2_parent_hw)
+		return;
+
+	pdivider = to_zynqmp_clk_divider(div2_parent_hw);
 	if (!pdivider)
 		return;
 
-- 
2.43.0



