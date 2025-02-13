Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A01514F6;
	Thu, 13 Feb 2025 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458664; cv=none; b=UjyhWUZ/kHGxcV1vAb4Au8yEsKxXS2dv7+HKfP5ccwnIbNIZMeaFANUor7Mks5iGAuGpfraVnYU4YdHrNh0Rwo1FgAS+vFvoKlHQG+I23eP7IIfy+g1x0eXT0qf+Jfn7qxSvkOOy/OK7MY6DUbVGHiSrzt2F9lDcn1NztIVW9iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458664; c=relaxed/simple;
	bh=V64LNWQpUWLX1bChXemf4+bENmEjFoPc0FeRFgKVNFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxnbWw0HiZBAb5LM0dAHf1Mh2Pmrn5hFScfvI6iZTZoFDh2LshS/0TE4cVL+LTeoztF+1yr7IDrAWTQShd+onlrae17arOhmceJMCrnl1TbgNt2a+kF1He58wuTSlDzaUDReix+2ikaId2+pQaqlrXq77U9le8pEeHgQIymwhZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8XgvQ2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8XgvQ2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EA7C4CED1;
	Thu, 13 Feb 2025 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458664;
	bh=V64LNWQpUWLX1bChXemf4+bENmEjFoPc0FeRFgKVNFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8XgvQ2WdDACxOIsiM25t5+aNhssrnMfNUpsjTl2HboWjNi9P9RWm19Yvpp7iF8lK
	 yOZW7y1XTjWzHByfQU+xcsb0R2PoRUJNxBL8FLoBnhJPhBx0p/ySRaNrAviSgnz05H
	 nYYz9/NSCRPmyz62tGQYshJLqFDnH4R7uU1U8b5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/443] drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT
Date: Thu, 13 Feb 2025 15:23:29 +0100
Message-ID: <20250213142442.323738948@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit 85597bc0d70c287ba41f17d14d3d857a38a3d727 ]

A HDCP source device shall support max downstream to 127 devices.
Change definition MAX_HDCP_DOWN_STREAM_COUNT to 127

KSVs shall save for DRM blocked devices check.
This results in struct it6505 growth by ~0.5 KiB.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-4-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index cf891e7677c0e..d55d7dad9545f 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -296,7 +296,7 @@
 #define MAX_LANE_COUNT 4
 #define MAX_LINK_RATE HBR
 #define AUTO_TRAIN_RETRY 3
-#define MAX_HDCP_DOWN_STREAM_COUNT 10
+#define MAX_HDCP_DOWN_STREAM_COUNT 127
 #define MAX_CR_LEVEL 0x03
 #define MAX_EQ_LEVEL 0x03
 #define AUX_WAIT_TIMEOUT_MS 15
-- 
2.39.5



