Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047A812FB31;
	Wed, 19 Jun 2024 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802329; cv=none; b=gUfJHl90LZMsAwXShCFXTGXXZveTjoruWb+TcRhLdn77JORJ01FYAKTXfjxbrWB6dEP1FKvv4bZkOsaS+jKZAGjqMaZstgLsouUlWriXeMdKQeeM+FjTWhqd1TLmsIOpUwQm5wCHs6mZhxaOz85P1iqu/nVwdcjbHQa4VrAsC5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802329; c=relaxed/simple;
	bh=+krnm+6NiqybvcEfQkVmah7xiOToBo9NcPFOi0lM3cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDUF19y6JjRSMmacjpgxtRQTVs6YM+Wvf4uAvjj2rznq5Ev0KRK/dbtw9oaMFYb6iJs49aFE/48Z60Nm1LwkIogQyhZxw8xLH5BrYyOIQyEfspEFq8oDi+Ej3891Ey4iRX50NAJglK7JQRQb7AoRRUG+/dGBnB5xJWOM3FgdhdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dqIVc2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dqIVc2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F45BC2BBFC;
	Wed, 19 Jun 2024 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802328;
	bh=+krnm+6NiqybvcEfQkVmah7xiOToBo9NcPFOi0lM3cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dqIVc2nnGJgsRYDVNXTv6o147eOwF9WigEObcp6B6LN14m1sYlep6TmiMlDnRLb6
	 8Z5bK7FirAnkd8JrrR6dOeK5pkYpbdfbxWjUYItjEnPnuyzHC8j3M3EhOhG0ggh17+
	 4xSXX8H9i3tpyh8sWy+GTqfIHhtU/w+CO/vjsMXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/267] net: pse-pd: Use EOPNOTSUPP error code instead of ENOTSUPP
Date: Wed, 19 Jun 2024 14:55:11 +0200
Message-ID: <20240619125612.484675759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



