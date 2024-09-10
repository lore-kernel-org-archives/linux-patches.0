Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56F6224F6;
	Tue, 10 Sep 2024 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961940; cv=none; b=FMbaoYKFiJhk9pAmgJBfNlezocMyDdlpiIQZfgOiZ01ND8ZvCEtkDWppivtK4DrSgFkXoPlBO/jl00fZqwmCQp2XKTBlfXxsOkdhkx1lUQXvASTu9iExjSW6WZHtbSEu1GbFp6Pp7dheEiJGMfFxTPgdMqgXhWDDEF5TFfvlLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961940; c=relaxed/simple;
	bh=OCakLGx+nHTOmGo03FSzAR2d8wNWZMpqmn+Bg2kG3ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5rW7kAtDTyucdovVF5JS/h2Sv/ks059MAtpPkb/Kj1EqDlGju7OzsHLE0gd8/9Jeam7AhmjNEQX4hf0PlSoMotdBLYx3TD40Rgl11+fNF3TAuw10n9R+niHLiFwXnRaVOVmaIrgTt1vOoenumLm4JxgsOJD43jBqOFCwbnN8qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x26vk1Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x26vk1Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F045C4CEC3;
	Tue, 10 Sep 2024 09:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961940;
	bh=OCakLGx+nHTOmGo03FSzAR2d8wNWZMpqmn+Bg2kG3ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x26vk1SiLxqEDRWUN82ZCB1wcCMOMj8DrrePvT183kSQ4WQddlBXK/YH/2qpKqXWo
	 MG1zm1pTfKcT8IJI1GFNPDndcfY9Dwk2GCy4w//sbt4pKkVro5AjHgfoxbr9kAUof7
	 WQV3imoDbO4Vhl3t5kszXUPpbdZLMHu/P8GlL2cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 240/375] btrfs: dont BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()
Date: Tue, 10 Sep 2024 11:30:37 +0200
Message-ID: <20240910092630.614093276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a580fb2c3479d993556e1c31b237c9e5be4944a3 ]

We handle errors here properly, ENOMEM isn't fatal, return the error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8bf980123c5c..0effe13ae459 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5339,7 +5339,6 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 					       &wc->refs[level],
 					       &wc->flags[level],
 					       NULL);
-		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
 		BUG_ON(wc->refs[level] == 0);
-- 
2.43.0



