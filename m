Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705071;
	b=HO1elBpsHnKQUMTP6mqVZWHl8Vj7DT5aU3lWQm+2r/hFDMP4Be+algGIHPRIaAWpeujH
	 3be2t3iACPLlRjbjxnV4yysnoODn5jLVMQu4ZSms/9YHTvtFd9/sxBeFQQZsUx3fqsQLG
	 OP7nrAXN95xk4+G8TOc/+f1641VkZYaPdmqB2/oJwmWUG/uPjaE7RVE3Mo+2tR5ts0lua
	 /4P4+tnB3JiNMmtclfqfGEQVy7jxtspt6yL65SRDn7FIU34ITbbBDE9BkBcYsW0+FZGnK
	 j6r53tAY/RWNEUGk/YE7QIPVp1Q6TCQJ73WCkBWLEf33A/ubuXxvffYbmV/MHXuJ68Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtY3IaQV9TGdeqzPxAj+IkhCFUarohAWu2ZKlPlOZcs=;
	b=ArDlt8A75VTSoK1RfhmeUQgjIIkDmnGJsn0LcWtn36A8uZFIWNVXy2j+gMTp86XuU6R8
	 7RA99jcwXeh4SKvhKZwmrF/PGuXEv/BI28Nucf5qJq8oRSrnSuhRgPbSu4z2os//qzxY3
	 WmoEolZUeeErAW6eM0vWcWnBPFMsjX9KqZpKSbki7zTj3FG5AYMIftYpyo8OsQiYpR0ri
	 Rd07d66oc9UgL0HeKfoscnIiaO4eF8M16zN1l1fiWowViw3tGi8QmdcLvu7HFlH+mxeZ7
	 N7+uE+5WNrtr3nAWHu6DA9mFtE1D4iodPJMUzHb2iQd6LdDHuKhtfpbC5gzRfWqTBTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Glsglfnb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B427606A69D;
	Thu, 26 Nov 2026 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Glsglfnb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F83B1F000D3;
	Thu, 26 Nov 2026 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705071;
	bh=WtY3IaQV9TGdeqzPxAj+IkhCFUarohAWu2ZKlPlOZcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlsglfnbHFEIV1cQjuR5vqwQEaNgmCuixyUw9O8MjC6GtF5gvKoyycnETStI2ZFro
	 +RUihtYpLCOFpqL0l8g4ozfD8sT6GhORRUfS88YuDem8PuzS2G+j3jAglV++cUAYOL
	 CJ69D2StJ517v2QZjiWWsu7SRvCuDb+FJXiQSHA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/319] ksmbd: require NUL-terminated EA names
Date: Thu, 26 Nov 2026 15:37:19 +0100
Message-ID: <20261126144008.342605385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

[ Upstream commit e49296d51ccbf2ad0ed0484db1382f1d7217bd6e ]

smb2_set_ea() verifies that the byte reserved for the declared EA-name
terminator lies inside the request, but it does not verify that the byte is
zero. With SMB debug logging enabled, the name is passed to %s and the
diagnostic reads beyond the request allocation.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  smb2_set_ea
  smb2_set_info

Reject an EA entry whose declared terminator byte is nonzero. Return
-EBADMSG for the malformed buffer, and map that error to
STATUS_EA_LIST_INCONSISTENT for both SET_INFO and CREATE.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e992775476981..bb4695b61ec39 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2425,6 +2425,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 		if (!eabuf->EaNameLength)
 			goto next;
 
+		if (eabuf->name[eabuf->EaNameLength]) {
+			rc = -EBADMSG;
+			break;
+		}
+
 		ksmbd_debug(SMB,
 			    "name : <%s>, name_len : %u, value_len : %u, next : %u\n",
 			    eabuf->name, eabuf->EaNameLength,
@@ -3574,6 +3579,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		else if (rc == -EBADMSG)
+			rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV)
@@ -6293,6 +6300,8 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	else if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (rc == -EBADMSG)
+		rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 	else if (rc == -EMSGSIZE)
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 	else if (rc == -ESHARE)
-- 
2.53.0



