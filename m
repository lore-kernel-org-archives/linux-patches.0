Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E76C1EDA3A;
	Wed, 19 Feb 2025 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955366; cv=none; b=p/mLeSven95wX2oe30HnKSP8nf30ceHGrj6GbO2ozub3+zzrE8+ZsYAlygESQsteeVFXvUYe2wEdCw+6IDZHdHcVe9qN1sPTtPZkIL/1KCHn9321fVXxX8wE5s01gRLqvi5o4LORWTqGEoEsOhKjNvfuLFTtyZooviOc7CxvaNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955366; c=relaxed/simple;
	bh=hwjc2ajyvMUA5Y0JxCowYRtUn6q5jq+2DO1U6FHDeG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfYM0A2gu21t+OCbfNIT77bK/LzLdVv3CsHHr0kTTpR1qHY07Ffprris9LLX+xbz6xGmPj4gp9fFQ+Alf9QniBWA2qQo3wX/3S+9FKIxs68pI7wJn7D4RiwtGHr44tEN+k45X71lTzHG85oyMgt5OV0J+yjhBWxTrgZhxaLIXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdh/Fw8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdh/Fw8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5749C4CED1;
	Wed, 19 Feb 2025 08:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955366;
	bh=hwjc2ajyvMUA5Y0JxCowYRtUn6q5jq+2DO1U6FHDeG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdh/Fw8sUFnuMvRei9dtH3DPanDmxGImiPQNBJ+8Lf6kfHucYCN0VUbsijnry0pLL
	 7Vi/2f3FJfZD3DakV8ui1QdbTY+w/IfU44k3bx6Wz4J2XaN/v03lCy4ubop3izuAbX
	 qWv+pg3h3h1m9VgG444ab8dhaNUZ2acEIema451g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Brandt <chris.brandt@renesas.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.12 214/230] drm: renesas: rz-du: Increase supported resolutions
Date: Wed, 19 Feb 2025 09:28:51 +0100
Message-ID: <20250219082610.066745804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Brandt <chris.brandt@renesas.com>

commit 226570680bbde0a698f2985db20d9faf4f23cc6e upstream.

The supported resolutions were misrepresented in earlier versions of
hardware manuals.

Fixes: 768e9e61b3b9 ("drm: renesas: Add RZ/G2L DU Support")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Tested-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241120150328.4131525-1-chris.brandt@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_kms.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_kms.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_kms.c
@@ -311,11 +311,11 @@ int rzg2l_du_modeset_init(struct rzg2l_d
 	dev->mode_config.helper_private = &rzg2l_du_mode_config_helper;
 
 	/*
-	 * The RZ DU uses the VSP1 for memory access, and is limited
-	 * to frame sizes of 1920x1080.
+	 * The RZ DU was designed to support a frame size of 1920x1200 (landscape)
+	 * or 1200x1920 (portrait).
 	 */
 	dev->mode_config.max_width = 1920;
-	dev->mode_config.max_height = 1080;
+	dev->mode_config.max_height = 1920;
 
 	rcdu->num_crtcs = hweight8(rcdu->info->channels_mask);
 


