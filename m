Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475774C3D0;
	Wed, 20 Dec 2023 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCbRrRnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84653C433C8;
	Wed, 20 Dec 2023 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089077;
	bh=bSOO3K+NBeyMQe96wXlfmLjK0nnZAwbI6An90I26Bfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCbRrRnRHe0H+zzUuN4pWzKVS2PFuJJzy3rxvmQzWp+mYnp0JgqSKIRbgH+YbypDG
	 uuayyqx3Q34lfHcCNTUAVDvAy8OQoQ0Ks1v04dUIV8ZoZkkxyp7EVbnIq/wYPvdk6Q
	 /hqWZzB9mDtZWiunOAJ8whOl2M3vuP0RZH3rQBp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 123/159] ksmbd: Fix one kernel-doc comment
Date: Wed, 20 Dec 2023 17:09:48 +0100
Message-ID: <20231220160937.066374075@linuxfoundation.org>
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

[ Upstream commit bf26f1b4e0918f017775edfeacf6d867204b680b ]

Fix one kernel-doc comment to silence the warning:
fs/smb/server/smb2pdu.c:4160: warning: Excess function parameter 'infoclass_size' description in 'buffer_check_err'

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4154,7 +4154,6 @@ err_out2:
  * @reqOutputBufferLength:	max buffer length expected in command response
  * @rsp:		query info response buffer contains output buffer length
  * @rsp_org:		base response buffer pointer in case of chained response
- * @infoclass_size:	query info class response buffer size
  *
  * Return:	0 on success, otherwise error
  */


