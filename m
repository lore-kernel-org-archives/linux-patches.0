Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621346;
	b=sQwpJUy6jvrWboHIzN4qYKYEDxhaCDDyZMcvXw+etPH2b12hZuroF9jfcu66a57AYVAC
	 Y68Z7fmblIPV7A1+WVJGazCg6IzG3RyasfcA2lHzVzFC5uEwN4Ijs/rBdMfywaBO6qWBa
	 X4ccfb8e8L1b1sFljZPPoP+o8XS2/RqRrA1y6KDh7u9xJWtNIbT/lUjoqY1qbv5+a0nwK
	 7ZT1PRJB0Sb9T3bFTgHN0Ag4Zx1V9ZQ6bqJtzwpuOz0l+Fiw+LdCzUxLGlmujiIhon67A
	 1LVMlBAqpzrW3vgpoFAMhb5gkZGAk2v2mX9vbGUdoa1ad0DD/9lSUBOEEuRyDqhKOhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=df/djVT+1bthwR4fxUTjbIgv4XF9II/+bxZHvpwVj9E=;
	b=qJcHPOUrIhFXmGxdmrUF/Z4mumXKWtk63Q4+VgwnREPg1ovlWR3j/lW74M+uh0ZrPwwu
	 ZYhVEwBUnudgchaC8/KxjnykvTyc3W1x3UEFAfTXCWfFRugx7ZVOfAJa8XUC7jVmCpQRa
	 LbmaGMDfaN2hbhpHbcawJ4IU9sPF5Jbzgh7Cvf9QmPqe4NuNjS6UyGDQDRV5qEECIv1s9
	 hF4KxXv6olcPb26qCYlj2nnEgLvAVH++v/NUcZkAiOfCkjhmYc/XV52p0zRp+04wkkxFW
	 bzYgg1JMYJErBgoKBQBqrY8TBFVr2Tic5aZvIkE4nx5zhO4PlGs2yz1wM0k6bHFjyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fKf5z/U7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797C606A69A;
	Wed, 25 Nov 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKf5z/U7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EF51F000C6;
	Wed, 25 Nov 2026 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621346;
	bh=df/djVT+1bthwR4fxUTjbIgv4XF9II/+bxZHvpwVj9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKf5z/U7S4+ztPGor9eSd+ivgXSEoSeDAh8QA6PhzwK8YtUluaMc8vEMRC2cZ6vYg
	 Q2chs4j7YuYQSpjprY5CcPiZCQVRKxKJQ3oh+KBGkRgPqcR/7657TEBnfpadkYo6Ni
	 yjBq2JtSRvll4VRr7LqdVAV49nPw3KNXINOji1UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/990] ksmbd: require NUL-terminated EA names
Date: Wed, 25 Nov 2026 15:26:03 +0100
Message-ID: <20261125143826.686176385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 56dc2134d8bac..53094243d456b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2453,6 +2453,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
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
@@ -3935,6 +3940,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		else if (rc == -EBADMSG)
+			rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV) {
@@ -6967,6 +6974,8 @@ int smb2_set_info(struct ksmbd_work *work)
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



