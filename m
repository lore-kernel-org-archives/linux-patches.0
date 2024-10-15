Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D387B1EF0B8;
	Tue, 15 Oct 2024 12:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994244; cv=none; b=JhMmqYaQP4U3iTVW/zka/ik0gzWiBaqIkLH6WK+TBmUsSf9JodGz237AfMImEcejDq8lVUIK172XX4hjvf4gumc0H2r0ted//BT86zSObemqlt0TS5HKhspcrEN5DjeCt3W5YxwH1a/A2YOGg6YIF/J/yxqzwBUrWgUJmF5+jgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994244; c=relaxed/simple;
	bh=75BhLKVGTxbDnMpufzqhovQIGqnR9M3ycPZVAObCbNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghk6raQO3pE41dL4bSlhU0y62OzJ9IX74/OVJ6TUHRW1a/VnkxR/0Y/CjCPVrvJT3CHRJTv24iki8IiX0Ahs8q9A3hsigUyR99A16U4+I4Fybpa+RWH09I98wSBy3p2dD5nfy0ix7J3XOax1RQhpqOLIkjRTIA6+FgbSznDxPOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYrTYGBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYrTYGBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF1BC4CEC6;
	Tue, 15 Oct 2024 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994244;
	bh=75BhLKVGTxbDnMpufzqhovQIGqnR9M3ycPZVAObCbNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYrTYGBKzMLAsMhhQbmJpC8LhFItSMMT2T2w65Q5xJ2LQJ1+ZBB7ehQUzaD0exkAW
	 XdLjXQa6S39FwvQuIFed97ySdrXsX2jnPL/VxVCpvbXTc3BD6BU3W8nvuSepwB7Rkk
	 X6w26sqWRqbLHVl04zfvJWnPaq/oi7Z6tGJiL6fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 647/691] net: ibm: emac: mal: fix wrong goto
Date: Tue, 15 Oct 2024 13:29:55 +0200
Message-ID: <20241015112506.004352585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



