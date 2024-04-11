Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C7764CC0;
	Thu, 11 Apr 2024 10:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832523; cv=none; b=FF6H07+4URhcEL9VvvDbgMIaleae2Ck0SnxjUHCAzZVtRqYa6AjcBNwW4O2CJAGL0ZNldiIvulPNF9j5foULJ0pU81jQovvVH3hjl/1sdLwsjkl64MK80O27r0x+60AbzTLC3zyjHMa0APkiL5vlE1pv6LFWbtsxu5zg5SccqVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832523; c=relaxed/simple;
	bh=B9egbZZ8XCf57FSeIAXB/Hle2LFg+SNrjC6ylFeK2KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNHaiLGYt6XsEJ9EuJmIseT0wzKMqx+xyJJH1Lvrl1Z0X8tRcxEdZvZksXBwTpwghpXGfM4vZomUvOB9nr36cervQ47sl0ny0eanGAV44uVooPs/aO62YabylreIixSJvtE9YWHsSMOr1Mkttz3m6dJ74HwsXgIwotLc7jmzwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXSCOtbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXSCOtbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A7C433F1;
	Thu, 11 Apr 2024 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832522;
	bh=B9egbZZ8XCf57FSeIAXB/Hle2LFg+SNrjC6ylFeK2KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXSCOtble/t56RdLTGOGlVblCEyVGCicfok1lvu8qYz+w+zfOKgc2Synjvd/d1pNe
	 R/AXI3Al72DXcz3XGlxF965KITsQPPq8AaxKWb1oqoq5LFc8YAoeT2Hj3whXOP1UHs
	 9Bn1utHl7Tf/ODIegp2XXXTw/3/ZnV2PkP1M/YH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/83] Julia Lawall reported this null pointer dereference, this should fix it.
Date: Thu, 11 Apr 2024 11:57:10 +0200
Message-ID: <20240411095413.830186585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 9bf93dcfc453fae192fe5d7874b89699e8f800ac ]

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 5254256a224d7..4ca8ed410c3cf 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -527,7 +527,7 @@ struct dentry *orangefs_mount(struct file_system_type *fst,
 	sb->s_fs_info = kzalloc(sizeof(struct orangefs_sb_info_s), GFP_KERNEL);
 	if (!ORANGEFS_SB(sb)) {
 		d = ERR_PTR(-ENOMEM);
-		goto free_sb_and_op;
+		goto free_op;
 	}
 
 	ret = orangefs_fill_sb(sb,
-- 
2.43.0



