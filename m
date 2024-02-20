Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E55E612D7;
	Tue, 20 Feb 2024 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463463; cv=none; b=tnOIW0nLqY0Lm4OMqo9Aij9fuh+tuoDxucMma+0sZnbQ8cKfEKl6nvarPE7O8+JEZ1XdKFS1LHLxyW+FKjKx8KP7bfc+MDIZ1Az3Mvn1N77TEw4OKmcyUCcuvsnh0BnqLiEkXq555dMPcO8BBz7rAWn6w4KCk5BVM3mP+mcoXZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463463; c=relaxed/simple;
	bh=VqNeA+VEq9oRBEf2EGX55WKIg3qbCMGqUPwLbJBbXew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BR13gXjNeOD3h5+MrMGqKesaQxJscdKsdEz22a26gF5c5xmg75ioUlCSdOzx3MtBBtOkeOU9FKmVKjlIPm/7HY5tM0lGzioDAaTA7Uysn1xZm1pHTeg4FgTw0kXhKFbVbuPXsdkKG2Um8XJ/n0kx38oenCidEPvCwrAf9L/5TQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShtirRF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShtirRF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D1FC433C7;
	Tue, 20 Feb 2024 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463463;
	bh=VqNeA+VEq9oRBEf2EGX55WKIg3qbCMGqUPwLbJBbXew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShtirRF40+uzV62G/s9WLOnORyxpv2bcMWwobULKJy3lNovXR0CbqAtkqJDRL6eQt
	 ZwtJTY2N1piAjY+HZvfcFHBZt4UJ3O0EhFsqi5YuD4y5yNcV0pe2IrvHstmCLY1u7T
	 OBbfjQ6fAH3j63w8p2ZHEeWlFxlIXHgtVGAQpUBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Batra <prbatra.mail@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/331] bonding: do not report NETDEV_XDP_ACT_XSK_ZEROCOPY
Date: Tue, 20 Feb 2024 21:52:20 +0100
Message-ID: <20240220205638.352812408@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 9b0ed890ac2ae233efd8b27d11aee28a19437bb8 ]

Do not report the XDP capability NETDEV_XDP_ACT_XSK_ZEROCOPY as the
bonding driver does not support XDP and AF_XDP in zero-copy mode even
if the real NIC drivers do.

Note that the driver used to report everything as supported before a
device was bonded. Instead of just masking out the zero-copy support
from this, have the driver report that no XDP feature is supported
until a real device is bonded. This seems to be more truthful as it is
the real drivers that decide what XDP features are supported.

Fixes: cb9e6e584d58 ("bonding: add xdp_features support")
Reported-by: Prashant Batra <prbatra.mail@gmail.com>
Link: https://lore.kernel.org/all/CAJ8uoz2ieZCopgqTvQ9ZY6xQgTbujmC6XkMTamhp68O-h_-rLg@mail.gmail.com/T/
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20240207084737.20890-1-magnus.karlsson@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8e6cc0e133b7..6cf7f364704e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1819,6 +1819,8 @@ void bond_xdp_set_features(struct net_device *bond_dev)
 	bond_for_each_slave(bond, slave, iter)
 		val &= slave->dev->xdp_features;
 
+	val &= ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
+
 	xdp_set_features_flag(bond_dev, val);
 }
 
@@ -5934,9 +5936,6 @@ void bond_setup(struct net_device *bond_dev)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
-
-	if (bond_xdp_check(bond))
-		bond_dev->xdp_features = NETDEV_XDP_ACT_MASK;
 }
 
 /* Destroy a bonding device.
-- 
2.43.0



