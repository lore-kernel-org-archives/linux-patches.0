Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8981863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD68C433D2;
	Wed, 28 Dec 2022 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239203;
	bh=ODsTsYmcglnQCN6gjPfBgID3WIYJsMRdwFXk/NMbGIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcJwDngBabtXeyx1vUNZZj/CUtCjqWAIkE83al0SeGbsnU9ue/ZQ3Cw6wXVrpecWG
	 /tp0lZ/5aumKJYocL2Om1gp73NbDOUFGP+zCqsLfXjlpJwKQiJh4GXhaTlLjAZO0Of
	 VvNuCQyiW/NAJd1hgrVJv45ALtmD/SNBTOhTjVik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hurley <jahurley@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/731] platform/mellanox: mlxbf-pmc: Fix event typo
Date: Wed, 28 Dec 2022 15:34:07 +0100
Message-Id: <20221228144300.607345401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Hurley <jahurley@nvidia.com>

[ Upstream commit b0b698b80c56b0712f0d4346d51bf0363ba03068 ]

Had a duplicate event typo, so just fixed the 1 character typo.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: James Hurley <jahurley@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Link: https://lore.kernel.org/r/aadacdbbd3186c55e74ea9456fe011b77938eb6c.1670535330.git.jahurley@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 65b4a819f1bd..c2c9b0d3244c 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -358,7 +358,7 @@ static const struct mlxbf_pmc_events mlxbf_pmc_hnfnet_events[] = {
 	{ 0x32, "DDN_DIAG_W_INGRESS" },
 	{ 0x33, "DDN_DIAG_C_INGRESS" },
 	{ 0x34, "DDN_DIAG_CORE_SENT" },
-	{ 0x35, "NDN_DIAG_S_OUT_OF_CRED" },
+	{ 0x35, "NDN_DIAG_N_OUT_OF_CRED" },
 	{ 0x36, "NDN_DIAG_S_OUT_OF_CRED" },
 	{ 0x37, "NDN_DIAG_E_OUT_OF_CRED" },
 	{ 0x38, "NDN_DIAG_W_OUT_OF_CRED" },
-- 
2.35.1



