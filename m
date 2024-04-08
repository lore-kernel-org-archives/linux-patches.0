Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C29A74BF5;
	Mon,  8 Apr 2024 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584495; cv=none; b=umvhYmOrf27XqHcDtRHJWwtYWDXiBEa77Qh9fIVLMoABlUEr440ecb+nWGIEiSAKn6wbl0b4E0C9vLeWXzj5uR5cveWjhNsB0BO2s+ACgqMZ5peRHp4TJMHIqM2RtbFzJC46sIGoksJ3HK997AbW8kyRupCcSxsLcK4sXbrOpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584495; c=relaxed/simple;
	bh=zbGbyx+3wZWnOj+N8cIToEobqYZjGfoKzNVGKzF2/MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExT3htxYjyOL8BQ0vHOIC7ayBDtxU9VxwiO08DaTwCh/WBgOjG4x8yWKdr3ouQY1BikQNGYxfObM/f0D4ziJawEekRSLjin2bwoqEc2xlI+/JYVtujQq2f8VmuKjl/MMBLcfDSdAfK5INH/HnBQBp6l0k9ycI/i206UPawDc/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOFcEDcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOFcEDcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E09C433F1;
	Mon,  8 Apr 2024 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584495;
	bh=zbGbyx+3wZWnOj+N8cIToEobqYZjGfoKzNVGKzF2/MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOFcEDcW8AeUSsGL2ZtV89V2HH+hYsnob4w0su0eE2L+gewbkA75zpUQPj2HEai0C
	 rmYtYbOKfVgggFBr3heDLY2L5XPY4QFpgzwxrokOhpe8Do1SIJEIPCb90XG+tEAbPe
	 nvWCT1GQMjc9WQSEjB7Scxl7NGbg2JCn7JMQadws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 458/690] fanotify: Remove obsoleted fanotify_event_has_path()
Date: Mon,  8 Apr 2024 14:55:24 +0200
Message-ID: <20240408125416.223889589@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 7a80bf902d2bc722b4477442ee772e8574603185 ]

All uses of fanotify_event_has_path() have
been removed since commit 9c61f3b560f5 ("fanotify: break up
fanotify_alloc_event()"), now it is useless, so remove it.

Link: https://lore.kernel.org/r/20220926023018.1505270-1-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index bf6d4d38afa04..57f51a9a3015d 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -452,12 +452,6 @@ static inline bool fanotify_is_error_event(u32 mask)
 	return mask & FAN_FS_ERROR;
 }
 
-static inline bool fanotify_event_has_path(struct fanotify_event *event)
-{
-	return event->type == FANOTIFY_EVENT_TYPE_PATH ||
-		event->type == FANOTIFY_EVENT_TYPE_PATH_PERM;
-}
-
 static inline const struct path *fanotify_event_path(struct fanotify_event *event)
 {
 	if (event->type == FANOTIFY_EVENT_TYPE_PATH)
-- 
2.43.0



