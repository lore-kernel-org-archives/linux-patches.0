Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9310447A6B;
	Wed, 20 Dec 2023 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK521XxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63B3C433C8;
	Wed, 20 Dec 2023 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088659;
	bh=J35li6fPDT3lcYJ2rgNVgmXfq+H/a7XWf9/EvpHBMNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PK521XxIh45ImmeLJuh626AXKscciL0QXZVJClDpsFFC2IHOwo2e3tgMk4ZcMhwTX
	 TBJKQ35dATZhf6iNfqhhv1H8JOtiSa77Y0RLpQ2Gj2LfaUMpXSRPqcNg+RNp5EKpRi
	 th4GFk8nx07vpO8S9j+nDwOGk2k8LE8DZU8lxtxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 012/159] ksmbd: Fix buffer_check_err() kernel-doc comment
Date: Wed, 20 Dec 2023 17:07:57 +0100
Message-ID: <20231220160931.860732315@linuxfoundation.org>
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

[ Upstream commit e230d013378489bcd4b5589ca1d2a5b91ff8d098 ]

Add the description of @rsp_org in buffer_check_err() kernel-doc comment
to remove a warning found by running scripts/kernel-doc, which is caused
by using 'make W=1'.
fs/ksmbd/smb2pdu.c:4028: warning: Function parameter or member 'rsp_org'
not described in 'buffer_check_err'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: cb4517201b8a ("ksmbd: remove smb2_buf_length in smb2_hdr")
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4101,6 +4101,7 @@ err_out2:
  * buffer_check_err() - helper function to check buffer errors
  * @reqOutputBufferLength:	max buffer length expected in command response
  * @rsp:		query info response buffer contains output buffer length
+ * @rsp_org:		base response buffer pointer in case of chained response
  * @infoclass_size:	query info class response buffer size
  *
  * Return:	0 on success, otherwise error


