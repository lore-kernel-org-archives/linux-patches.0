Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A79BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E145CC433D2;
	Tue,  7 Mar 2023 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215286;
	bh=2SFXI/hh4a8eHKzq6wiy37/kjG64JrGbKyCDe0SeGYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXBI0M1+LOUFN5zsheauA7JPeFPTah9ia7Bj2EAmw73PAJv4+C06GBufJWrAA5XlO
	 K3Ira/qlCrzIA0PkhtfhsEmZBdnt6EenS9PmOxq+bBi0MOiFJpPokhIcPxipXC0juX
	 /a4Ymn/gTCEBF6H00/jjlYUFsInRaLr4KmhtPwxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/567] drm/tegra: firewall: Check for is_addr_reg existence in IMM check
Date: Tue,  7 Mar 2023 17:59:07 +0100
Message-Id: <20230307165915.039278286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 1b5c09de25e8c08655c270a70e5e74e93b6bad1f ]

In the IMM opcode check, don't call is_addr_reg if it's not set.

Fixes: 8cc95f3fd35e ("drm/tegra: Add job firewall")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/firewall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tegra/firewall.c b/drivers/gpu/drm/tegra/firewall.c
index 1824d2db0e2ce..d53f890fa6893 100644
--- a/drivers/gpu/drm/tegra/firewall.c
+++ b/drivers/gpu/drm/tegra/firewall.c
@@ -97,6 +97,9 @@ static int fw_check_regs_imm(struct tegra_drm_firewall *fw, u32 offset)
 {
 	bool is_addr;
 
+	if (!fw->client->ops->is_addr_reg)
+		return 0;
+
 	is_addr = fw->client->ops->is_addr_reg(fw->client->base.dev, fw->class,
 					       offset);
 	if (is_addr)
-- 
2.39.2



