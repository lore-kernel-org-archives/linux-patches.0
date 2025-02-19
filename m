Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4244117A2FE;
	Wed, 19 Feb 2025 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956783; cv=none; b=Srcm4nH+2ApgOsnWg8waJ3TBgPAbkluI+Ci3+syq7UBHqAzELktvEAG4h7ZrbLhyCU6JX0LQwGjnjFfPnzJhdlP9/+MxU+AIUA6yzXOL1A9E5s9gTJ1bUYqdavlCa8J6T7Zl5qUNB8s8nzr2JDdLWjukU/hyDVB/TG89Y/D0r9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956783; c=relaxed/simple;
	bh=g/+oyQF+YZFByaZWditQH8DdxAKcSby/a5uB+pqy9WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eI25LMYwW2HKotsgAXIk2F3gQgsGBhznPJtYsTpXq1Zt5rFlCLqCY4fpGSd2IFdANmosQnGHKkRn+4vMR89j4IeBjR5bXSFCNvnVYIgPBYijJI4hJeeJ2VjBHtL8UhzgqhajoJsHLS61Nbtsicmykd5BkwpIhoo39n17aojZvQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDeHgHML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDeHgHML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E7C4CEE6;
	Wed, 19 Feb 2025 09:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956783;
	bh=g/+oyQF+YZFByaZWditQH8DdxAKcSby/a5uB+pqy9WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDeHgHMLBnPgOAUOr2Row7zoDA/6w+fpCnG46aeWyZ0He6AlqKqsiC1q5S3KFwvwM
	 nLtoIVr2qBcVLEIyj7xwSq+XD1Qg7uxHiGbPvSaUxVhmwneht8DXk24bQOBTO86t+1
	 9VHQqHI4yHoS1UU0S62BNxKiNmIPvpTWcLYev1vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/578] drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT
Date: Wed, 19 Feb 2025 09:24:45 +0100
Message-ID: <20250219082704.070553391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 45596b211fb88..6140dea66e43a 100644
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



