Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3A478B7B;
	Wed, 21 Feb 2024 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521400; cv=none; b=YlIJjVXk345lC4I6auyGD2j5UxLqsS2hPUG5Yl/tu1t5LCH/hR6vJ8ZwMB61GlrJn5by+Alwh+tgv7hP5zYyAh9L0n4NFRCnTDUXA48kx7M+w0MXFUHK96vnqKZfdZg8TRP/IRGk554qiI27Bkklzd7tAgOD7JuxOEk3jQUKfVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521400; c=relaxed/simple;
	bh=P7Hc9Nj//DCFT7FfcRyE/7JTdasHwfn4BqgKUxn0GAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXAe/tG4/5ls+7kKRRWXe9sUvRTjt2n1IZjx17rKuW/e6NewAzb8HcEwEIi3HVtaS9Ka44V63tSNMtg6Gol24p+lyYPvu09YiRdWtcahjuadZabJpzXyGcs/fgZ+9adQAIuExy47mKXbDbJysecaKXXNgtzJNNrRDJw2BtIrhdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWSOu2hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWSOu2hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65299C433F1;
	Wed, 21 Feb 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521399;
	bh=P7Hc9Nj//DCFT7FfcRyE/7JTdasHwfn4BqgKUxn0GAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWSOu2hSrZsAPRd0D0mm8J7N7dOeRHrKDJSXFJvx3d57mFrdf68kFmyHckfQSyOUM
	 mID68hhmdp+g1m+9K8gm5PcJ5jTHU+bssfukLv7tqPJjSo+STR3zVC5+CPhcr04f8/
	 8Lz4348xWiPx8jQLCZ2e8CV3yc1lDtY3fXaa1eZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/202] drm/drm_file: fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:06:41 +0100
Message-ID: <20240221125935.004205947@linuxfoundation.org>
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
index 334addaca9c5..06cdae6f598c 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -299,7 +299,7 @@ int drm_open(struct inode *inode, struct file *filp)
 {
 	struct drm_device *dev;
 	struct drm_minor *minor;
-	int retcode;
+	int retcode = 0;
 	int need_setup = 0;
 
 	minor = drm_minor_acquire(iminor(inode));
-- 
2.43.0



