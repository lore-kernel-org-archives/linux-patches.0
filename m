Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722A82495;
	Wed, 19 Jun 2024 13:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803152; cv=none; b=qvfLKFm41xor+ZFZNkIAES3mN56dL1xGdvHBC3ZkbmXHLR4fCHqVRWx9KMf4aD28MG38j+/PLAlrjltGcaTNoTSgTVHwGaW9Ff26qV3R/XyhX8pJtKcSLbiyCql8JfDNykK2lrOluiv6K9Z5mNpxskl7d8PiBRo3pGC29VX0Ux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803152; c=relaxed/simple;
	bh=fnjC7EeYqp65M3b2P7NpfBfptXGPJDMaVFoKnrlKkcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzfFNHpkBqF997Nt0MTYN51N+JssRgCsOn1RhFftHIlHF8J5s92BPlXPFTL8nS306MARrJYRlA3sbob+Dre2ZLaxR189+xlQAQrdcRfIQ+w83ySXEtXPkmcfUXaVVkUAfBc8k3LlYuCPls/C9n9tyirqE4mElRoWO2fL2zi09Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8vhPFRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8vhPFRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1165C2BBFC;
	Wed, 19 Jun 2024 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803152;
	bh=fnjC7EeYqp65M3b2P7NpfBfptXGPJDMaVFoKnrlKkcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8vhPFRCVbVu+JRUpFEOLDleIC3AkE2AqMOzAz+lua4+Us84WB3OfJ0D85iP25ay1
	 40pqgSoCbvUfi9gtAnLK9kjQRjIWgbPA7Pf1UwVMwDXggpEX7ce5+3JS0cISPbpHSw
	 LkcYcz4dNBK8SrwWK3etprjcbLXtYZ4/eMo48fpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 170/281] net: pse-pd: Use EOPNOTSUPP error code instead of ENOTSUPP
Date: Wed, 19 Jun 2024 14:55:29 +0200
Message-ID: <20240619125616.378176741@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



