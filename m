Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1546551;
	Wed, 20 Dec 2023 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKczb+U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5C6C433C8;
	Wed, 20 Dec 2023 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088661;
	bh=TRPEKAi7pD1k+rc5XdZICvRAlsC5hV6RWToqEwVygD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKczb+U/txAUIWbjjiIqspTZcpnPFhpXaKupk3HjPpLsNQY4eYyl4dKzx2qSO//zJ
	 4dtfKHWbfQyPn3QA3m0rPuNu5439BMqRXYkOBidLLlRln1rxAi8QL6LcFwislqBRLe
	 YD1iVrN/7yWZh8+bBb5jCJH2TAY/8gHmKwQifNXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 013/159] ksmbd: Fix smb2_set_info_file() kernel-doc comment
Date: Wed, 20 Dec 2023 17:07:58 +0100
Message-ID: <20231220160931.900168144@linuxfoundation.org>
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

[ Upstream commit 4bfd9eed15e163969156e976c62db5ef423e5b0f ]

Fix argument list that the kdoc format and script verified in
smb2_set_info_file().

The warnings were found by running scripts/kernel-doc, which is
caused by using 'make W=1'.
fs/ksmbd/smb2pdu.c:5862: warning: Function parameter or member 'req' not
described in 'smb2_set_info_file'
fs/ksmbd/smb2pdu.c:5862: warning: Excess function parameter 'info_class'
description in 'smb2_set_info_file'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 9496e268e3af ("ksmbd: add request buffer validation in smb2_set_info")
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5932,7 +5932,7 @@ static int set_file_mode_info(struct ksm
  * smb2_set_info_file() - handler for smb2 set info command
  * @work:	smb work containing set info command buffer
  * @fp:		ksmbd_file pointer
- * @info_class:	smb2 set info class
+ * @req:	request buffer pointer
  * @share:	ksmbd_share_config pointer
  *
  * Return:	0 on success, otherwise error


