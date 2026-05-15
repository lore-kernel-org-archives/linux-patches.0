Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7D73FBB63;
	Fri, 15 May 2026 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861540; cv=none; b=puh91rc7SgKytfAUsJyzZkLzJNx7Skaru6ECmbLaMYV0yODhtxig+vvt8/QImVUqm+KyF5zrbAhDw6EBRswU8jSB1/jSSNf1I9TPXDo/XYXnJtmfzBN0Vkp0A8D5SSZtSN0IiCbQijYdh2mYJMuppt5sI+nLW6g+BKDxQ6OmYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861540; c=relaxed/simple;
	bh=g+06aT9x6tQGxS/5fjWUf1CRuPtxY3XtTTh+BJl8L8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CReJZnItqSrezi1F8X0hSRMcOvi4mwI/iKKcEHhkRL41rxcgzh6QEywQQu4UIH5OFrJb5kMnMH3S6pbHzCMYr7R3AGS8FOqUwCKy7xoerG0CAsGe99lK7UugAFlMy8ip/zvV/LJ+ZJ0uIeNivbxW+LRp6Ci7PK9Ttdf61pEaJv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh41NJ5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh41NJ5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A221C2BCB0;
	Fri, 15 May 2026 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861540;
	bh=g+06aT9x6tQGxS/5fjWUf1CRuPtxY3XtTTh+BJl8L8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh41NJ5JlAeSjktpJo6/VxeazAJz3cWw+rqUW47sUYRNTrHA2sRA4fG7yFcy+HpJy
	 GZysRcAhfAcYi0Q93IhFgx0DwKGRbYaHdWJkBsjPZ0+TGYQlL24OymyptL9vnLt8rD
	 OsLjWH7cTrhZbj/whI5H8f3ywAajyhuyiBTQMg+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/474] ksmbd: use msleep instaed of schedule_timeout_interruptible()
Date: Fri, 15 May 2026 17:47:56 +0200
Message-ID: <20260515154722.962250794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f75f8bdd4ff4830abe31a1b94892eb12b85b9535 ]

use msleep instaed of schedule_timeout_interruptible()
to guarantee the task delays as expected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: def036ef87f8 ("ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -495,7 +495,7 @@ again:
 	up_read(&conn_list_lock);
 
 	if (!list_empty(&conn_list)) {
-		schedule_timeout_interruptible(HZ / 10); /* 100ms */
+		msleep(100);
 		goto again;
 	}
 }


