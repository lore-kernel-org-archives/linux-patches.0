Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98D31581E9;
	Tue, 18 Jun 2024 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715980; cv=none; b=o1ca0ZeYjofUFPaFZGVoZ398i/QuSjus/jTdQUzGBmnHionYS90VUNmTUpYmbYRZdODEPud8xQDNXjmJdnkNNKNWFtEj3TfgiLtHbN4BvEiW+mYbgwR9glyHHv3F6U6j/TE4zAjLqPLgWTZKmnxdNzBzUoCPS5vE+AHdiYJ1BpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715980; c=relaxed/simple;
	bh=ULm1oNItE+L7mRQoLIq99GkXzBa9KK+OF2goHafRdys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5iQZjxXGljHOgHdk5P+IPmuQJqm8Hn/l9vV+gOoDJ/sWcbecspNQob+AqCgBFtKhsvCOZCYkDIMvB363cRiqj7EHZlgUUek5p/iTAK3NHnMyrQZien95OYR0lvfWBD7CxrRpTEpz2rqpUbU5uTs2eEtoQ64BOkQTPs3iPYqSFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDdD152h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDdD152h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEA8C3277B;
	Tue, 18 Jun 2024 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715979;
	bh=ULm1oNItE+L7mRQoLIq99GkXzBa9KK+OF2goHafRdys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDdD152hFj3U6lRb20uqKTYw3GRc72U5kPF3q3RKVhtB3SR5xyX+sBPdt294aSuy4
	 0ZJoBxSrNcl+wu/YdK9HhlU/55mWvvG7j5rI1JxRgVWHWCrow6cNSZkBdrp70Eh58j
	 gsFIQip6KnK8jI2vDi6Q/B/XfoLN60Tl6GSG3uB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/770] fs/lock: documentation cleanup. Replace inode->i_lock with flc_lock.
Date: Tue, 18 Jun 2024 14:35:45 +0200
Message-ID: <20240618123426.308403118@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 9d6647762b9c6b555bc83d97d7c93be6057a990f ]

Update lock usage of lock_manager_operations' functions to reflect
the changes in commit 6109c85037e5 ("locks: add a dedicated spinlock
to protect i_flctx lists").

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/locking.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index fbd695d66905f..07e57f7629202 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -437,13 +437,13 @@ prototypes::
 locking rules:
 
 ======================	=============	=================	=========
-ops			inode->i_lock	blocked_lock_lock	may block
+ops			   flc_lock  	blocked_lock_lock	may block
 ======================	=============	=================	=========
-lm_notify:		yes		yes			no
+lm_notify:		no      	yes			no
 lm_grant:		no		no			no
 lm_break:		yes		no			no
 lm_change		yes		no			no
-lm_breaker_owns_lease:	no		no			no
+lm_breaker_owns_lease:	yes     	no			no
 ======================	=============	=================	=========
 
 buffer_head
-- 
2.43.0



