Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E60269317;
	Wed, 21 Feb 2024 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525338; cv=none; b=BIGBC0ZyUkP8s0jzUIj0LFwuJhsq9HHIeaf4Jv4js3lrODzHk58JKzlCL/B0ZFpzLo2FOEpokKe1N8Nu06QxcsrpR/2vdsJvgA5uRPiCEB8wRgkTira7Lr7chnwhDD1ayG6YkZExc4xECB2ugKRdk6g6LSpB3Dpa1DNPmwQ/GSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525338; c=relaxed/simple;
	bh=xs90hVGigphkaazRh6ytRetl+hb+op0PQWfrX01NE+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg8on5/h09G05uNhc2BQ8j36gjs2CTvmN413nFFYCB2aFafDu+5JGvJHElCWgYfbqcmMdgUU1DA3teH6kyD9ZsJNPzpDBDO/CL4tKhdRgNvrc+kt69NtzzAullT6rLs27kOQ9q8va41D+Na2bRn20nSbKbw7fRUAAfYE+8u/0ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUCfSxCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUCfSxCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C805C433F1;
	Wed, 21 Feb 2024 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525337;
	bh=xs90hVGigphkaazRh6ytRetl+hb+op0PQWfrX01NE+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUCfSxCjUjegR+Goi/5KypThyJQCfKHe7OVeJ6jPFiTSB64aJyg+h/WNTGqvwlle+
	 43R0H3dNGR+89ScPVxTBAEOALlyCYfRJ6Xf4wuBNDM1AwV6zH6BIlPxPL1gk+Cce7v
	 9Tse58AjksPZHEikIKBw5bmd8rdxE3JgLTedxeHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/267] drm/drm_file: fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:07:45 +0100
Message-ID: <20240221125943.911883437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 1d3062fad9c7313fff9970a88e0538a24480ffb8 ]

smatch reports:

drivers/gpu/drm/drm_file.c:967 drm_show_memory_stats() error: uninitialized symbol 'supported_status'.

'supported_status' is only set in one code path. I'm not familiar with
the code to say if that path will always be ran in real life, but
whether that is the case or not, I think it is good to initialize
'supported_status' to 0 to silence the warning (and possibly fix a bug).

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-1-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index ea34bc991858..e27a15a6fe79 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -369,7 +369,7 @@ int drm_open(struct inode *inode, struct file *filp)
 {
 	struct drm_device *dev;
 	struct drm_minor *minor;
-	int retcode;
+	int retcode = 0;
 	int need_setup = 0;
 
 	minor = drm_minor_acquire(iminor(inode));
-- 
2.43.0



