Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D51863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C7EC433D2;
	Wed, 28 Dec 2022 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241154;
	bh=QMDNDe6AalTOBB6LNrAi3Uwd6fAkBCbYHifzveKrmcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1g0pupRyEgdXqlgNH2IUikr4XZamEyUqTCa7Fb1zWk3NWYY6k3IUrwS5xa8cFraLD
	 nOdi+IfhoQzX3NnAh3NdWTiUptcfALGGpBDbX4mR1q3IPIgu+ZLOX0qZLWuozGB/Et
	 XxumLJmVP7N6YfySfnSwSZdujKVyz6N406WbC17o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/731] usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
Date: Wed, 28 Dec 2022 15:39:14 +0100
Message-Id: <20221228144309.511349828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit b6ddd180e3d9f92c1e482b3cdeec7dda086b1341 ]

typec_altmode_exit checks if ops->enter is not NULL but then calls
ops->exit a few lines below. Fix that and check for the function
pointer it's about to call instead.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114165924.33487-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index 78e0e78954f2..0aefb9e14f22 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -134,7 +134,7 @@ int typec_altmode_exit(struct typec_altmode *adev)
 	if (!adev || !adev->active)
 		return 0;
 
-	if (!pdev->ops || !pdev->ops->enter)
+	if (!pdev->ops || !pdev->ops->exit)
 		return -EOPNOTSUPP;
 
 	/* Moving to USB Safe State */
-- 
2.35.1



