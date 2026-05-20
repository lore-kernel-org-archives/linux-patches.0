Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D0033BBCF;
	Wed, 20 May 2026 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298963; cv=none; b=jcEhtZmCCVvyYfAw5oaYR+3XJw+H5pC9Gg2Uv7AR9jH0uL+BZL2n9QYOGPrSyT2lUBMRPMkhnvo4FKkLsZzlrWLF0cIdrwZRupBU76SfL0nhwzdo9ir5kNDfLm6VMf4DAg5REc4hA90o2T46YBLgCVBSQuWtmKMuNZgy6hzi1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298963; c=relaxed/simple;
	bh=v0fydRtPRrVQIAzKHqocwd1XUDfc1jPO6MLpAYvtYAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUufSbJMfC/URBBArzuElYabLYPCtovrxFV28L+DrSjs02EbOZX+ir+5MZiI03rl8sHf46E7YHJbEhcM+ggopYlazEz3HjIeIMu/8aFyViK8b7u5ggdMyKgTNWCfChBkCzayGP6nCGoyoCsa2GMoPT9uP6mxeuVkcMLuwAhSO9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+pqpHS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+pqpHS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628941F000E9;
	Wed, 20 May 2026 17:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298961;
	bh=FXKeEhpXrZ9zCcRA2hAT0+Sb2ohiqiGduMvm1yHmbIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+pqpHS2ZAXMrkFoclZzLlX3KWMpno4mVRGCOgAavVgLbeFTAu5ferj8F3qNnvbpM
	 PIdWDR2ULzvVYUHJWnwUBPMhu9cCmwYGfE9kn7AMj7JY/JiLFJx67z3uQQslfnga5s
	 q40AU7BF5cfUutV5RTlR2ckJa/TCsbh4lYwMlOIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 609/957] reset: amlogic: t7: Fix null reset ops
Date: Wed, 20 May 2026 18:18:12 +0200
Message-ID: <20260520162147.742375248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Claveau <linux-kernel-dev@aliel.fr>

[ Upstream commit 9797524ef2b69c6b187b55bd844eb72a8c1cbd99 ]

Fix missing reset ops causing kernel null pointer dereference.
This SOC's reset is currently not used yet.

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
Fixes: fb4c31587adf ("reset: amlogic: add auxiliary reset driver support")
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/amlogic/reset-meson.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/amlogic/reset-meson.c b/drivers/reset/amlogic/reset-meson.c
index 84610365a823c..c303e8590dd68 100644
--- a/drivers/reset/amlogic/reset-meson.c
+++ b/drivers/reset/amlogic/reset-meson.c
@@ -42,6 +42,7 @@ static const struct meson_reset_param meson_s4_param = {
 };
 
 static const struct meson_reset_param t7_param = {
+	.reset_ops	= &meson_reset_ops,
 	.reset_num      = 224,
 	.reset_offset	= 0x0,
 	.level_offset   = 0x40,
-- 
2.53.0



