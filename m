Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334559446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC50FC433C8;
	Sun, 13 Aug 2023 21:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962646;
	bh=KIYmjJUlABjCAsYEljvtmFBRmg3FlNNrwIfd2rlFziA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOgNQyOKpQt81IZNh0wzJTVpyHsZrwMvZk3U1abZbNcOqPb37OlkSor4f545egf+X
	 jtNuFYF/jp8q24FDGdNyPsrwEF3v5Fnq+xwBgpseEZYpCsScityFLxe4N9hERnXyDb
	 afBqeSbd/bXyqSHDQHcqQhPPJcG9uxA4KsCu3aQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yang <leoyang.li@nxp.com>,
	David Bauer <mail@david-bauer.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 105/149] net: phy: at803x: remove set/get wol callbacks for AR8032
Date: Sun, 13 Aug 2023 23:19:10 +0200
Message-ID: <20230813211721.913497543@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Yang <leoyang.li@nxp.com>

commit d7791cec2304aea22eb2ada944e4d467302f5bfe upstream.

Since the AR8032 part does not support wol, remove related callbacks
from it.

Fixes: 5800091a2061 ("net: phy: at803x: add support for AR8032 PHY")
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Cc: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/at803x.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2087,8 +2087,6 @@ static struct phy_driver at803x_driver[]
 	.flags			= PHY_POLL_CABLE_TEST,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
-	.set_wol		= at803x_set_wol,
-	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */


