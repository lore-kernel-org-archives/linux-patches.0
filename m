Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B491DE4CA;
	Wed,  6 Nov 2024 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898719; cv=none; b=YCN9nFxfus0bUYuxOE+CBF2P8rD9C04CZfzeoScYOuhhurCV+oIS2m8yjt48ly7ExfSZ2w4FtjcB5bsJ2c/6NbCy+14rSWZDZ+v7lZ3HWgzqiYxzVWTlMX6HG5q5Fjv4OtT55I+3nuUn143T+FhRuYRWQJgUzScv3hKgxe2LsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898719; c=relaxed/simple;
	bh=h4Xs0gs6HAgxsYYz/B52SRD0GMLLftNvVI0/ZT70iC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKDxJT8KY49nvCDri2FOk8auvrSVjYa03SAwOHkXRV/8UKY/IoXbMTbo2AHRfH14oFUKZKPNY+VtVwLMxOo5X7vJZAU4sZ46TezLz/ftD58So0AhFZgs0YjhTVDY0IzZHOyJKd5Qg6vyX3Hd5/gDfOW7EM7TMXxmYOjEYWmOpEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7wAZACh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7wAZACh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6DEC4CECD;
	Wed,  6 Nov 2024 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898719;
	bh=h4Xs0gs6HAgxsYYz/B52SRD0GMLLftNvVI0/ZT70iC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7wAZACh/gnB//RTmNElWHMaaee9g9EZvYRoaPrhqSA3lL0vd55pUDWnDbogQ7G60
	 /DYKdyjiprHihsR+2wgxYOTVLJU8NwpQYz6U8B7FwOqlK9m4NBID9j7FCDWQNyMSFe
	 qS3p7IhdU7efETfolRsksAFmNEi3whiqelG1OAjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 332/462] net: ibm: emac: mal: fix wrong goto
Date: Wed,  6 Nov 2024 13:03:45 +0100
Message-ID: <20241106120339.726878577@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index 075c07303f165..b095d5057b5eb 100644
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



