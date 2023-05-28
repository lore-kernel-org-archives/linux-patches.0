Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F57611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076FEC433D2;
	Sun, 28 May 2023 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301749;
	bh=yipB3oG9ljdWOvL43OW9E5E3JcaudM8pbeZSWeSc0/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2RqU1n2uLIjkp8S27ueDlhy5VgIYQXVEHMXdSZ95sOtwV9B1VF+6SS4xg2BsV+YP
	 xWaolCMVU3jgbCQ736h25OGuDAx/a5hd0JJy6CfkIKhWCy38oxGYJhOh2w3UPsLjYg
	 Rg8uSI/XSN4j3QhAcVLBO9L4rztmo+BFyDadhFJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nur Hussein <hussein@unixcat.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/161] drm/tegra: Avoid potential 32-bit integer overflow
Date: Sun, 28 May 2023 20:09:05 +0100
Message-Id: <20230528190837.826569246@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nur Hussein <hussein@unixcat.org>

[ Upstream commit 2429b3c529da29d4277d519bd66d034842dcd70c ]

In tegra_sor_compute_config(), the 32-bit value mode->clock is
multiplied by 1000, and assigned to the u64 variable pclk. We can avoid
a potential 32-bit integer overflow by casting mode->clock to u64 before
we do the arithmetic and assignment.

Signed-off-by: Nur Hussein <hussein@unixcat.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 0419b6105c8a5..ccd084abc8c94 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -906,7 +906,7 @@ static int tegra_sor_compute_config(struct tegra_sor *sor,
 				    struct drm_dp_link *link)
 {
 	const u64 f = 100000, link_rate = link->rate * 1000;
-	const u64 pclk = mode->clock * 1000;
+	const u64 pclk = (u64)mode->clock * 1000;
 	u64 input, output, watermark, num;
 	struct tegra_sor_params params;
 	u32 num_syms_per_line;
-- 
2.39.2



