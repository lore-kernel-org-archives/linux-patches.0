Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B21F7097;
	Wed,  6 Nov 2024 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896983; cv=none; b=e70AAP+CQvJRnZMATp92D5IqBQv4gVlWbM63XmJB5Q9VvuvXsbvEIXMfUx7EFIGc/uG36klN5bfhbVK9OPk17ialHJsB3REl7++ijPQXHFwT/CddfOptXBsLemHTJ8QL6Jqgg8+g9o1w7Q19Gl49uBVCHhrqMM+V6EkA9TvFRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896983; c=relaxed/simple;
	bh=PjWF7iE9E9gQsesacYWuLusudfEjZ9KqgSz8ThQq0H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZGIAq2gZHXVeCspofxLlh3hPU+iZPREhqdnPYZzBBmIJ/j2Okd1CjzcQS+/E6xXG+y2uGcrylMqi2aE5Gt8aRbCa6bUBX1hBu8mNMqq4EgXJl42weSF12Tf6JSvqrRJo9y6Nw4tBnHZy8drtZ0GEWjGH1/eEfY30TuhNKTvL+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgwBxLAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgwBxLAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D7EC4CECD;
	Wed,  6 Nov 2024 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896983;
	bh=PjWF7iE9E9gQsesacYWuLusudfEjZ9KqgSz8ThQq0H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgwBxLAtMFTGNOoKLo7t3FAv6dw1rhgjAK6fbBvRP62mnlcV+0ZuVGYSUntETwbH1
	 slZ71OTu/bZJvHQn7mCbokEiKHWFC3PqcE6ZC97jQs51eyYLOv9DJbN1UVwF8OL4XG
	 Z+bnqDKOI0gbFkLlIriGJ1WqiQdkAcJRzsXvj3w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/126] netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()
Date: Wed,  6 Nov 2024 13:03:48 +0100
Message-ID: <20241106120306.835553908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 4ce1f56a1eaced2523329bef800d004e30f2f76c ]

This was found by a static analyzer.
We should not forget the trailing zero after copy_from_user()
if we will further do some string operations, sscanf() in this
case. Adding a trailing zero will ensure that the function
performs properly.

Fixes: c6385c0b67c5 ("netdevsim: Allow reporting activity on nexthop buckets")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20241022171907.8606-1-zichenxie0106@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/fib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index a1f91ff8ec568..f108e363b716a 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1377,10 +1377,12 @@ static ssize_t nsim_nexthop_bucket_activity_write(struct file *file,
 
 	if (pos != 0)
 		return -EINVAL;
-	if (size > sizeof(buf))
+	if (size > sizeof(buf) - 1)
 		return -EINVAL;
 	if (copy_from_user(buf, user_buf, size))
 		return -EFAULT;
+	buf[size] = 0;
+
 	if (sscanf(buf, "%u %hu", &nhid, &bucket_index) != 2)
 		return -EINVAL;
 
-- 
2.43.0



