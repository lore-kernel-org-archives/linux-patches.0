Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91E120E334;
	Tue, 30 Sep 2025 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245682; cv=none; b=bD2AUaopPHNdDgWHb7gBMghaTWYSVJWc+2mvigwA+ZBMRaxQhxAoBir0I19idZ5OqsXzNjcOutbAtXyMqyG4Qe9LxozrjF5Vj8sy0JT90QMkIk2gcAhTKgRNg5m0P26tgatr4sPk/Q+KrSpI2/FodR5q7ZEl+fkZcx8w0t8af/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245682; c=relaxed/simple;
	bh=lnAuQUWIiIH4IqkwDrrKrtzZ50x6WIuW9GSWB0IqbD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK6gCj2YKbCAt4Xd346Q9DxmP0R06IAOXlwC5tCW2Tyg1EL3Qu+uujY+TWBWdM2ft90RayLwVMmO4VPQ7vpwqNjboMnitN0GiY9vqDBX6F5bnc8ghlPs9gHGWp7yU4tNypruzk0qz68mtrYI1bqMQJJR+H4n/N0WBdgOA73R59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewSO5mAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewSO5mAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCD0C4CEF0;
	Tue, 30 Sep 2025 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245682;
	bh=lnAuQUWIiIH4IqkwDrrKrtzZ50x6WIuW9GSWB0IqbD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewSO5mAC5vDK1FFB2tuK1v5vrMf9fBwoRJrDbPfllFT+fBtFP3owBsF5GOo+PuP4A
	 5TeOfzcpg4z0579OXw4tRjZb8wui5eJd4Ts+n9WSugKQK70uf7MqfY02B2ub3QlzBA
	 t9bjM6+Zy4vwzmK4PtyLWm71i21V4a1uehd8ranI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/91] firewire: core: fix overlooked update of subsystem ABI version
Date: Tue, 30 Sep 2025 16:47:01 +0200
Message-ID: <20250930143821.219790888@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 853a57ba263adfecf4430b936d6862bc475b4bb5 ]

In kernel v6.5, several functions were added to the cdev layer. This
required updating the default version of subsystem ABI up to 6, but
this requirement was overlooked.

This commit updates the version accordingly.

Fixes: 6add87e9764d ("firewire: cdev: add new version of ABI to notify time stamp at request/response subaction of transaction#")
Link: https://lore.kernel.org/r/20250920025148.163402-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 73cc2f2dcbf92..bdf4b035325e9 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -39,7 +39,7 @@
 /*
  * ABI version history is documented in linux/firewire-cdev.h.
  */
-#define FW_CDEV_KERNEL_VERSION			5
+#define FW_CDEV_KERNEL_VERSION			6
 #define FW_CDEV_VERSION_EVENT_REQUEST2		4
 #define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
 #define FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW	5
-- 
2.51.0



