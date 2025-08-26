Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C6E267386;
	Tue, 26 Aug 2025 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208559; cv=none; b=ZpQX5Gj/bI4T7bX/SO71BIkK7z5vYHk6apsz9XowD9+Lr12IuyH/u+UY9hMgBkU+SZ1JES3sLx2K+7LwdomIHFKFk1nHDrtop2wKgIpipEyj8Ygj/0FUxv1npBLmlhUDYkM8Wx5f+h51ebmkZsuXrYzp4xgF+xihw3GzaWDntQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208559; c=relaxed/simple;
	bh=/pfDHMMkQ7ZgB9IX8C1Q65r9VHR0qyCIN5UsWj9KdGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksUu7Oz1IQnIzqJPm6B08kP6yfa3H0CYKy7D+T9I31SB2SkE69JmIDDdYRfAQ1dRY1GG/6hFMtYxHDZduvZ8WX7JrFFw30qX5nqINuEFkBsDdH1Obvk9qctx7aZ0m+dUQENyZ2359V6u8HsrJl8THGZYyBVNbsNM9J6ae1+tjXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQlsRjWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQlsRjWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178D5C4CEF1;
	Tue, 26 Aug 2025 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208558;
	bh=/pfDHMMkQ7ZgB9IX8C1Q65r9VHR0qyCIN5UsWj9KdGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQlsRjWtM4Ktne4lyFvLzR9lmdjZXmLJBqZkjbJBTuim3W/aSwIJtUR9c+xIzd8ze
	 rZau04mkMc+Wkmr45xk1y/fjNVe7O4UL89hqCBmDZMdBnOGQstuyP4U7s0YXwVCE+o
	 HBIirIk5wyPGyGbcYYBhHtWjic51DVhcNVG0/FwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/322] btrfs: send: make fs_path_len() inline and constify its argument
Date: Tue, 26 Aug 2025 13:09:32 +0200
Message-ID: <20250826110919.696139764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 920e8ee2bfcaf886fd8c0ad9df097a7dddfeb2d8 ]

The helper function fs_path_len() is trivial and doesn't need to change
its path argument, so make it inline and constify the argument.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -478,7 +478,7 @@ static void fs_path_free(struct fs_path
 	kfree(p);
 }
 
-static int fs_path_len(struct fs_path *p)
+static inline int fs_path_len(const struct fs_path *p)
 {
 	return p->end - p->start;
 }


