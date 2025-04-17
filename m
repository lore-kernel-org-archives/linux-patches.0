Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248AC255254;
	Thu, 17 Apr 2025 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912899; cv=none; b=DF1HaiBJojM3t+Swu2qZdGlB6+bnQ9gmyyyr3HqYulOCgpwZ2zPU/3+qMASTmKavLMTrcaDVJn8aQZDb1V9ke3EyZXCxSRW/FOkCYU5/x3Nt0b1UhsttcWDsAFShMar0MDTZTJzyZyLr4PKDtMzS0GmZ1h+xrJGI4f9J0GPDSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912899; c=relaxed/simple;
	bh=FtRaBl75AMnSEKkcNtwFf5ohMLjLgMp4BLDA2+c9NMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcUMrJME4BoDJLP3Uk3Yx6x/oKDD2aJMPyGanTZYCy+I15MpbzHNgY26li+0/XeXN4xIM84XMpqAxeADCMiL/8G49QGh8XDR+MHCdw6CfF+qbZ+y3PfdWQl2wOSB2Ap1hEfkQQQxW0K/3LfUtbtg1z9qd2oSl0e+Q73Uh6q00Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCuqiWMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCuqiWMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB28AC4CEE4;
	Thu, 17 Apr 2025 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912899;
	bh=FtRaBl75AMnSEKkcNtwFf5ohMLjLgMp4BLDA2+c9NMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCuqiWMF0anopksG4Fiy0dexfMVucIDJZOxQLxzIg7MMp7r6DkTRwGCuFGniKvlR2
	 EDDyvRjo7PvDY8VKvKhJCBYCaQMReHAM4FK2BYqjTdzk7jQesbzxoxj/clMRKqLAV2
	 gOUyZa/DK1N5l/Up1s9To9JLQGMyDaiTwJAmOLJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 160/449] drm/debugfs: fix printk format for bridge index
Date: Thu, 17 Apr 2025 19:47:28 +0200
Message-ID: <20250417175124.421817821@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 72443c730b7a7b5670a921ea928e17b9b99bd934 ]

idx is an unsigned int, use %u for printk-style strings.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214-drm-assorted-cleanups-v7-1-88ca5827d7af@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 536409a35df40..6b2178864c7ee 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -748,7 +748,7 @@ static int bridges_show(struct seq_file *m, void *data)
 	unsigned int idx = 0;
 
 	drm_for_each_bridge_in_chain(encoder, bridge) {
-		drm_printf(&p, "bridge[%d]: %ps\n", idx++, bridge->funcs);
+		drm_printf(&p, "bridge[%u]: %ps\n", idx++, bridge->funcs);
 		drm_printf(&p, "\ttype: [%d] %s\n",
 			   bridge->type,
 			   drm_get_connector_type_name(bridge->type));
-- 
2.39.5



