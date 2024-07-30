Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF47C1078F;
	Tue, 30 Jul 2024 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358297; cv=none; b=i/AMcL7/XONtJrJyLsMXLzWiwhZGn5EuZmUX3cRn8XS/U/eu5GuGSIYkJVsTZS2Y59KGeeFTYr7FPoCPESX4DZYHJUe3TJpelfPfHfaZiO5pJk5owCRG7e1Bnqfnq/C5zUoA/A4ph5wbM+c5XFcWUStLOvLcVbTsTF7E2nN33w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358297; c=relaxed/simple;
	bh=YGHO/UiRFK/g9U5YGo+KkonWS9DwiL3ALLa1v2afJ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRhuL0RnN94H0+bvSuyBrIKD/dvf2KYdzyCHnDwV22OQdwt2/51G308y5FRYPOFqoFzqKhrXZO09L2pAU7DECPyrgo3rbipZsgxaIH2HOHE42KeNMKWxPZuVGRJUIfmVLCdPgCKEhRYITmjKprrl97PYgZQPEDS7obvh1C9iOK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCE5qP8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCE5qP8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62616C4AF0E;
	Tue, 30 Jul 2024 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358296;
	bh=YGHO/UiRFK/g9U5YGo+KkonWS9DwiL3ALLa1v2afJ7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCE5qP8+Wiwo8N4+fZIok8UPXtry6dlHwpBk+byx5UJ7b9xtNbDMhkiXMAu9CpzSp
	 c9W6zw7SQ2+LJ5xIGsb1Sp6rOWhzgwMXUWLvm0lItBxwjf1d0Lw01UFzWmpu/3/MVo
	 EARazmBt9GKaw8pCsA8kxfwyp6gmZZxyBaUn1Zko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 343/809] platform/arm64: build drivers even on non-ARM64 platforms
Date: Tue, 30 Jul 2024 17:43:39 +0200
Message-ID: <20240730151738.181322164@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 13bbe1c83bc401c2538c758228d27b4042b08341 ]

The Kconfig for platforms/arm64 has 'depends on ARM64 || COMPILE_TEST'.
However due to Makefile having just obj-$(CONFIG_ARM64) the subdir will
not be descended for !ARM64 platforms and thus the drivers won't get
built. This breaks modular builds of other driver drivers which depend
on arm64 platform drivers.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 363c8aea2572 ("platform: Add ARM64 platform directory")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240624-ucsi-yoga-ec-driver-v9-1-53af411a9bd6@linaro.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index fbbe4f77aa5d7..837202842a6f6 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -11,4 +11,4 @@ obj-$(CONFIG_OLPC_EC)		+= olpc/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
 obj-$(CONFIG_CHROME_PLATFORMS)	+= chrome/
 obj-$(CONFIG_SURFACE_PLATFORMS)	+= surface/
-obj-$(CONFIG_ARM64)		+= arm64/
+obj-$(CONFIG_ARM64_PLATFORM_DEVICES)	+= arm64/
-- 
2.43.0



