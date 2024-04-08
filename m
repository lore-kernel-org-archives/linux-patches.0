Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7867EF06;
	Mon,  8 Apr 2024 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583905; cv=none; b=DkqJEQtzi4rTt2wDo5+DYK+kT2421arS4KOMrjY4eMIVMTk5mv56gqgyfGG/gdlsp5tq2l6PsFZf+4sWmRvWMAtF5JCSTWVzQ8mkks8FqD+k9zmO8fG03pA1AhfCBvnzUNHG6f/HRfjxMYr2NmKYmTIRDbsqZ+A53W/fuq1Cqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583905; c=relaxed/simple;
	bh=K2rimx0q7nUAwqSl8LMvRuEJQ+ZRukS7cKbJkHdE0aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNKZbKCxLsYUwU8xvTYQy+34Fkg5JLRXMwEe8O1B140nE402T/rn0DumRmGv61/Er/BbDc9JqnEefGhMQ2GAH4NiddrZjB8Q436/8cESVPdNA1tTRaHiA8aB2xCxBJsdHMglqIJyF/ysx3euOxW6AjxC/XvFY7maNRLkgy5VER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVjzxHK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVjzxHK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04535C433C7;
	Mon,  8 Apr 2024 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583905;
	bh=K2rimx0q7nUAwqSl8LMvRuEJQ+ZRukS7cKbJkHdE0aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVjzxHK2HW/kZNDRbqRMHo12O64EOZaPad5jsPtMObG9xd48eYbgwh4gq4vdEsFdm
	 PlA/2Q4fUXKA9OkIRyG6GNJ69XU67gsL37L1zHhLsqx8HAQBahw9URez/juKNxMamj
	 85x02nn7l3yt1/XiBGGAYYgJgmj2p4HhM5UFhf74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 289/690] fs/lock: documentation cleanup. Replace inode->i_lock with flc_lock.
Date: Mon,  8 Apr 2024 14:52:35 +0200
Message-ID: <20240408125410.080346412@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 9d6647762b9c6b555bc83d97d7c93be6057a990f ]

Update lock usage of lock_manager_operations' functions to reflect
the changes in commit 6109c85037e5 ("locks: add a dedicated spinlock
to protect i_flctx lists").

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/filesystems/locking.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 5833cea4a16b2..e2a27bb5dc411 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -446,13 +446,13 @@ prototypes::
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



