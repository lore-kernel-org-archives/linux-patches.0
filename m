Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922EFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B7C433EF;
	Mon, 15 May 2023 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170548;
	bh=C1EHBejhltQUJsb+n597kPRcWUmcmrDTBbB4j7w2Thc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IliYm0U/BgdzYzz/Nx5lrfoYC5dQy450Sna9HaE0RYfOV9vL771HIusKR13GosnTX
	 gXC7hsNdfUjiPb5Fd5KTO1jUOk2hPRex58Ws1n9PeHAMT52C1A5JIQyV/wnK5fho7W
	 IS8fGb1cK7cO7iyprcrgnSmT3RZR5yJFxhIuJQZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 6.1 148/239] drm/bridge: lt8912b: Fix DSI Video Mode
Date: Mon, 15 May 2023 18:26:51 +0200
Message-Id: <20230515161726.122852148@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit f435b7ef3b360d689df2ffa8326352cd07940d92 upstream.

LT8912 DSI port supports only Non-Burst mode video operation with Sync
Events and continuous clock on clock lane, correct dsi mode flags
according to that removing MIPI_DSI_MODE_VIDEO_BURST flag.

Cc: <stable@vger.kernel.org>
Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230330093131.424828-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -504,7 +504,6 @@ static int lt8912_attach_dsi(struct lt89
 	dsi->format = MIPI_DSI_FMT_RGB888;
 
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
-			  MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_MODE_LPM |
 			  MIPI_DSI_MODE_NO_EOT_PACKET;
 


