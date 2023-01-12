Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F39749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B38BC433EF;
	Thu, 12 Jan 2023 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533034;
	bh=m0dMNa619sopbllgp/p+DaUQ2Eb12/gWCGTqewKHzpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Sn88+waGEVhWw69nw7NWxAJOB2cSkEC5CC9+7B50HtNz0wDdovo0CchBHwVAfowV
	 CXPtuVvbeAGwDYT5k8/l+qQ3tyN5BLSJacAqiHWX87yGV/bikqIn7e3HMIpX4FHbhT
	 ch+AqBBMuGgVO61skrVADz0mRhpkikMAOV3Pu9Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/783] usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
Date: Thu, 12 Jan 2023 14:51:05 +0100
Message-Id: <20230112135540.502400171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index e8ddb81cb6df..f4e7f4d78b56 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -132,7 +132,7 @@ int typec_altmode_exit(struct typec_altmode *adev)
 	if (!adev || !adev->active)
 		return 0;
 
-	if (!pdev->ops || !pdev->ops->enter)
+	if (!pdev->ops || !pdev->ops->exit)
 		return -EOPNOTSUPP;
 
 	/* Moving to USB Safe State */
-- 
2.35.1



