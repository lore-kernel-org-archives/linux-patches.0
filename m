Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A35242D7B;
	Tue, 26 Aug 2025 13:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213734; cv=none; b=X6PQWRj7ZCcWCp5KM/LCkEUVfUNwfN3wPunlas4+lQNCRwPehsqaqy7uB1zE9KKig3PulQqjH2Y5VG2l1Y//sioRmKKVzg85tN2D/wiKUc2cDfJ3rkkLt7BI+t5n8J0VDYBy0JUf9QD+sKcl1JDOpZ8mH9mf7mN+w5KeX304T3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213734; c=relaxed/simple;
	bh=+4gItVbcHxILRlqQvC+oBcBtXaKmDgUf9QSU7l7Z/sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ75DTB1Q6jx3mykZiqaYz8G0XZvVapGLy8SkJQttzxAsP76e1Vp07Lit2Z5LyG/w9rLOUdJFHzU6niOZxJzbTc/cncEocaYtXcvm87CyrfRsqkkfPHHhqdY6v1AnBqmLDvuAEQ5pVJQm1Y9LAvvUBJWd/DwMpeAxx4pes/Yoms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdzOr7Q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdzOr7Q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E592EC113CF;
	Tue, 26 Aug 2025 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213734;
	bh=+4gItVbcHxILRlqQvC+oBcBtXaKmDgUf9QSU7l7Z/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdzOr7Q2iHZykCF4SqfkvPDximFEJDesaQctALlPX1X0ZCSytT4kfdm5vG+UPYO9c
	 0Z2eYCfQhxSWR7kpKN5TkenNfPtbUbaf4BktrYLv8TODTS2Pux6X5+73eOM6FPAdhA
	 tRyPe6rd1fmSnHlbP4VbvmhJz1qVYZ2gu9qtUIow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/587] btrfs: send: make fs_path_len() inline and constify its argument
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826111004.674516687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


