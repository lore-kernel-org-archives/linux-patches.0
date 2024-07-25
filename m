Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF019D88A;
	Thu, 25 Jul 2024 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919270; cv=none; b=lBQzvXBn+a8yNsIj/Gz+nkYoz+Z4/SeMxLTM1oyqQ/tB9Zj8IBJUI6Pjfbnqyj3lM74zmvzhlOBmNAazN4CSrhNiojYMD6fbas2vd/TgE3AJLci0s/PSfwndPAkk9P1SkGt7JUqyflLXnQ/5CvhBtc/oZJaBnugd2gRQO9BQCf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919270; c=relaxed/simple;
	bh=ncLp7LoiqHfZxeSppL545j58aCJCUJO8sMbypT1BwEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioZxZKX99MM/Pzo63FUjLPuNoyNfo/TK1PZmb/DIHNnOJsIv6fFZ8K+qqgttfpK9pnvDB+S7/2LxiF5Fu0yQx9IvckRcvGLmxi9W9J/hCrNYeITp54eY+k2wSWC570q60r30iJjTZjNlQX0x6U5wKEX8ZvVPjGwN/bABmCpHyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSqY5zOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSqY5zOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB1C116B1;
	Thu, 25 Jul 2024 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919269;
	bh=ncLp7LoiqHfZxeSppL545j58aCJCUJO8sMbypT1BwEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSqY5zOUCxxLYnrI0LOyk8Pllo1AoL82kT2KYSUycC7SscA0pAEVRPP+IXszOlXTg
	 aln+2QpvghVZtPpoQMWdAeJFO7MQ1e5i8yPWHLys0vNg9ZzrOG+RtRtM7oYmzmUSNF
	 J+OFIFounDkds5vWHf591U+/OuiWCEE6p34RCGwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 76/87] docs: Fix formatting of literal sections in fanotify docs
Date: Thu, 25 Jul 2024 16:37:49 +0200
Message-ID: <20240725142741.305737757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 9abeae5d4458326e16df7ea237104b58c27dfd77 ]

Stephen Rothwell reported the following warning was introduced by commit
c0baf9ac0b05 ("docs: Document the FAN_FS_ERROR event").

Documentation/admin-guide/filesystem-monitoring.rst:60: WARNING:
 Definition list ends without a blank line; unexpected unindent.

Link: https://lore.kernel.org/r/87y26camhe.fsf@collabora.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/filesystem-monitoring.rst |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/filesystem-monitoring.rst
+++ b/Documentation/admin-guide/filesystem-monitoring.rst
@@ -35,9 +35,11 @@ notifications is Ext4.
 
 A FAN_FS_ERROR Notification has the following format::
 
-  [ Notification Metadata (Mandatory) ]
-  [ Generic Error Record  (Mandatory) ]
-  [ FID record            (Mandatory) ]
+  ::
+
+     [ Notification Metadata (Mandatory) ]
+     [ Generic Error Record  (Mandatory) ]
+     [ FID record            (Mandatory) ]
 
 The order of records is not guaranteed, and new records might be added
 in the future.  Therefore, applications must not rely on the order and
@@ -53,11 +55,13 @@ providing any additional details about t
 identified by ``struct fanotify_event_info_header.info_type`` being set
 to FAN_EVENT_INFO_TYPE_ERROR.
 
-  struct fanotify_event_info_error {
-	struct fanotify_event_info_header hdr;
-	__s32 error;
-	__u32 error_count;
-  };
+  ::
+
+     struct fanotify_event_info_error {
+          struct fanotify_event_info_header hdr;
+         __s32 error;
+         __u32 error_count;
+     };
 
 The `error` field identifies the type of error using errno values.
 `error_count` tracks the number of errors that occurred and were


