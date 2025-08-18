Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CCC345729;
	Mon, 18 Aug 2025 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522967; cv=none; b=ix3J2FoaYvxzE69CQzMo64yodOXZ04j57pypz6eKhD7BxM91oTgrzXWPYNJFSBZ0hakP1ntbDiKc+AJOIAOZR8tae1RNdfpn3G+bH6qCWxGv4Fogca2Z+mCbufem5NMulDwU9fa8IxXQf6uxT24VycvIwl6EF+F+SDbosskqzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522967; c=relaxed/simple;
	bh=XmNEorMnkkrYe1owlgn1KbRjkc+Fzy2Ou3Sb4kO22c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx9N1a0Fxok/l5RWL4fFhdGsrW4Qwip83vhEu0aUUk4nlvQEdvZcACJHCVYihJy5TJLJbyPgicnuJiyuaiQwDtda9GW9TukgNXaYTcKpQwuhxUOEXQ2tsr1NvEHncqZsEc9T2i9vYeoxLnnQVsA/lbDvA5z1Dhjm0RnAvVwzSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hE/vspl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hE/vspl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8CFC116C6;
	Mon, 18 Aug 2025 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522966;
	bh=XmNEorMnkkrYe1owlgn1KbRjkc+Fzy2Ou3Sb4kO22c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hE/vsplyJxJMim1gd2pVFEcTe/nSPT5D7mo1xlrI+EcW/3zI1IRbj+Q5S0dijlBn
	 Xtpyll15dru4GKFNxlhD+YoAvD8uM9SLJ2RHL4mI8AwUluDW3SjUleSXGqSGS1hsw1
	 PgB0wFndCeJtHwRBHhOn4/BOCznN2Mi5I9EqAtLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	stable@kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 029/515] fhandle: raise FILEID_IS_DIR in handle_type
Date: Mon, 18 Aug 2025 14:40:15 +0200
Message-ID: <20250818124459.579233360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit cc678bf7aa9e2e6c2356fd7f955513c1bd7d4c97 upstream.

Currently FILEID_IS_DIR is raised in fh_flags which is wrong.
Raise it in handle->handle_type were it's supposed to be.

Link: https://lore.kernel.org/20250624-work-pidfs-fhandle-v2-1-d02a04858fe3@kernel.org
Fixes: c374196b2b9f ("fs: name_to_handle_at() support for "explicit connectable" file handles")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fhandle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -88,7 +88,7 @@ static long do_sys_name_to_handle(const
 		if (fh_flags & EXPORT_FH_CONNECTABLE) {
 			handle->handle_type |= FILEID_IS_CONNECTABLE;
 			if (d_is_dir(path->dentry))
-				fh_flags |= FILEID_IS_DIR;
+				handle->handle_type |= FILEID_IS_DIR;
 		}
 		retval = 0;
 	}


