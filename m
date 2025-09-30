Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E61306B05;
	Tue, 30 Sep 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244473; cv=none; b=VkNSRg7lezYnABbRNhxJ8891FawGCCVfDUJxmeBFc3KAbfvuypCxeOJ4FLodIjyUfuwc411VhABPBzhNzWaySrws1mjE0IT9K1I2R2StiQ13FjoIs1JHoR+160USSovLauCjiAbYTxxhOZ0Te9hbS3ATxXMT6NpwgdIUg5m/QBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244473; c=relaxed/simple;
	bh=m/iEqsrzx2LkE4qDM7Z+3KLnDHbe49duZRJLozorc1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+dHOX9L4zEkwGeZLDPsZjivZHTvDRYoRA+NzuDd6+w/Z215pVfcok5hoPzlrsGaCs+FEFytWanjfRqHGPhLEYMyg3wnpfFBueFotLcDZss6GVzX7bunr2IGQz9zs5tr5yGU7+rdoCY0OM6QGKA4SgL+uDzRfYm0t5JZ3gCQSvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfZAaj9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfZAaj9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D72C4CEF0;
	Tue, 30 Sep 2025 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244473;
	bh=m/iEqsrzx2LkE4qDM7Z+3KLnDHbe49duZRJLozorc1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfZAaj9kEZuh+fr22SGMn/83ZsowR2nYTS95y0i6aEOMG8gji4OZe1G/7qy9uNUDE
	 39dTyOGDDRV/KC2mmG2UMf9bOfVX/fIO6igSq67YO1Nn68J6BcUdadb9o/LPILr9Cj
	 iHT9PW4/cSq2q/h086dUTgK12X6RgDg0CojX/aHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 002/143] firewire: core: fix overlooked update of subsystem ABI version
Date: Tue, 30 Sep 2025 16:45:26 +0200
Message-ID: <20250930143831.339701124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index bd04980009a46..6a81c3fd4c860 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -41,7 +41,7 @@
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



