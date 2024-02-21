Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7057C7A733;
	Wed, 21 Feb 2024 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521403; cv=none; b=M+6SHKjrvJsw2T6vwptEidH7GcFqFTp+ZbND3QzhEP9HXySWjHjRmKoiPtAKK3iJoLv9JCl8xOL2cU/lLfO95vSxcfNE7uOUv9hvp2HcaIK2UP7eHnyiQQqgCxvbgyhhSC8pACDnejGoFkfsvr5cNgSSRag8PjKIvF1QjRcRp+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521403; c=relaxed/simple;
	bh=BDhTuR0aZGKCVcntgp1Q2ucz0ae9kdV+hIlxlsTw4q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRQtx8Z1VYXzxPsXl+y3X4RZfPfy+YfHS0G9pK3BBHtP6VecDKmzijAHksvOzNh4yHmnEb0J9ATJdyMAgI64uoV+K80EHeRoIAk/8LtPxDqczPX5aOMX8LNhfmvRP4NAmZpPoboYP3fKte+1Z1ArgJqDfNlRIV2B5ZzZa/pAPVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IpdHU7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IpdHU7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C7C433F1;
	Wed, 21 Feb 2024 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521403;
	bh=BDhTuR0aZGKCVcntgp1Q2ucz0ae9kdV+hIlxlsTw4q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IpdHU7x12dIdFH2FiT+YZTLKTBPv9ptdqrMG7qppt/wpvY3V48uMwkw8Yqf//90K
	 vnJWStXgzJCZX4Ph6asjIcmcOy3m60EXiHJWL4mqiGupverBr8A6mQv7hcoyrueixP
	 p5jFhpEssSgqDxxx87yfFlwPeC3Ve/Lmwmb1C0Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/202] drm/framebuffer: Fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:06:42 +0100
Message-ID: <20240221125935.034040941@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f9af8f0c1dc567a5a6a6318ff324c45d80d4a60f ]

smatch reports:

drivers/gpu/drm/drm_framebuffer.c:654 drm_mode_getfb2_ioctl() error: uninitialized symbol 'ret'.

'ret' is possibly not set when there are no errors, causing the error
above. I can't say if that ever happens in real-life, but in any case I
think it is good to initialize 'ret' to 0.

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-2-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_framebuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index b64a6ffc0aed..9fc4af4b10a6 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -538,7 +538,7 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
 	struct drm_framebuffer *fb;
 	unsigned flags;
 	int num_clips;
-	int ret;
+	int ret = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
-- 
2.43.0



