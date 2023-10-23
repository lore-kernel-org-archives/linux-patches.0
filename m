Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E838D13FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXUaUW5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE2C433CB;
	Mon, 23 Oct 2023 11:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059253;
	bh=PSsnyk3iOjdqG8GmVKXhcbzoyT/H4yt0/BAGSI+H6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXUaUW5wHPULj+NCh4ptmcK42tD+yoNRBOuNN7b0b+j5e5HkXWeUN15WuVNjs+X2b
	 AN3VVA1+3s3MObv0rlWn9h2qKmQ21aushXcxss8AQV5gu0SvwjY6j/SwN2hOf54Rvm
	 pW/fBcVp62VP9bAtUG0s9Gwb+Rylojp8c2QmZaT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 089/241] net: phy: bcm7xxx: Add missing 16nm EPHY statistics
Date: Mon, 23 Oct 2023 12:54:35 +0200
Message-ID: <20231023104836.060936286@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 6200e00e112ce2d17b066a20dd2476d9aecbefa6 upstream.

The .probe() function would allocate the necessary space and ensure that
the library call sizes the number of statistics but the callbacks
necessary to fetch the name and values were not wired up.

Reported-by: Justin Chen <justin.chen@broadcom.com>
Fixes: f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231017205119.416392-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/bcm7xxx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -894,6 +894,9 @@ static int bcm7xxx_28nm_probe(struct phy
 	.name		= _name,					\
 	/* PHY_BASIC_FEATURES */					\
 	.flags		= PHY_IS_INTERNAL,				\
+	.get_sset_count	= bcm_phy_get_sset_count,			\
+	.get_strings	= bcm_phy_get_strings,				\
+	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
 	.config_init	= bcm7xxx_16nm_ephy_config_init,		\
 	.config_aneg	= genphy_config_aneg,				\


