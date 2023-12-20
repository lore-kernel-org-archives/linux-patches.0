Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA08646551;
	Wed, 20 Dec 2023 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfp2VBlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE90C433C8;
	Wed, 20 Dec 2023 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088667;
	bh=GJoqUML2GYPQ+AQGougSyuXUmUIirN5oLHeYMWUVsUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfp2VBlhCMFaDlap24m9NJj3YzGO2amOkTDpi0Rc8Vf0+DSH0m3AAr0FSohmxuzoC
	 LBYT56gCpQs3w4y6UHDyB1yufB3Lfzqc8TF0VcvXte/FxLZJwRQVOqrCCpHQ+sE708
	 9pRBwYZpePqoqky+Re9/UjBIqYTkI8GguXu4JJb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 015/159] ksmbd: Fix smb2_get_name() kernel-doc comment
Date: Wed, 20 Dec 2023 17:08:00 +0100
Message-ID: <20231220160931.994660009@linuxfoundation.org>
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

[ Upstream commit d4eeb82674acadf789277b577986e8e7d3faf695 ]

Remove some warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.
fs/ksmbd/smb2pdu.c:623: warning: Function parameter or member
'local_nls' not described in 'smb2_get_name'
fs/ksmbd/smb2pdu.c:623: warning: Excess function parameter 'nls_table'
description in 'smb2_get_name'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -653,7 +653,7 @@ static void destroy_previous_session(str
  * smb2_get_name() - get filename string from on the wire smb format
  * @src:	source buffer
  * @maxlen:	maxlen of source string
- * @nls_table:	nls_table pointer
+ * @local_nls:	nls_table pointer
  *
  * Return:      matching converted filename on success, otherwise error ptr
  */


