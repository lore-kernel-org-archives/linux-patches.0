Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044768;
	b=uh7x2hqhWexPqXR6tmKQY7bJAW/g2pHGHRm9KOgYxs3jKCubY5263b87cggeXEUrbd8J
	 OvL/Q/ZInqEtsvSeyvP14gIkEGT3ad2xWU7oWnc3JpuSPyLZShlqGq7cZg4LuQi9eNezU
	 DV5vg2v3Pb0BfQDr7y8bmJYD9v/r1kJAmV+tkN0ura41hv9vuQDXDmP6sVxvZ5NviVdor
	 ciciE6JzXN4y1L2Cz7QO6j9OcZVgjgTp9Zxn1M/eTlDXnOHTvfJm5PLXfDC4RILl9rwKB
	 PFZOovvQjJIX0h3JBSlHViMPT/EAEILf0KQS5WjkG/SWLw03EHvb/I9psuAkgttem4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=936XyHPnR0+nRux1UlgKl8S/sMcEKXyQN+pOr1MLa5c=;
	b=DR5m9jww/xoRuizenf8nvNG0mg6qeAxY9/maElWG9JZJdDGAryq68HYP69xBShqAUHXh
	 xdS49so3cm7rLW4FmA2sU1t0P3Ysi125bdty/2FIJZrK2xPDnjRosJQRz7/pYjfiuXfPT
	 ccum2P9tC3875jOC/W+qDz84st9aByD5laDXf2utBycDn8tsi9jJ8Sihogk+cMoSZKzXg
	 E8ACzZ+YxEr44P0YN7w4ySSq4xtthLoBaU2H7G7CEGK+lJm2mG9ik5pnuSPZN82IGHk11
	 z8RrruW+gEabwMktrVpOWPkwG6gQhhLCXXcsoxsLPQHNg2GyaiDhs8lKVKnhuvzCoPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIfnylM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909F9606A9CA;
	Wed, 18 Nov 2026 23:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIfnylM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9E91F000CF;
	Wed, 18 Nov 2026 23:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044768;
	bh=936XyHPnR0+nRux1UlgKl8S/sMcEKXyQN+pOr1MLa5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIfnylM2gcvZ8F2gRNA5mYBncAo9Su5hA9oWZeO4S3YLg/4AqwljkieYxwvaZLdpz
	 qyApv5LDF6ayJT0Aln3AoHuOBo28AQi7P2ZkyL6vd1MKfIeKsCiMrq5RwjEHNW1ySx
	 whXUrxhqt1Qyar5DhwRkx8/8uh9KdKEr5jZ4knL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0686/2857] ovl: do not copy up a dentry that was removed
Date: Wed, 18 Nov 2026 15:28:40 +0100
Message-ID: <20261118150226.256929340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a873bf4bac814..4736e21dd49a9 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -707,6 +707,13 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
-- 
2.53.0



