Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1202B3ACA68;
	Mon, 23 Mar 2026 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274060; cv=none; b=YZDxOdl5CecQUNrnh5jkKSPe9rSE0INmanyBBg4bolB/76cYmbQ57it1aOGupEehgzYYa5KYSyP1XXcv2fLQW7L8QCm/DSzMfxafWZnTURPXTUes0vMyGfaGcNgxSsF3tsXV44e30XeAY8J2eiZGq2kmqzVKWri2opJYRJ4BAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274060; c=relaxed/simple;
	bh=O4aWTymCzyRdeYmFUGSDSdluLR2GPQGGSrSLZFFxJgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stW740ud5wiMzAv/yrqSFuggouRSazw6xielj/HAbVyl6bL3eDrxTcVTokMevLwR3eGMDM5TmLGgWwYnnswl63ALgN3CaucKS7lGR7RKxOj5UhYoHo0tvAqaJ8MwhDTkw6I2NRDlB84VSyApM9JcSv4uSTtPU5O6MXfppnKTbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQAuKQ/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQAuKQ/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C433C2BCB1;
	Mon, 23 Mar 2026 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274060;
	bh=O4aWTymCzyRdeYmFUGSDSdluLR2GPQGGSrSLZFFxJgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQAuKQ/LoKHymlPyqOC9XmZtAETwt/MY6JA35iFhIaDLGaGERfQV0TdSsSb938Da6
	 0EMRpRijNcJx6Rk9XnA08cx2V52Uwmo9Exp0DvsTa0qYrhYTTS6XVhgC4FJw3++l8r
	 yRtTwwLwFvEecaah1HZdwwrYAM+4ADUEvfvJvWVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 096/220] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 23 Mar 2026 14:44:33 +0100
Message-ID: <20260323134507.632740772@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9 ]

Fix tree-checker error message to report "invalid root drop_level"
instead of the misleading "invalid root level".

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 12d6ae49bc078..59794d726fd27 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1256,7 +1256,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	}
 	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
 		generic_err(leaf, slot,
-			    "invalid root level, have %u expect [0, %u]",
+			    "invalid root drop_level, have %u expect [0, %u]",
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
-- 
2.51.0



