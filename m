Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BF1ACDED;
	Mon, 14 Oct 2024 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919945; cv=none; b=vBxx5ni4XN3k27ipWDbmu3RBcZq4nwt5TrsF45qvY2ywKz+9jkdey7gLbkoByqwhUYc90su7aaudYcQD2WWVcYWitkbgJDVfVLk/M36e+/TqYtWfQtDFKySNN1vbmOaT2hI9Fv/oN0Gagm3uTD5+hg8Y3O/rBA1OfDvoKGhaq7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919945; c=relaxed/simple;
	bh=8hWPnoqwptbP54AuJAYIi0R3yzoMek3xCNo5zQZNYJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7YateanfL5dPGg4RWXQalMOdeVJ6o5rZs1gaHv1DdEZoxMSqtzadx0AGtbBcANcSEh9AKPMTkzKW22ezXBtMXaoGPHA4t7bCrW6Ozat5AfMGyA4bdSCvCwBD1jZx4YmkX2fngj5EoWVTwjCPFFTW4sm2XxEb/LpVD1AcMuHno8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wuy36cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wuy36cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236B5C4CEC3;
	Mon, 14 Oct 2024 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919945;
	bh=8hWPnoqwptbP54AuJAYIi0R3yzoMek3xCNo5zQZNYJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wuy36csR81t4hlQkBeQQc9XA/Z0YT1nIzYCFazalwyTebW0qM79/aZ2wLZLJYH9O
	 KOfuZB03UP3IVV46YFMYHoPktQnWpY5Bt8JHCibwzkPzADEqyLwZ+11zZnM4uF2Tr5
	 Cf1U1W5p0jOEPke5bU1vGaQ089GagXU9iowLJ9tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 753/798] net: ibm: emac: mal: fix wrong goto
Date: Mon, 14 Oct 2024 16:21:47 +0200
Message-ID: <20241014141247.653833260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 08c8acc9d8f3f70d62dd928571368d5018206490 ]

dcr_map is called in the previous if and therefore needs to be unmapped.

Fixes: 1ff0fcfcb1a6 ("ibm_newemac: Fix new MAL feature handling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20241007235711.5714-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index ff5487bbebe37..a93c9230e982f 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -576,7 +576,7 @@ static int mal_probe(struct platform_device *ofdev)
 		printk(KERN_ERR "%pOF: Support for 405EZ not enabled!\n",
 				ofdev->dev.of_node);
 		err = -ENODEV;
-		goto fail;
+		goto fail_unmap;
 #endif
 	}
 
-- 
2.43.0



