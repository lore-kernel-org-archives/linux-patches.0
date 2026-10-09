Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB7B31A045;
	Fri,  9 Oct 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555986; cv=none; b=V173drj72DASN/f5gLD2Tw5Gu4qJBYTDYApttd5eNcy/ZrDf42wLhrEXUyieUSBvShTj+j8ivYXZ7Xm+P8M0MnJQyBd31R/FT/7s/fKGWYgBiba71WLvMCZ2ZXPjgUIPCcCmc6YlaFtqqK7h7rZ5yW6ZBqtzIOkrnnEcx8eEFKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555986; c=relaxed/simple;
	bh=OgKPtPaS6FMU5J0gbxFBO18ZvLMi7Jwj4p1oZDMvhpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmZix5M5QOR/9U4tTOlaLINFfXQbJHBCMM6YTM8/X0n3yeaBzdjJCtsAnz68kg2rJBz9mRJs6Pea8b+rebseNmskQNwXq/ri2+y/5+VlO5K7i32n0MKF4IDaInoLhB9SdUh49ALLlheGiQzzlhx5mCSt5thi3LEiRTQOjSUOSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv2EdcRY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv2EdcRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E40E1F000FF;
	Fri,  9 Oct 2026 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555985;
	bh=qNQ/K1zJ1fE/5pYJADJYZaZD6uy24GSMM4x93FpFzII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pv2EdcRYJjDD5jIlJuzCAKyTSInMZF+Nsp5xo29ZU/Br4mBGwspRIwx6YmY+jSz+B
	 QLgfLlyPi+Um4snoKSGUe6sfb7IfycNi60JTHN9+ZkoltW6LciPKMIi4GqRc1qYg8J
	 0WD8/I3rU5oD2URdmB8WnVIe4y3FA0XUfuMfM+eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 101/428] drbd: remove unused drbd_nl_mcgrps[] array
Date: Fri,  9 Oct 2026 16:07:18 +0200
Message-ID: <20261009140948.434544650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d431e03d831c043707e22311c4bdea1907166c34 ]

After the rework, two files have a copy of drbd_nl_mcgrps[], but one
of them has no references:

drivers/block/drbd/drbd_nl_gen.c:641:42: error: 'drbd_nl_mcgrps' defined but not used [-Werror=unused-const-variable=]
  641 | static const struct genl_multicast_group drbd_nl_mcgrps[] = {
      |                                          ^~~~~~~~~~~~~~

At the default warning level, -Wunused-const-variables is turned off,
so this has gone unnoticed.

Remove the extra variable.

Fixes: 8098eeb693c4 ("drbd: replace genl_magic with explicit netlink serialization")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://patch.msgid.link/20260519203057.1340528-1-arnd@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl_gen.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl_gen.c b/drivers/block/drbd/drbd_nl_gen.c
index fb44b948cec87..e133e84152055 100644
--- a/drivers/block/drbd/drbd_nl_gen.c
+++ b/drivers/block/drbd/drbd_nl_gen.c
@@ -638,10 +638,6 @@ const struct genl_split_ops drbd_nl_ops[32] = {
 	},
 };
 
-static const struct genl_multicast_group drbd_nl_mcgrps[] = {
-	[DRBD_NLGRP_EVENTS] = { "events", },
-};
-
 static int __drbd_cfg_context_from_attrs(struct drbd_cfg_context *s,
 		struct nlattr ***ret_nested_attribute_table,
 		struct genl_info *info)
-- 
2.53.0



