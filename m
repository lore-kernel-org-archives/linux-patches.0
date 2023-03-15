Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC199C433EF;
	Wed, 15 Mar 2023 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883082;
	bh=wswBbSrwa8JjBe6E9+BaQhbBFZhBl1rn9lYjdZk1ZhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUKHWDDZzNpTGz+ENL8IfekjvL/gHMqn88xAD1XoHEh7GOMccU3XQGA/e0ksRKzRk
	 84QQOwqesLos6BixLRRrVOGWIZAaVRGOn5c9WWjuxjQ1I5yd6B6HVmXlmDIe+OhUeM
	 bLX7Q/UQzv+xel1IFi3JmXam2Cb79OPFtnQKBroc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 001/145] fs: prevent out-of-bounds array speculation when closing a file descriptor
Date: Wed, 15 Mar 2023 13:11:07 +0100
Message-Id: <20230315115739.017739785@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 609d54441493c99f21c1823dfd66fa7f4c512ff4 upstream.

Google-Bug-Id: 114199369
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -646,6 +646,7 @@ static struct file *pick_file(struct fil
 		file = ERR_PTR(-EINVAL);
 		goto out_unlock;
 	}
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file) {
 		file = ERR_PTR(-EBADF);


