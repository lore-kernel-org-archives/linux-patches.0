Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3291847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C829C4339B;
	Fri, 10 Mar 2023 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456655;
	bh=NZi9uK0HBQ3YlzFMeNMn/3txjdwTn3C5yj3oQIB5MGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p26JaZCuQfO+8mV9BmMbA1Gz4AjW0jNLmT5LfMMVr6P30Jiygp99sGeqf6c/UC8cB
	 WaGuONLEwAC2rSRjH8odVkYkGGfZMUnB4xn5avrcnqLPFO/6EkshuAIm9Nu4Y1YBBi
	 pwU0SOHVf7PyflEFu3Z5DIj0Ex3oRev3RuDGC764=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/211] f2fs: fix to update age extent in f2fs_do_zero_range()
Date: Fri, 10 Mar 2023 14:37:07 +0100
Message-Id: <20230310133720.168036512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit a84153f939808102dfa10904aa0f743e734a3e1d ]

We should update age extent in f2fs_do_zero_range() like we
did in f2fs_truncate_data_blocks_range().

Fixes: 71644dff4811 ("f2fs: add block_age-based extent cache")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index cd1c6ed89d5ef..8583c098bc985 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1498,6 +1498,7 @@ static int f2fs_do_zero_range(struct dnode_of_data *dn, pgoff_t start,
 	}
 
 	f2fs_update_read_extent_cache_range(dn, start, 0, index - start);
+	f2fs_update_age_extent_cache_range(dn, start, index - start);
 
 	return ret;
 }
-- 
2.39.2



