Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245914052DC;
	Thu, 30 Jul 2026 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424233; cv=none; b=YBYjmV5B9WqwDXdiqQzhXLRpG8rqyeD6Z3exzyqfqsFjZ7Y/eNQhkFsBqT37+t8eis4Lf3G/+lwjJR4r+IwpJ1P7M1KTrnUtsVaINhy8W84AS0cxZJbLj7ZOH7zJN/qsI8Mf23J61EaR1Ip7Yn6qqnVAmKUb8VTFlTHX77F1VMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424233; c=relaxed/simple;
	bh=aJAiVCpzcD2mfvv1uMDfJXraY8hIB0TGvK0vuwuT4aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7HW7Vmtr4C4M3rDThX5tCNynSZphEOE+y9EeuEMA14NyTcih/bJybhID2cLYJep4ln5E2RGTTABOxME2IetbpvlZEPFMEA91UVC3aRtWep5XI2av3xMIyw6XWxs9YuRgzW7+f0BkvcAgBo2eUTQvd0QkBxOGbe9+4rAlSdxaR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFjKGJw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFjKGJw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77F71F00A3A;
	Thu, 30 Jul 2026 15:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424230;
	bh=nxBk1tir+o3vo/b7fVWtV9dxFVwF9JPVeQN0HMpC5V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFjKGJw6KjTp8ffs1dX0UdRgZLqb5Bp5FgA/eVXYv2fbqdszikO2Hv9yn7A5RC46+
	 qwLA08n0w2uHUFO+vdQMbIpw8ucDZMpcNsvqTc7I84TJL2p7DZBoeizKmPuJg/B8LZ
	 8NXbUPLrGPAZOyHtpb92xyMpjhbFX97M/BgX3Tgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 322/675] drm/rockchip: analogix_dp: Add missing error check for platform_get_resource()
Date: Thu, 30 Jul 2026 16:10:52 +0200
Message-ID: <20260730141451.969566502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,6 +469,8 @@ static int rockchip_dp_probe(struct plat
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	i = 0;
 	while (dp_data[i].reg) {


