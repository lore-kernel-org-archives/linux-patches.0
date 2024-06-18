Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F1145353;
	Tue, 18 Jun 2024 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715710; cv=none; b=Z8EaGxG8RmFoQgQgUssNp6jtEyfHOoMJRxXGj0bfaF74TQZZmmOQJe0Z4jPX4i55+7piDkCXJ0D6hJwslQ7SR+BLR/KW9WybH5uYOJU8PIa9QmiwkuzErtpQaozp06vnBTJBrK7FNaCsq5XfzCIVM6aPvtayCmIhzRRwWTDln6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715710; c=relaxed/simple;
	bh=XPBkI1rbg+tO7GIcpezyT8u7CBfIdDdN+O+5KD7B8l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng17qVcIl2doYkOnzMzma2ROUvFFyXp0M28DJTSy6rRO4bLC9pC6ZyTc572z9Ig5J71+HZNLdae4KfYDrOTR0MYx1aLqRXPYu1/cxakAKCe5zOf+GuO9PdkkibF6nds7Cj1Hx5+OJm1D7LAxs84EG6mM1OmJ9XpbIzhf6Xav8kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXasUAU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXasUAU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08477C3277B;
	Tue, 18 Jun 2024 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715710;
	bh=XPBkI1rbg+tO7GIcpezyT8u7CBfIdDdN+O+5KD7B8l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXasUAU+zC9CzBki0sTRtRiokftRPcqJblJvoU2UyRisVeIqWyqrRSnqB6VboaX3u
	 kblXOAJQpX/U20Hov+6M3IL28LTIe99IGzjdqTZKAm5qhr2mVF2ZcVP+JKJqwkoZy9
	 yWuqQsXIGRzyKH6ZdeRtI/X7HtM0jL+vlA8sLT44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Frank S. Filz" <ffilzlnx@mindspring.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/770] nfsd: update create verifier comment
Date: Tue, 18 Jun 2024 14:34:13 +0200
Message-ID: <20240618123422.722630320@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 2336d696862186fd4a6ddd1ea0cb243b3e32847c ]

I don't know if that Solaris behavior matters any more or if it's still
possible to look up that bug ID any more.  The XFS behavior's definitely
still relevant, though; any but the most recent XFS filesystems will
lose the top bits.

Reported-by: Frank S. Filz <ffilzlnx@mindspring.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 05b5f7e241e70..5b0abdf8de27e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1431,7 +1431,8 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nfsd_create_is_exclusive(createmode)) {
 		/* solaris7 gets confused (bugid 4218508) if these have
-		 * the high bit set, so just clear the high bits. If this is
+		 * the high bit set, as do xfs filesystems without the
+		 * "bigtime" feature.  So just clear the high bits. If this is
 		 * ever changed to use different attrs for storing the
 		 * verifier, then do_open_lookup() will also need to be fixed
 		 * accordingly.
-- 
2.43.0



