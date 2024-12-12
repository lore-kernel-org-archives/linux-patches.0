Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFCB22C36B;
	Thu, 12 Dec 2024 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020896; cv=none; b=p3dtkS9XBPxZM+Teqs4oT9jzKDFU9A901FYjgnyxaOvuLD3e4Dly+LrRGoigU10WOQpn/rObLTGNwqk1J2uR9ZxLHa1/iOpYjxUexVnUxi5PRhOj7D0rmKDPkrEUn3ALmcep02/n/yN+kEPIM9txxdDTz7XMd6DEOVto+RJwB9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020896; c=relaxed/simple;
	bh=b7EU+jL7qgwj70tSapTtmNW6NADHPguBOI7TCQfli3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr6pOO85rkqPHtmjwNE2CF4h8omkG66j+olwsXenEnIIo04tEZdODd6FH6bcz2qEY5KtXLVip2hme4TSie2iMzg/T15ug4uGRbv4eDwsNL94PXKHT2ynRMtDy/6CLphUAmLhiwCStl8GIb2K+NCxtNWyRZM3pQmQasmwnf6M60c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFLjayuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFLjayuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7199BC4CECE;
	Thu, 12 Dec 2024 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020895;
	bh=b7EU+jL7qgwj70tSapTtmNW6NADHPguBOI7TCQfli3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFLjayuHEkB4MINdgxqInw/75zVNbL6uykxed6AoqVmejTOMRdvU/6eAFvPn2vQUA
	 YIVSIV0U5WQH14SCoJBSdOeX3cBcVWiQPpm3bxYeynZavk1QQSRIFKTJczlPUPwNTB
	 k7sZP5IwNoUA0V+n+7ahxvELM9HFufiRvizHk+is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuro Chung <kuro.chung@ite.com.tw>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 583/772] drm/bridge: it6505: update usleep_range for RC circuit charge time
Date: Thu, 12 Dec 2024 15:58:48 +0100
Message-ID: <20241212144414.030497802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuro Chung <kuro.chung@ite.com.tw>

[ Upstream commit 8814444e62b8a8b573fba2cbbb327d5817b74eb0 ]

The spec of timing between IVDD/OVDD and SYSRTEN is 10ms, but SYSRSTN RC
circuit need at least 25ms for rising time, update for match spec

Signed-off-by: Kuro Chung <kuro.chung@ite.com.tw>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240604024405.1122488-1-kuro.chung@ite.com.tw
Stable-dep-of: c5f3f21728b0 ("drm/bridge: it6505: Fix inverted reset polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 292c4f6da04af..aad750ad4798d 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2563,7 +2563,7 @@ static int it6505_poweron(struct it6505 *it6505)
 		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
 		usleep_range(1000, 2000);
 		gpiod_set_value_cansleep(pdata->gpiod_reset, 1);
-		usleep_range(10000, 20000);
+		usleep_range(25000, 35000);
 	}
 
 	it6505->powered = true;
-- 
2.43.0



