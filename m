Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1E1DFE0A;
	Wed, 19 Feb 2025 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956534; cv=none; b=LjGcjv1SndWzlQoYbSpRGyjvhisno0NZ0stYGqzB8jqJMo+LR5xNEY0fb696d083myau0RZGmWt2Nd0bizY5iT7T10jAAW9/W51bD933Lhpo1ZYL/XBy+MCqQHaCMxbBviE/31AXhNm74TDHbL3cVro1bqxeaGlPSU5Z7MAhwKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956534; c=relaxed/simple;
	bh=RjHmGUHN6e14y1xbzSuZewDn+x4fY6AeJjGP5uwKpDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8xv1mp5ixUctQ1vlFgjnyhLh8DoPFKbuk2fAhqeI7QS3Q7ecFvkodtkzAZxQUMKiohUqM4ZwDjbnbsuWjB/I87tq4O7Sb0UIPjUifX3FBzRlLHYXYQm0XWCqkELAAzVHxalOZlu5kOTiVx89dToupjyBUzPfP379jCZjYxoxj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToMlWkcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToMlWkcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB212C4CEEB;
	Wed, 19 Feb 2025 09:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956534;
	bh=RjHmGUHN6e14y1xbzSuZewDn+x4fY6AeJjGP5uwKpDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToMlWkcmA8jfT5X35lBdTp0CDpZgghfdOJrewwKbz6hX8wQYgDVwHt4UbAtMYd4wq
	 83MjXdyjwDwdlIozw6fpK08Db0lvM0J+Y7XyfcqoIFx5ftJiQm5b9mtxKVXtTIl9db
	 5sxTDeZZ9I4ndydOIsd0wSegGquRSVwo7KzbN30U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/578] NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
Date: Wed, 19 Feb 2025 09:23:34 +0100
Message-ID: <20250219082701.320429807@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 668135b9348c53fd205f5e07d11e82b10f31b55b ]

OFFLOAD_CANCEL should be marked MOVEABLE for when we need to move
tasks off a non-functional transport.

Fixes: c975c2092657 ("NFS send OFFLOAD_CANCEL when COPY killed")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 89c32a963dd15..923ccd3b540f5 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -551,7 +551,7 @@ static int nfs42_do_offload_cancel_async(struct file *dst,
 		.rpc_message = &msg,
 		.callback_ops = &nfs42_offload_cancel_ops,
 		.workqueue = nfsiod_workqueue,
-		.flags = RPC_TASK_ASYNC,
+		.flags = RPC_TASK_ASYNC | RPC_TASK_MOVEABLE,
 	};
 	int status;
 
-- 
2.39.5



