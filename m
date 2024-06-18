Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097611AB374;
	Tue, 18 Jun 2024 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716517; cv=none; b=cuj2v8uVT4fsfDN0GpLTns4mjRXjPwjHHQG5JtiOzAZjQoykvj1xxZoKK+zHBp13Pz8bGfnR1Uu0KU6chjpqONNyu6/7tV+LlKw/Vn7F5Yo+RLiqLH/ivz3bnlU5d+jActMpQ6Ojm1iyX1Yqz+N+n0xG6/2SJyWluFdRurMNltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716517; c=relaxed/simple;
	bh=eR/jy3UPJ1MNjJVLZwlTmg/izC32jEkwqkGwPhG2zw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePi1pOKpraypAN6Wkk1LVh4BvLanKsuInD+npt6NmHzcl/NPonUdKm+zDX9zXz6yBqYfVKe6lccwUeQFdOzdo4D1kZZWx4HO1rXXCRnjjQlSfjXdAN0pdHkk5nVHFd9CnaHHTtOcC5/B/xWHPQ4ybvjX9Flj7uAHIY+vJUvL8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FhBIEwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FhBIEwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E09C3277B;
	Tue, 18 Jun 2024 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716516;
	bh=eR/jy3UPJ1MNjJVLZwlTmg/izC32jEkwqkGwPhG2zw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FhBIEwQVGfFjcIiXEBBwgX+MeE5Lj4LgwSeBkUScbyJ4A1o8H2VLeaHySXBEs9rq
	 W5Lne++0fnZOxsvJ7PIG1wB1+w05O8OTEme4br9+hYQBk/Zmgs95mhWP1vdJ7AaEum
	 tTl0fQfVOxlLymSGzjbDnJFhl1qE3X4H7idJ5Qns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 671/770] fanotify: Remove obsoleted fanotify_event_has_path()
Date: Tue, 18 Jun 2024 14:38:44 +0200
Message-ID: <20240618123433.181712888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 7a80bf902d2bc722b4477442ee772e8574603185 ]

All uses of fanotify_event_has_path() have
been removed since commit 9c61f3b560f5 ("fanotify: break up
fanotify_alloc_event()"), now it is useless, so remove it.

Link: https://lore.kernel.org/r/20220926023018.1505270-1-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[ cel: resolved merge conflict ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



