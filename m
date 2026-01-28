Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F6C2F6183;
	Wed, 28 Jan 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615708; cv=none; b=qQ6z8eJZYw/KDbid54oRnMJUsk3vBntQ+4+ucK0e1/bOtzKQDIgpdH8Gx/xW7bWBtquWL/Vb/UFk4DG5889AHrUI0+sqzF8ylbiipzi2pqVB2YcPYJhpAtIz3jeSOFKPemZsXDTyFWSy6p38zvGS7YVtJ+DORKJMkjAt26ukfg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615708; c=relaxed/simple;
	bh=6v6FCpZsmfjzGMIaqJQti9/l6UuFmWl8rn5gSNsHikQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8CHQAr2lszyQuedabmMHuh4/jJOSe0jIZAK/WXjmEKkGEHOz1ejOi9WmRsh9rI4XkJZX89w8e429DOYnixuiGTPZWT8szZtsqjPAnmENTKwo44E10Ai/0u2n2ool2jf394T61VKlXhGMtUf8ciw4r7GHecm+nGpgnupuuRnvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS2PCDbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS2PCDbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2631C4CEF1;
	Wed, 28 Jan 2026 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615708;
	bh=6v6FCpZsmfjzGMIaqJQti9/l6UuFmWl8rn5gSNsHikQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pS2PCDbJBw3Zjc+XTwPwvAwKuIxHfhtYYzSumJzkB17A4TbzaOaDiT5tzBeExijQX
	 KUAkUsbNDFGWa0ZCcC1ZLA9cDuPYNjNtWTeiawbs3OdUGc4ncPlwClN/+7DzItoO5K
	 Htabawkrr5Pn3OGYkBFWenfKp+Cbgwb2WCkdsH0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Shamray <oleksandrs@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/227] platform/mellanox: Fix SN5640/SN5610 LED platform data
Date: Wed, 28 Jan 2026 16:22:15 +0100
Message-ID: <20260128145347.574185257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Shamray <oleksandrs@nvidia.com>

[ Upstream commit 3113bcf4ccf06c938f0bc0c34cf6efe03278badc ]

In SN5640/SN5610 platforms should be used XDR style LED data with
predefined slot index per led_fan.

Fixes: 317bbe169c46 ("platform: mellanox: mlx-platform: Add support for new Nvidia system")

Signed-off-by: Oleksandr Shamray <oleksandrs@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://patch.msgid.link/20260107142548.916556-1-oleksandrs@nvidia.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlx-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlx-platform.c b/drivers/platform/mellanox/mlx-platform.c
index d0df18be93c76..efd0c074ad937 100644
--- a/drivers/platform/mellanox/mlx-platform.c
+++ b/drivers/platform/mellanox/mlx-platform.c
@@ -7381,7 +7381,7 @@ static int __init mlxplat_dmi_ng400_hi171_matched(const struct dmi_system_id *dm
 	mlxplat_hotplug = &mlxplat_mlxcpld_ng800_hi171_data;
 	mlxplat_hotplug->deferred_nr =
 		mlxplat_msn21xx_channels[MLXPLAT_CPLD_GRP_CHNL_NUM - 1];
-	mlxplat_led = &mlxplat_default_ng_led_data;
+	mlxplat_led = &mlxplat_xdr_led_data;
 	mlxplat_regs_io = &mlxplat_default_ng_regs_io_data;
 	mlxplat_fan = &mlxplat_xdr_fan_data;
 
-- 
2.51.0



