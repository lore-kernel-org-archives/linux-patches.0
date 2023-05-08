Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E8168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E8AC433EF;
	Mon,  8 May 2023 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540274;
	bh=gW+lWQ9tIJYeA/+8RpQLqbcV0FQy3caS1Caec1cjZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmmFHOISZ4kwDLO6p5XwO5TvQ6Tz6VXRfzvEGIXTnvM2CuNxsjpp2EjwHaYt6bkZc
	 8vXVlMYcTDDqhsg4BtvHskqasL+m5UvunKW+1oRqfbJ2KH8on5THZz6Y1zNk1HS3Fr
	 XKXG2dYoNX/bEU4jV+Bkq78kyFwsWOLnh6BZznQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Sean Anderson <seanga2@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 302/611] net: sunhme: Fix uninitialized return code
Date: Mon,  8 May 2023 11:42:24 +0200
Message-Id: <20230508094432.240388150@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit d61157414d0a591d10d27d0ce5873916614e5e31 ]

Fix an uninitialized return code if we never found a qfe slot. It would be
a bug if we ever got into this situation, but it's good to return something
tracable.

Fixes: acb3f35f920b ("sunhme: forward the error code from pci_enable_device()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b0c7ab74a82ed..7cf8210ebbec3 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2834,7 +2834,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
-	int err;
+	int err = -ENODEV;
 
 	/* Now make sure pci_dev cookie is there. */
 #ifdef CONFIG_SPARC
-- 
2.39.2



