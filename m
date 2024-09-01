Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25D1184547;
	Sun,  1 Sep 2024 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209095; cv=none; b=pNsvVVZOPMz2cwCiLZLvSZuFY/8aDLYUeedG8JzesdyzXHVMjbmds/rR7oiJAF52t112oXFrIYc/JE9x685RvRbwGk+EIUy0sDPpwl+/J7sB7d9jPBfTMyYya/r+4tUYU3alAOl9dbS8ViRwj7cg1uZ4Z52n51qfLplbxBjOZVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209095; c=relaxed/simple;
	bh=CvbzL/o69OYj32tGCJwRBfF7ojh/RhqsD0C/6aSmNNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2Nl03mkHL6rREwb7aarg70ZnO2KOe4CgLFlrgXGecttgf/XMqAt2dAm94rmdVK22mbfxfPVrh+BJdw1F6Mjeb4v4LBMB2pFxeWtwUofA51atLRwB+lJfz47lWIKkGfaItreqhZ2mwJHgsnMmhlZLRER2bbdF5aYwKEz3EVRXoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtCQHERR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtCQHERR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5B0C4CEC3;
	Sun,  1 Sep 2024 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209095;
	bh=CvbzL/o69OYj32tGCJwRBfF7ojh/RhqsD0C/6aSmNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtCQHERRBDj2tnxcOndh9rEQMy22eLfJTB3T4WAMsITO369sxNKxcS3t5aNnXRa+S
	 zVJES4XApn528amPdrilh3IeIAWsLVA/qLqIcaZjHGhmSiKn/3HLdN6BXvMmK4jZaP
	 bOootGw9r8I+qYPiAAZlhmb/XjlPNrnmSUqppBuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 133/134] net: dsa: mv8e6xxx: Fix stub function parameters
Date: Sun,  1 Sep 2024 18:17:59 +0200
Message-ID: <20240901160815.081120064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 64a26007a8f51442a9efddf7d98d50e2ca4349cd upstream.

mv88e6xxx_g2_atu_stats_get() takes two parameters. Make the stub
function also take two, otherwise we get compile errors.

Fixes: c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for get next")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global2.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -533,7 +533,8 @@ static inline int mv88e6xxx_g2_atu_stats
 	return -EOPNOTSUPP;
 }
 
-static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip,
+					     u16 *stats)
 {
 	return -EOPNOTSUPP;
 }


