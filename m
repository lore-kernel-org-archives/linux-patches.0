Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622857;
	b=3jPpsTbPImusm9mQoDL3ylMieK6XnoFBFq79pjLhRTe7BiXiMBNa9Cm+01GcmPlUoNQs
	 20rJUJ6G/9zLzSjfnpKE7ZmkDqrSKpfgjIwFKyvdgxLnjH6Ue3vA4YCkGJqnfCrz/JLbA
	 NxgxfhMM/AyFzHTV4fRwWdq3EaOdulcFDtT/lf1oS1uKwsU173FuPvo7efNJpQMHXEQqY
	 /wzcvaKRb2fngREMzYfwgUob3VIt52G2pID74UxXNATL3Aarj0rL+MlV7BTfWcebSxaU1
	 E9+LVsF7xh5fdSJ0DZbwQD8kfLwbMj7lIf3++Zl9+A0J9Xyxnb8rHLyNpWN7Pd6x8vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJCJhyhQ04fWUgv62i6YWcWwGS4+XsabOtmbqZn/Rug=;
	b=XLQhq3dMrDJjKrK4FGLWcDphHIyrJCjw6FfRx7PCSdgWPGhx1ZWBtEBNf9+10Ci4GHiW
	 P13l1hdawrqFOOBnSPqGtKPmMc8XTWFZLEq2hXz0mUYDeQ75a850VH1Ik+IsR+ETs1Wfw
	 UH0LdNEphtZ0THN7xRNqkkDzukSJqstT3oqjfPIl6WulJVc3mlKirh5EnaJmSfm8Xlb5Y
	 s/XWdk8Y/7UKoYJFwx5M/qgIdNgMevjyyW9XKo+7GSbIwmidV9+3rm6YfD317XaJskgXS
	 Moxuji7N0PCUreMDwk/TikzggTEiHDdksz1DQLvgjkc0nqbsKIo3GHyDarq7Y++CwBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWOagElZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E051A606A31E;
	Wed, 25 Nov 2026 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWOagElZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C65A1F000C0;
	Wed, 25 Nov 2026 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622856;
	bh=tJCJhyhQ04fWUgv62i6YWcWwGS4+XsabOtmbqZn/Rug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWOagElZDOmbHLAXDNurV45BpN/PrbxdXsLHDLYestuOAvYrh8tCLn+vn3mGN2a46
	 e1NmXKtw6xAJRL93Lp2gZZXqh8Rq6B6IUIrBoMVxJIm64TVsRUXXjxIMbbJ5d0EEoT
	 Z154FGV2r4E4FD6dZ41600Eu2rPlumYKgOPHr+D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 670/990] backing-file: pass RWF_NOAPPEND to synchronous writes
Date: Wed, 25 Nov 2026 15:33:57 +0100
Message-ID: <20261125143837.781906357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit afa735786a89bde4959db52f20e3579de54ec740 upstream.

pwritev2() with RWF_NOAPPEND ignores the offset and appends the data on
an overlayfs or FUSE passthrough file that was opened with O_APPEND, and
the call still returns success. The flag must make the write go to the
given offset even though the file is in append mode. Any user who can
write to the file is affected, with the default mount options.

overlayfs and FUSE passthrough forward the reads and writes on their
files to a backing file on an underlying filesystem, through the helpers
in fs/backing-file.c.

The flag works for the file that the user opened: kiocb_set_rw_flags()
clears IOCB_APPEND in the write's kiocb. It also copies RWF_NOAPPEND
into ki_flags, as it does with every RWF_ flag.

overlayfs and FUSE passthrough then pass the write on to the backing
file. They opened it with the open flags of the user's file, so it is in
append mode too.

For a synchronous write, do_backing_file_write_iter() calls
vfs_iter_write(), which sets up a new kiocb for the backing file. That
kiocb starts out with IOCB_APPEND set. vfs_iter_write() is only given
the flags of the user's kiocb that are in BACKING_IOCB_MASK, and
RWF_NOAPPEND is not one of them. So nothing clears IOCB_APPEND again,
and the data goes to the end of the file while the call returns success.

An asynchronous write reuses the flags of the user's kiocb and is not
affected.

Reproduced by calling pwritev2() with RWF_NOAPPEND at offset 0, on an
overlayfs file and on a FUSE passthrough file opened with O_APPEND: the
data was at the end of the file afterwards.

Fix this by adding RWF_NOAPPEND to BACKING_IOCB_MASK.

Fixes: 73fa7547c70b ("vfs: add RWF_NOAPPEND flag for pwritev2")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261101123440.3184069-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/backing-file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -114,8 +114,13 @@ struct backing_aio {
 
 static struct kmem_cache *backing_aio_cachep;
 
+/*
+ * RWF_NOAPPEND stays set in ki_flags.  Pass it on, because the backing file is
+ * in append mode as well and a new kiocb for it starts with IOCB_APPEND.
+ */
 #define BACKING_IOCB_MASK \
-	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND)
+	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND | \
+	 (__force int) RWF_NOAPPEND)
 
 static rwf_t iocb_to_rw_flags(int flags)
 {


