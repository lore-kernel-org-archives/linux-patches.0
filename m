Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3198C14F9C8;
	Tue, 20 Feb 2024 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464563; cv=none; b=e7RRV8ayMDv8yzC6Qg0Z2XX0OtbuDqRys+Y8zVlAuqZWU0EGMG5as5jkA4aheFLZwgw1y5d6ib69I/O2kAKdBibUIuIeBE6ta9QEvBSdt0znigf5+yendsdmbvkjsBSEySIXeiiCBGfqfn6UW8TOyQRdJdsUouKVckQUrckycYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464563; c=relaxed/simple;
	bh=a6KueRRi9IwNHnCU1fJ9OxEu4NmRgRXJCr2FROHOeW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqhp/8d+QZkhtHVKHfOmpsvRpXbU1SvRfvx7jRI7ql/SRH9RAZj6bHqk9eoRtDLDav/2l1aQxIBbX9A9zcawDtR77Z+UJNBqcJhs9/6d7U1tuqBw9NONzzVZoGZK+UDnLh8T2TAD56x+JWJKmWWK9b2ypo2K1OLFH/5XFm0fTU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+ks8V9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+ks8V9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A566FC433F1;
	Tue, 20 Feb 2024 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464563;
	bh=a6KueRRi9IwNHnCU1fJ9OxEu4NmRgRXJCr2FROHOeW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+ks8V9pIEHtie89ZVyAKYyw3Ofk9JQ6dntAyuTHhrNAmQxRKWtShdEq+xZG4kOWr
	 3s4ldkBVz7DrbGYke74YrmjwAlxo1IRfTMSKOO5XotOQdRLQCNBPfES0MwK10ciNAP
	 XhwF5AQQqyWyHovP3ft7JB9R/wFqXAWXlh9HmwwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Batra <prbatra.mail@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 033/309] bonding: do not report NETDEV_XDP_ACT_XSK_ZEROCOPY
Date: Tue, 20 Feb 2024 21:53:12 +0100
Message-ID: <20240220205634.222938326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



