Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212721;
	b=Bu7VROxKocINUox/RTRkCKIWXfRev7hvKo1kUdkE6FFqQWKHrFkOTeaIu/S4Iufl+ljl
	 jY8/XoNuCvnmMNBRPwvhwE1Qep+rOxWwBt146BdjussrfM3C6ZkTOPBWLXE00p4cPO69m
	 7SEwiOmj9NDzGAASxNpTbt3H/QWbSqMSRuXhhWpWkD9t9a7ORvRnMWltVNAvadpLuPyZy
	 fU4Xuo4sHYAewKy1P7+x4I3ZZcX/K9jNHwS5Kg/sOrG/SMS+VLtRr5ifZCHZbsoaP1RC9
	 XeL+TlsYir2o3U8No78geBtZSKobM3yaLrcuJAqVpbviXCmzTVajQVw551qXztiQblA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8w3Wx44zsaFtIORIHh8hupNF63JdysQc0Ghv/hUXfg=;
	b=emBt6mUdMRxZ8RxA+ampxTwDHrA2aUJZiwvNGX33ke4WhkJ/R/EPsbB0mIzoE070F39o
	 DAw9qpeBjIOn0wax1tYYDNO3ftx6/hGz7LGvWg9cQDqZ7UkMy+t5FgZlvZxR8PlTqU5ly
	 z2wzdS0PMx/C9I9GBqPmhoHzunjZn0aRq1zuLfENsF80sy/z5ZcYFa1T2r1EvCH+3++sn
	 aupefcgIVXJ1MpHx32Wg9Qnb2zsvTPqRIMXKgk2RT7/kdDJlK5sH5272tLwcIu6BptXEa
	 iYbwSOOUA2gwDXOQ4Vi3muwNFIKyq7L4IG9XQA5iZIOIC1NGbr1TNsjVKhbhsE8Q2yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPPwYASq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8D606A326;
	Wed, 28 Oct 2026 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPPwYASq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1F31F01825;
	Wed, 28 Oct 2026 18:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212720;
	bh=w8w3Wx44zsaFtIORIHh8hupNF63JdysQc0Ghv/hUXfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPPwYASqAqq9QV3RPRhPNdxiwNkaPFIN/vxAIPcEvnM7E2PUVI7e3Uog5Fjcb2/8c
	 4/PoUAmOkx//NzQJxe/0KEYIDNB/XQR2oYCfiTOGG83mma/r5Gv/P6JcLZG4uvldbk
	 qX6hi+fPAr3PqgCN94FaPg2zlz1AeYMNch4SVuM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0209/1887] drm/tegra: gr2d/gr3d: Initialize address register map before HOST1X client is registered
Date: Wed, 28 Oct 2026 17:38:25 +0100
Message-ID: <20261028170503.991626133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit c4ef5ba1131346159e31f4ef858525cf377380a6 ]

The host1x_client_register() function is called just prior to register map
initialization loop, making the device available to userspace. This may
result in userspace attempting to submits a job before the register map is
initialized. Address this by moving register initialization before host1x
client registration.

Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260517091450.46728-2-clamor95@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gr2d.c | 8 ++++----
 drivers/gpu/drm/tegra/gr3d.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index e3bb4c99ed39f..9deed8345d76d 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -282,16 +282,16 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* initialize address register map */
+	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
+		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
+
 	err = host1x_client_register(&gr2d->client.base);
 	if (err < 0) {
 		dev_err(dev, "failed to register host1x client: %d\n", err);
 		return err;
 	}
 
-	/* initialize address register map */
-	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
-		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index a1fd3113ea96e..98dc2ed35915d 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -536,6 +536,10 @@ static int gr3d_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	/* initialize address register map */
+	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
+		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
+
 	err = host1x_client_register(&gr3d->client.base);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
@@ -543,10 +547,6 @@ static int gr3d_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	/* initialize address register map */
-	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
-		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
-
 	return 0;
 }
 
-- 
2.53.0



