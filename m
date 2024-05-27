Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535F17727;
	Mon, 27 May 2024 19:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838372; cv=none; b=LIXrYGGTAC2XgBOpRRnGtR5VW37sXEMzAynx/Q6a705Ez3SZqbBxp2o8fSEcrLHylwzBgvLwNJGraJgRwjNkxQwlJS7BJYZNBZZDRkRmzjEjFyvMAve83JPoKypu0k7Ltv0TTqLBIRAN+wKC+CT1/uQ1GSDrIDiaObERDxUN/mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838372; c=relaxed/simple;
	bh=Cy+t5fi5AhkDTIrbUvFQfeGJBu3fkuAXsMR3zUu7Z+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzXpqMxzkki7QOzeCUlvje4g+Mp3VmKKPwrQGaMI/dvgVFX/dXhPDEs4iGOxpnNVpvY7UlDJusRf0Ql6sxWCwB3E3ZwmtiHQGJKaA1F3vyO+j+NNGACQc0GsDTjWa9YVHm9HcXk5mpqXkk+hjndhoTcmG5ambiyMVbZIF9pZ0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xn4sYlWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xn4sYlWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF60CC2BBFC;
	Mon, 27 May 2024 19:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838372;
	bh=Cy+t5fi5AhkDTIrbUvFQfeGJBu3fkuAXsMR3zUu7Z+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xn4sYlWd7UDo4W2EuWLCRqWS94Suizi1pO+3/h2TGsGKDEbZJmtGPO9ZPjWCDV8Aq
	 KPhEPgquD2TWaBtTDJcl4M8Jkk1TOEo43Nr2/chhU4xRqFS4+UXT2Gn3Qsp9mkq4Jh
	 NtPV3IZld9dspa9awOKEYftWBqaifphmEia3qAgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 368/493] drm/panel: ltk050h3146w: add MIPI_DSI_MODE_VIDEO to LTK050H3148W flags
Date: Mon, 27 May 2024 20:56:10 +0200
Message-ID: <20240527185642.320807539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 80cc8c0d09e6bab3bd016ddaccd0570cadbe1891 ]

Similar to other variants, the LTK050H3148W wants to run in video mode
when displaying data. So far only the Synopsis DSI driver was using this
panel and it is always switching to video mode, independent of this flag
being set.

Other DSI drivers might handle this differently, so add the flag.

Fixes: e5f9d543419c ("drm/panel: ltk050h3146w: add support for Leadtek LTK050H3148W-CTA6 variant")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240320131232.327196-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
index 30919c872ac8d..a50f5330a6614 100644
--- a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
+++ b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
@@ -326,7 +326,8 @@ static const struct drm_display_mode ltk050h3148w_mode = {
 static const struct ltk050h3146w_desc ltk050h3148w_data = {
 	.mode = &ltk050h3148w_mode,
 	.init = ltk050h3148w_init_sequence,
-	.mode_flags = MIPI_DSI_MODE_VIDEO_SYNC_PULSE | MIPI_DSI_MODE_VIDEO_BURST,
+	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
+		      MIPI_DSI_MODE_VIDEO_BURST,
 };
 
 static int ltk050h3146w_init_sequence(struct ltk050h3146w *ctx)
-- 
2.43.0



