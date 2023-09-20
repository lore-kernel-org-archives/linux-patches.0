Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688C530FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E463BC433CA;
	Wed, 20 Sep 2023 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212902;
	bh=CDZiq5qyaQm8mHyQTnPCBNnzmI5q3TaYiKNybmdSg3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzYf9a83Hk1tw2m4GMAZNMniJgbP0W+C31mlsHcxHb0maS7Ti93OMootNCzdphWqF
	 9oQ1Nrnmfggi0jcTNE8jNcdsTeYark2Tm40yHCtvArFUpkmTSeiP2vfkL3h9a+J867
	 VWuoJiKjz733ndpLAQlOz4NTeWptVl6N23e4WgG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/367] drm/bridge: tc358764: Fix debug print parameter order
Date: Wed, 20 Sep 2023 13:27:44 +0200
Message-ID: <20230920112900.798038941@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 7f947be02aab5b154427cb5b0fffe858fc387b02 ]

The debug print parameters were swapped in the output and they were
printed as decimal values, both the hardware address and the value.
Update the debug print to print the parameters in correct order, and
use hexadecimal print for both address and value.

Fixes: f38b7cca6d0e ("drm/bridge: tc358764: Add DSI to LVDS bridge driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230615152817.359420-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358764.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358764.c b/drivers/gpu/drm/bridge/tc358764.c
index 170f162ffa558..121250473761e 100644
--- a/drivers/gpu/drm/bridge/tc358764.c
+++ b/drivers/gpu/drm/bridge/tc358764.c
@@ -180,7 +180,7 @@ static void tc358764_read(struct tc358764 *ctx, u16 addr, u32 *val)
 	if (ret >= 0)
 		le32_to_cpus(val);
 
-	dev_dbg(ctx->dev, "read: %d, addr: %d\n", addr, *val);
+	dev_dbg(ctx->dev, "read: addr=0x%04x data=0x%08x\n", addr, *val);
 }
 
 static void tc358764_write(struct tc358764 *ctx, u16 addr, u32 val)
-- 
2.40.1



