Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CF8BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F7EC433D2;
	Tue,  7 Mar 2023 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215168;
	bh=xZRdJm/6KrNbsJNM6DifdxK4g5uCpQXLfs7E24wwxbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6Py4P4XWb4xESCk2IFCztn3f5eZbOLqvzSz/yE2pJSXSolVABYx3YZ8GXxoNdaEx
	 d+Nqe0VjbMJ7JoWnq57YdoB6yprXLkUTtyar49HFfmIsQ1VL5sKusrD5h/AHrnFOjv
	 WXoDv5PZXJ+YM9YPfrDS/QIAghGZf5tTmzCoBp5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Andrew Davis <afd@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/567] drm: tidss: Fix pixel format definition
Date: Tue,  7 Mar 2023 17:58:29 +0100
Message-Id: <20230307165913.446506531@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randolph Sapp <rs@ti.com>

[ Upstream commit 2df0433b18f2735a49d2c3a968b40fa2881137c0 ]

There was a long-standing bug from a typo that created 2 ARGB1555 and
ABGR1555 pixel format entries. Weston 10 has a sanity check that alerted
me to this issue.

According to the Supported Pixel Data formats table we have the later
entries should have been for Alpha-X instead.

Signed-off-by: Randolph Sapp <rs@ti.com>
Fixes: 32a1795f57eecc ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Acked-by: Andrew Davis <afd@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221202001803.1765805-1-rs@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 60b92df615aa5..f54517698710f 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -1855,8 +1855,8 @@ static const struct {
 	{ DRM_FORMAT_XBGR4444, 0x21, },
 	{ DRM_FORMAT_RGBX4444, 0x22, },
 
-	{ DRM_FORMAT_ARGB1555, 0x25, },
-	{ DRM_FORMAT_ABGR1555, 0x26, },
+	{ DRM_FORMAT_XRGB1555, 0x25, },
+	{ DRM_FORMAT_XBGR1555, 0x26, },
 
 	{ DRM_FORMAT_XRGB8888, 0x27, },
 	{ DRM_FORMAT_XBGR8888, 0x28, },
-- 
2.39.2



