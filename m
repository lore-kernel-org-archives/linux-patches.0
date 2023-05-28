Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FF8611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916E9C433D2;
	Sun, 28 May 2023 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301407;
	bh=BR4psieaLe5m1WiFLrB14WfFWXXRVLIaoIjw3D6ekk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbDJSY2dCo8xJqJtRvrdxbfw18Z6segT01UQ9IqIXadYjzJHBdCMcfFjBXKKIbugY
	 NjgDYOQzzvJc3Oy8Bkha2fbh0CvK9Gusxta58bRTdW04VKjGNhcaKEykA1xwkw+cmP
	 97aKbvv3GquZ0mQmWayi+PBuxWLeRHa5zdsOMDxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nur Hussein <hussein@unixcat.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/132] drm/tegra: Avoid potential 32-bit integer overflow
Date: Sun, 28 May 2023 20:09:17 +0100
Message-Id: <20230528190834.128009692@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
index 83108e2430501..adc191ec26a99 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -829,7 +829,7 @@ static int tegra_sor_compute_config(struct tegra_sor *sor,
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



