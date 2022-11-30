Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C4F6FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FDCC4347C;
	Wed, 30 Nov 2022 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832850;
	bh=lhCckk7m1S8yEYPQuCjIH3xoM3s/UW8mHvCfdyKhirU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qd0mM/IJ0zPWVRc2XI/2PRl9AlPNH653ijS+1QcW5iWQ2lhrWALTqk5Uim7YbI9BK
	 a69/d2VgmWtiSMICB8ivGfdPIngnSHiyOBUWzSe+6wXpUjMWR5YSeXzTi/qno9pIbb
	 qgmKM6fejw2WXSJSUABM6YH40S3HRmC+pcrWC3Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/162] macsec: Fix invalid error code set
Date: Wed, 30 Nov 2022 19:22:23 +0100
Message-Id: <20221130180530.187671811@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7cef6b73fba96abef731a53501924fc3c4a0f947 ]

'ret' is defined twice in macsec_changelink(), when it is set in macsec_is_offloaded
case, it will be invalid before return.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20221118011249.48112-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c20ebf44acfe..3e564158c401 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3813,7 +3813,6 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-		int ret;
 
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
-- 
2.35.1



