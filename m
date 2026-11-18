Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051256;
	b=lJ/+lbQ+B1JRm28wHUkRmdwV02+T+nEcRHrmqYNV1nr4Ve0zCnNPh3kPkb0jTiYiHhl7
	 uEu6fmMJ75ejceFwqFSeZNPfa5LkV3YSAB/Q3oEQDVkH+t0C53cVVMZZ094n5TGhLguga
	 qrNxOY8Qw2ewwtBHZDGkgr2lkGpDpoPQDXXiKocpa8blcC0Z3Bz9SzHSmJSs7pZ7ArUwj
	 bhJR4KdxmCq7YC9NyhIn6IguWuL6603+jgApHOLZxLv6jBoUkTWfZsnL1sjS+CSCYbuON
	 C/dfRUn+Pd3qtOKt6zMubJrVHJreX2jrxsBBJ5xyNW4TIvXsnHf3C1vhI/NMO+1XRRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6hjot0zxgXkmfdF29nusqROSUbBYVf2fcVYWAIFhfDg=;
	b=XEvspNu88uc9j5JHehVIyDL7BLADjqaDp4vKrvFdkdRkGZDesHxAuGyHHlRXxfWpi6AK
	 mpmLJxss7WkVbG2toYkmnyiK+Qt2muOqmOVQFK9f9L5qb5DYhyksuoLrbU4KTLD4WUuUf
	 PUm3UfM+DKt0Tx1XToN7epGxogj5iQqermIPTh13wYDG970wLsVNels4LIXgIlFAr+/s8
	 78IyuID1wknZMjaC6yREgDpSO4COH26YWGYH1DdTjy7MW703e80UfVOzoJbjJ4cEbVlYm
	 AB1bcQpfFcT8ma/GMfgsCqQIFD5+BuDBmSc213uvRVWCVh4psi9O72W+8WW+26NAvMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h09ELMJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC75606A31C;
	Thu, 19 Nov 2026 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h09ELMJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E9D1F000C5;
	Thu, 19 Nov 2026 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051255;
	bh=6hjot0zxgXkmfdF29nusqROSUbBYVf2fcVYWAIFhfDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h09ELMJdNFU9KN4PpyNX7WNp/7IBlMJu4nzsEIV44TyuHHqz2Y5BBt7XtladmpWcc
	 pOTckOQyR6XdIaLue/mUojGIJ/79UPd60+uBSE1nKfuKUVx1MmZ3cYsUvBOGujiCIY
	 cnHxuVbpiZNLunF24Zqi8nbw03tIwDQfzU+X5bVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0145/2214] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:30:21 +0100
Message-ID: <20261118150015.966404369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e89485455ac49925565061733c0d73d568333fc0 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260704150344.59563-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index 5e31a6a24b3a3..a1569ddca7bd8 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -359,6 +359,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



