Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048989;
	b=3N+B+4X5hSL+tltl0l4T6ab8Gc23xc+p31cFq+ql7nAkjCdzdNNRnhaeFuz+lqWOqGLi
	 LQplTVxIZBD8FajPFZlXtsz9OlFA3lbefZLoNnhFNxXjgYjhVXiwPmXO/uzOMjXpHr6xl
	 GpF4H7x8HzNIOkMO5pnnC+Zp/xXreUoeg5yC+bdr5PR/QAR5idlc+QK/XHJq+lnPUv6Tb
	 +uxSKrsvUXKcrZIQdghMmCRMRpD4Bl5NKFUoWOyK+B9doDB7TG6chT45+M3N22eu2Fvx1
	 srQWgpiX7M6A0ywnODb1kApZF6vCqEMP2w4KcCCtwxWGD6zU4UCHqEUUAtGnx/gAAhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9RiZu3Kp0MlfGHvp0B23um/6yUniPC93VK+3dOYxpY=;
	b=GIVypNELFKBIRBVkT3bu3kOGcflH9/HfuawMV5kPHBif0emrW+LMu7vCzDIvlZywXlbd
	 krU3eluaNk5AowbSLMKWhXjudDXL38qB642n6fWz+TqyJLVcuMRYrWcExztbUjeUSqJM7
	 uFswBUVwD/SZL1FSenEiQWVn+0jmxTYT3qAn/klHvUJ0KYwbf3EHMMpk6uOBZpkbJGqqi
	 aXLKxNgPGHXYMJyhNv/zkWnhYDlRGSrXtY1D7cBrYV+TmL+FF/Vuu2jZCvPgFmDaA9usk
	 5dEteo8Ri2X8Mg5wflEBYYJBOeIScrw9OE5sc4O2XHj+X1r3D5Fz/z2xEgAEd043OkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDF7DeLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AC9606A31C;
	Thu, 19 Nov 2026 00:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDF7DeLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6937C1F000C4;
	Thu, 19 Nov 2026 00:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048988;
	bh=i9RiZu3Kp0MlfGHvp0B23um/6yUniPC93VK+3dOYxpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDF7DeLApavPkrB4Jnvz0lGmgMFLxtk1d8wQHpfyVd8oGtJfVOqdeQPD+z0sBLpAb
	 WL3rIO+gGvrYCKZvWSvTYtwBC5umEamkakKQAsLbZfKrQuqzigP1EGvbMr6877nI/U
	 ACmSPSf7XyCRCZhZHkMuBaI9jT0AEYVh9EKsGRjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2184/2857] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:53:38 +0100
Message-ID: <20261118150320.040799689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4eaed7ea6ab36e1160d660b05551702c36dfed6c ]

tegra_flowctrl_init() obtains a reference from
of_find_matching_node() and currently releases it only after
of_address_to_resource() succeeds.

Release the reference before checking the resource conversion result so
the error path is balanced as well.

Fixes: 1fd09e5d884a ("soc/tegra: Add initial flowctrl support for Tegra132/210")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/flowctrl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/flowctrl.c b/drivers/soc/tegra/flowctrl.c
index 5db919d96aba5..727b92e938311 100644
--- a/drivers/soc/tegra/flowctrl.c
+++ b/drivers/soc/tegra/flowctrl.c
@@ -197,11 +197,14 @@ static int __init tegra_flowctrl_init(void)
 
 	np = of_find_matching_node(NULL, tegra_flowctrl_match);
 	if (np) {
-		if (of_address_to_resource(np, 0, &res) < 0) {
+		int err = of_address_to_resource(np, 0, &res);
+
+		of_node_put(np);
+
+		if (err < 0) {
 			pr_err("failed to get flowctrl register\n");
 			return -ENXIO;
 		}
-		of_node_put(np);
 	} else if (IS_ENABLED(CONFIG_ARM)) {
 		/*
 		 * Hardcoded fallback for 32-bit Tegra
-- 
2.53.0



