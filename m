Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061667;
	b=tI8CBf5jjnXTAYJMZPdXY4SYJsO8/Lyx8JDwECZGSachLavNSJ6LvRvGjGhQ4leLAumg
	 2pKO1PecVa+CQyQgbmd+ph41HEB1nvxE0cIvIoWG3xEQQ88hx6UMQGdahvW9IgfxLHFuf
	 9rxPg/ezzfTa63KNlA5d+nP0TGxbNAWDq9eNaajMPwneTGM15rLBFhC1skBmUuZrhfK/G
	 VULvDT8i9cYvIfe8N7edB9nbOvWW8eEqEZqkoQNb7A0q+k4QNxl5jn1es9LS6XWSYftT6
	 NUpufzY9RBTQclTscF9A/XwktvFW5UgUHhrnFPGBDRx1LLwCTL2QC/tFgA44ZyfL3Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AdTlvX2Q0yqw2AJb3BZtUpQfO6yBx0JhvrWQmr7WTvw=;
	b=JXCrmXXt6UjCipOcRoi365WUqNec8FsSIaKwT0HxOIkLwTHLstVeq9e3VrNJmSh4K8nf
	 6VOPQvaXi2o7nVZOrfo62WVV/RWimMTnSIqlinQHAyOMBbQxlW590gUGWXl8bkIxtHEXI
	 GKZ/9NgD4nuKlz5GJ4N9bl7nTAnEijFF80EVBlMzYgkftXURRnP2mpNdMVUJamhGp73Y3
	 6I6jlgnOhYLdvH9a5TpBPP9B7fUEW1AUnFfMu2nEj9mRohJWIKEVHJ+Rj1U9ZIqVFK9mN
	 TLiv4CZi4E4LVXdxI6x1gVPS209QlIF3NqfJmTalMbrTUxhs9WWvaSZeq5bA15nzZsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/UTAKvs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDB5606A331;
	Sat,  7 Nov 2026 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/UTAKvs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8C11F0089F;
	Sat,  7 Nov 2026 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061666;
	bh=AdTlvX2Q0yqw2AJb3BZtUpQfO6yBx0JhvrWQmr7WTvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/UTAKvs2Q2Z6iisqw2nO2PFzGsUOFjrJ3+XKBJR7YHtzdOJIM69y5DQswSDHbp0+
	 pmI80MRpvOEGL63m5l2+qSUKOAyJKT+5+bPWidde9nPEDmZ7LnARBr/JCvfepm2v2h
	 5njdunCoW7CsewTtqE+spiWiqlazJgjveGeNZUWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0722/1536] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Sat,  7 Nov 2026 08:45:38 -0500
Message-ID: <20261107135017.777426267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fd012955641881169a9f01a00f656f6ca73842ec upstream.

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: stable@vger.kernel.org # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c          |    6 ++++++
 fs/xfs/scrub/parent_repair.c |    4 ++++
 2 files changed, 10 insertions(+)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -216,6 +216,12 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -914,6 +914,10 @@ xrep_parent_fetch_xattr_remote(
 	};
 	int			error;
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
 	/*
 	 * If we need a larger value buffer, try to allocate one.  If that
 	 * fails, return with -EDEADLOCK to try harder.


