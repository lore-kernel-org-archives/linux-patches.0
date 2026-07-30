Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB3643F0BE;
	Thu, 30 Jul 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422236; cv=none; b=bBqfvS/T53W+vJNCuStP2A+fEuYSo3hEP9lv+EJDrBekOMw+I4vBnZ75IEmx6fQjOM77OE+7w8NmuRflm7cAq3VEkW192J1vjAJugQNcR678iOXwLtcpaXeKel6SvQN/3hC7ZwKJkmibWUQ44bicivL/Plo8NRVo4e0NX/dN8dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422236; c=relaxed/simple;
	bh=gav4D5emVzQJ9Wkak4M+atAcBfQcT64B9ARYxM0pLa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5ZmvtaYg5ByDpq3PN/r+WI8gPG+Kaa44gGvLZNEsPbfM0Ex+PwXg88QPueQ2gxe/7mDDd7GmZlPwbAS4Ua7GWGrOwqlZfT+MfSRR0wFmtRXqQkicOiJpNaPReesIpj7hfUj6DY/qdvm0OmUsx6chPMFn0CPcZf0OBLmr6fSU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8x7Pxnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8x7Pxnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ADC1F000E9;
	Thu, 30 Jul 2026 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422235;
	bh=EUAjMnBeboot7CxmWuFd4ppziQonYk01Yc5tbMpbcfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8x7PxnmpQfYOdEAMiRFDMo1eG1QJM0Q52e/ifpx4QHkuneyk8ggBulzgcogK50X3
	 Ws1o0aZz92ZvSoI+UHBBlDHRM2ndiYPUhrcCzWA2p2vJd9Iw2l5eK6VOzedv97xVXN
	 ibx49LfUjrhb1IbpfIQbhMS7O5mzGTW3/K+Q3r3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.1 363/744] drm/rockchip: analogix_dp: Add missing error check for platform_get_resource()
Date: Thu, 30 Jul 2026 16:10:36 +0200
Message-ID: <20260730141452.001114053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 45895f4d4d5f222d07412f90664f88b059627859 upstream.

Add missing error check for platform_get_resource() return value to
prevent NULL pointer dereference when memory resource is not available.

Fixes: 718b3bb9c0ab ("drm/rockchip: analogix_dp: Expand device data to support multiple edp display")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260209033123.1089370-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -461,6 +461,8 @@ static int rockchip_dp_probe(struct plat
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	i = 0;
 	while (dp_data[i].reg) {


