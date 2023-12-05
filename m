Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7779E3;
	Tue,  5 Dec 2023 03:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF53grQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D8BC433C9;
	Tue,  5 Dec 2023 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747072;
	bh=ZbCoe+v8/EPTiUdxu0V0P/jFY/ZzZGrhSTxTn+QC90w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF53grQwVZM32FqNGdicWLLDC7805/bGY8k1XK5iusUoEjDGVO+pIUHjbU8LpMcsE
	 ruw/ptUQnjPWuGeSSPMjguVHEpUVgVueGb5IcRynLqctimME6oVccz4ZvqqJR3dBt2
	 3lwcXrV+80blcixdsjkTyBmQnAIgIzeInj5UhIhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 049/107] btrfs: fix 64bit compat send ioctl arguments not initializing version member
Date: Tue,  5 Dec 2023 12:16:24 +0900
Message-ID: <20231205031534.371336755@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit 5de0434bc064606d6b7467ec3e5ad22963a18c04 upstream.

When the send protocol versioning was added in 5.16 e77fbf990316
("btrfs: send: prepare for v2 protocol"), the 32/64bit compat code was
not updated (added by 2351f431f727 ("btrfs: fix send ioctl on 32bit with
64bit kernel")), missing the version struct member. The compat code is
probably rarely used, nobody reported any bugs.

Found by tool https://github.com/jirislaby/clang-struct .

Fixes: e77fbf990316 ("btrfs: send: prepare for v2 protocol")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5236,6 +5236,7 @@ static int _btrfs_ioctl_send(struct inod
 		arg->clone_sources = compat_ptr(args32.clone_sources);
 		arg->parent_root = args32.parent_root;
 		arg->flags = args32.flags;
+		arg->version = args32.version;
 		memcpy(arg->reserved, args32.reserved,
 		       sizeof(args32.reserved));
 #else


