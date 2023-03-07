Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6688BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D945C433EF;
	Tue,  7 Mar 2023 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209967;
	bh=2SFXI/hh4a8eHKzq6wiy37/kjG64JrGbKyCDe0SeGYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO9XS7GkBcSNCiub6ky8P0G3PMHoDcS8Q/Do3CMPGzy524hEVjvHJ9d4yFkrJ4O+J
	 xby2swRZbxBfFrDovlntVf5agN3MIAujefIZoGcsnkptDAjrjmV9sQYAHCPCUQaL6E
	 85ITEbcaSnbVsV+6k+kC0tuZ4M5DBoOU00Lw1XNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0388/1001] drm/tegra: firewall: Check for is_addr_reg existence in IMM check
Date: Tue,  7 Mar 2023 17:52:40 +0100
Message-Id: <20230307170038.206625185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



