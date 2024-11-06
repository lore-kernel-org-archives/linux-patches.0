Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7CE1EE012;
	Wed,  6 Nov 2024 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897373; cv=none; b=b0uJRKQNMRLEAW76R2/oUwv14O6+XiFIdAKhSvI6mJT9SqEvFDK3CP1Mm3BuuI+WBxY+m/iqcJLx7zmYPuwdvi/GXbjV65kaz0B1pXwQldFtXt0EaU8NC29lay5UUzfXXZ4SxnKq8lrf0M3F4eiwoRuwcjtdml7HurzxTBjdtls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897373; c=relaxed/simple;
	bh=aqW3BwqDuTV/J3DmeeO0WwGrzxKR2i0CKHJb4MKOrdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCf1IUDJ70YwFjK++CTqp+JsrBQmq7AdMATuXdP1c52pNz+sQ47HTQIT0q1VHJfs7KZr5IppbbQdm0QP93B9zegptOlF0EieU9r/0BoEa3uj35TvHU+sfUWPQicvNgv9WsQ5MUDcZXcxWp3nMXZVVKLDIZBBuDcYprhSOIMR2i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffW36k6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffW36k6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2661C4CECD;
	Wed,  6 Nov 2024 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897373;
	bh=aqW3BwqDuTV/J3DmeeO0WwGrzxKR2i0CKHJb4MKOrdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffW36k6UICTC7BwBsE0dBUs0NKdmgQ/mD0bExS72PwJrktvIrCaT5qOP4nBAwGASK
	 RMvU/8PK2B1KGeiaU/NZ+Q7mw6Q6ApgBz7+DS3gjtJ1SnLH8uj08JtDyJAWLZujBAl
	 3yj+nPIV7s+89yGPcfPCOzAwsYfdHmxnz07OLnF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/151] netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()
Date: Wed,  6 Nov 2024 13:03:38 +0100
Message-ID: <20241106120309.664638963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



