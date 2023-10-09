Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8141A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6LcSddq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9309C433C8;
	Mon,  9 Oct 2023 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859465;
	bh=QygJcezbkjTas+NAybnzyQVp9qE6t9DEzdpU4z/To9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6LcSddqppQVmxZzA/HyoekAJZHN4VQJHjklkmZKNAg8DSMRHjfon2vBnle//IZ4I
	 mHGALjODxVS38TD9drULMllmK9dh+7aGToAvhLpTQ6zJtie6mCygyo6LLCm/Q02eMQ
	 XBXQ+nJ57XbiaR7I+829u6A2FhdqEKgu5n16maXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timo Alho <talho@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/91] clk: tegra: fix error return case for recalc_rate
Date: Mon,  9 Oct 2023 15:06:01 +0200
Message-ID: <20231009130112.534239702@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timo Alho <talho@nvidia.com>

[ Upstream commit a47b44fbb13f5e7a981b4515dcddc93a321ae89c ]

tegra-bpmp clocks driver makes implicit conversion of signed error
code to unsigned value in recalc_rate operation. The behavior for
recalc_rate, according to it's specification, should be that "If the
driver cannot figure out a rate for this clock, it must return 0."

Fixes: ca6f2796eef7 ("clk: tegra: Add BPMP clock driver")
Signed-off-by: Timo Alho <talho@nvidia.com>
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://lore.kernel.org/r/20230912112951.2330497-1-cyndis@kapsi.fi
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-bpmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index 01dada561c10c..3bdd3334b0f94 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -162,7 +162,7 @@ static unsigned long tegra_bpmp_clk_recalc_rate(struct clk_hw *hw,
 
 	err = tegra_bpmp_clk_transfer(clk->bpmp, &msg);
 	if (err < 0)
-		return err;
+		return 0;
 
 	return response.rate;
 }
-- 
2.40.1



