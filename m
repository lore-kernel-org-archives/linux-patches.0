Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1371459F2;
	Wed, 19 Jun 2024 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803920; cv=none; b=UEjQbUIwsuap2IxJohy+TDyN9CuQVrcl3orl1wzNmleTBtM+7gT88DXHMzWekYP6h46c6Gr1xoSjsanz7bv/GWMRZK43tdKNYSk4+CqB4kWPvD8iiReWHPYVNqpsN8oxDPkwFWYhF0dcmr0jPjcf12xCa9LXMrU7YkDgYD5zJ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803920; c=relaxed/simple;
	bh=RRSk+Ma5T8cGy3H2EmGTXeRDZ/EqDdHd4zCULACVnSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlgTYJRUDxzEcqCaXM8dgUSTj6RnWfGxEAhmzevsSAgYb5nt6BKMayU9jRi3Adl8Yj1Q/5+FFMXqxa6H9lKy3lOO+ysbprUNiDwKpPz0jIzKG6/2NhBa9U+aZaKdLtO294VlNFHUAe8kFpjX9055ZH/IPX+EosPExpV9bd25X1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZRso4R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZRso4R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DC2C2BBFC;
	Wed, 19 Jun 2024 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803920;
	bh=RRSk+Ma5T8cGy3H2EmGTXeRDZ/EqDdHd4zCULACVnSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZRso4R3tDtHv46wgd9oc3RF30MxOj1QTC8bf6+JODAfDJ8k/6bv3kVMmv0dti6Vh
	 nl7UDvQrVlMUVPCfxe251uAeurbwy+duGw2C1aZLwZOVVDFxiqumWWxw8Iq+MKDC+p
	 RD5dN7G3J97K9ur7YSfqk7+SIe6+FHpO/drtx+zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/217] net: pse-pd: Use EOPNOTSUPP error code instead of ENOTSUPP
Date: Wed, 19 Jun 2024 14:56:32 +0200
Message-ID: <20240619125602.438566530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 144ba8580bcb82b2686c3d1a043299d844b9a682 ]

ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP as reported by
checkpatch script.

Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240610083426.740660-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pse-pd/pse.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pse-pd/pse.h b/include/linux/pse-pd/pse.h
index fb724c65c77bc..5ce0cd76956e0 100644
--- a/include/linux/pse-pd/pse.h
+++ b/include/linux/pse-pd/pse.h
@@ -114,14 +114,14 @@ static inline int pse_ethtool_get_status(struct pse_control *psec,
 					 struct netlink_ext_ack *extack,
 					 struct pse_control_status *status)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static inline int pse_ethtool_set_config(struct pse_control *psec,
 					 struct netlink_ext_ack *extack,
 					 const struct pse_control_config *config)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 #endif
-- 
2.43.0



