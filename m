Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017811C3C1C;
	Mon, 10 Mar 2025 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630673; cv=none; b=N9o4rUpUwJZti2xeIT7HuTG/XRvlfaqR/XjHdhHujD/lltQiD5fImCHAO6p+iFo47jPVzbQuW9JJtgUqGVi21XXViA3th09mYPr5rKiyzLCT5hekUEQ9GwifG5n5lWHfXKdzTOqwg8d0OEQXJ7B/Sj3dYHYum7B/QXoD1SPNlI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630673; c=relaxed/simple;
	bh=hFr+J1IEvVqynG0dW4IxGMqIRE9kpM6wTHA5Z0exePI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUdJ+VQiEMlyP33jHWKu49TU3aHpWLiJqZz0kvIyAnAIeJa1u6tPzqByB8lwkbe+2EYyhM32aKvtHz9Sms/0WKZAlBjS6GlActyd8ImY1fw917izLZ9D46gsIQeuFgVd4/sQN8s1pzpl7jRBnsMcERQ3Yt6dQc1NwqWyXNzjlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZU6uf0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZU6uf0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBF0C4CEE5;
	Mon, 10 Mar 2025 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630672;
	bh=hFr+J1IEvVqynG0dW4IxGMqIRE9kpM6wTHA5Z0exePI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZU6uf0dWQeXBR34Htb53n+oH++M1QidRCRfY8oCNRTxr1HrPlqVOqf7oKaSzKHe7
	 58+7yDlUkww+W8SOwPKLqbuqdqwWJhqo3qrL9qhu03y54EsktNpc4C+5ZN0UR0YG/n
	 RDQOOmeW/fEpMtEt29bcS/6GxseWs8caxSOPVk3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/620] afs: remove variable nr_servers
Date: Mon, 10 Mar 2025 18:05:42 +0100
Message-ID: <20250310170605.149565609@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 318b83b71242998814a570c3420c042ee6165fca ]

Variable nr_servers is no longer being used, the last reference
to it was removed in commit 45df8462730d ("afs: Fix server list handling")
so clean up the code by removing it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20221020173923.21342-1-colin.i.king@gmail.com/
Stable-dep-of: add117e48df4 ("afs: Fix the server_list to unuse a displaced server rather than putting it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 3d39ce5a23f22..f904ef5ea7141 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -77,11 +77,7 @@ static struct afs_volume *afs_alloc_volume(struct afs_fs_context *params,
 {
 	struct afs_server_list *slist;
 	struct afs_volume *volume;
-	int ret = -ENOMEM, nr_servers = 0, i;
-
-	for (i = 0; i < vldb->nr_servers; i++)
-		if (vldb->fs_mask[i] & type_mask)
-			nr_servers++;
+	int ret = -ENOMEM;
 
 	volume = kzalloc(sizeof(struct afs_volume), GFP_KERNEL);
 	if (!volume)
-- 
2.39.5



