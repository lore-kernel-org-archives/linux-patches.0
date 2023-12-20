Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19071482F0;
	Wed, 20 Dec 2023 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1a0el3u7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93251C433C8;
	Wed, 20 Dec 2023 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088732;
	bh=5SnQ8sbR2wE0FLyvaUQJBk261kFTHSvuPaayCKN3wX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1a0el3u7iNh1J7EIB9u7eMBuUULDanqhN49QPhUl3+a+OWf3r6Kwb7yBXl4l+qiel
	 czVEeoOly0KCV5kxQ9IIVJB7JLG9W/10OOrZ9wM7qBtFSV/M+BXpjeMBbw4cFRrVs9
	 i49G/M4j8n4G/WusvCIT8Iw/nPGsxI65mOZtKkI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 039/159] ksmbd: Fix some kernel-doc comments
Date: Wed, 20 Dec 2023 17:08:24 +0100
Message-ID: <20231220160933.125608330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 7820c6ee029548290b318e522eb2578516d05393 ]

Remove some warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.

fs/ksmbd/misc.c:30: warning: Function parameter or member 'str' not
described in 'match_pattern'
fs/ksmbd/misc.c:30: warning: Excess function parameter 'string'
description in 'match_pattern'
fs/ksmbd/misc.c:163: warning: Function parameter or member 'share' not
described in 'convert_to_nt_pathname'
fs/ksmbd/misc.c:163: warning: Function parameter or member 'path' not
described in 'convert_to_nt_pathname'
fs/ksmbd/misc.c:163: warning: Excess function parameter 'filename'
description in 'convert_to_nt_pathname'
fs/ksmbd/misc.c:163: warning: Excess function parameter 'sharepath'
description in 'convert_to_nt_pathname'
fs/ksmbd/misc.c:259: warning: Function parameter or member 'share' not
described in 'convert_to_unix_name'
fs/ksmbd/misc.c:259: warning: Function parameter or member 'name' not
described in 'convert_to_unix_name'
fs/ksmbd/misc.c:259: warning: Excess function parameter 'path'
description in 'convert_to_unix_name'
fs/ksmbd/misc.c:259: warning: Excess function parameter 'tid'
description in 'convert_to_unix_name'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/misc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -20,7 +20,7 @@
  * wildcard '*' and '?'
  * TODO : implement consideration about DOS_DOT, DOS_QM and DOS_STAR
  *
- * @string:	string to compare with a pattern
+ * @str:	string to compare with a pattern
  * @len:	string length
  * @pattern:	pattern string which might include wildcard '*' and '?'
  *
@@ -152,8 +152,8 @@ out:
 /**
  * convert_to_nt_pathname() - extract and return windows path string
  *      whose share directory prefix was removed from file path
- * @filename : unix filename
- * @sharepath: share path string
+ * @share: ksmbd_share_config pointer
+ * @path: path to report
  *
  * Return : windows path string or error
  */
@@ -250,8 +250,8 @@ char *ksmbd_extract_sharename(char *tree
 
 /**
  * convert_to_unix_name() - convert windows name to unix format
- * @path:	name to be converted
- * @tid:	tree id of mathing share
+ * @share:	ksmbd_share_config pointer
+ * @name:	file name that is relative to share
  *
  * Return:	converted name on success, otherwise NULL
  */


