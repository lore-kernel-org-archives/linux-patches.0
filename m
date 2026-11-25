Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624376;
	b=WN42/ls7OViVo7Ibbnid756MMUczuaEFiEU2eVO6xqkBYhZSre3xQzHXfySsSxxSUEJf
	 Jgk1SpUG6OPIZzyFZB1AG13bcr/0rKBkqSjoS0YbmbZ5GfXWZg40aPcgKXOjWsABO99Ff
	 YMhzh6AyzNXiYGE6o7oLOL2oE5OPEvyqGLAxKhUlcL7nO6p+fk36kejq9SidoCCuNOlEd
	 JcTdq/ptX2e1XQqEkaLzwoaS3g4yNxXL1pd4GaAYIlHrNECE1jGl3uWquUvAdHfotSGME
	 /y9CZzRNXCMMB0g+Ab7ZhNjDtWyrcc9YAZk/Rn2r1T91Wqx3YQdVjmzqpsIug6sAmmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bJmVM4B73QFKhT1PpCaTyMRTgoUnGKdhO4JM9PePR10=;
	b=qM6/Uy0bQjzkpQCUiRi+XA0kUpZCstjpcFa1S5F1uOVPHu4Jfsnhh/nJsreyK6rNQ7UT
	 +R2Zrs1wwLBvU8YSLKD7OpqHlrnlRIsIJJPRwWBsM5DdF+4uWLQM0tYtGJ+/jPlkTgRhx
	 lhOiqQGqqEZxD62yqdGilwP1GuO+oecYd7OUSJfHiqKrGVteHUGVgGrnZlPnpfMRzpxYv
	 dshTDT04Z/coDm5KyLHzEWBL2qERfyFoDe2SeXzK8jK2HMGFhE43jXtqfIJBTrxlDzblx
	 3BeCtO+SEGO9t4KlFMW5x7HhMswvP3jnUCNjbNi331qP+UhhITdrweRc8/+MxFZISPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b225LIDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74207606A698;
	Wed, 25 Nov 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b225LIDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6CE1F00AD3;
	Wed, 25 Nov 2026 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624376;
	bh=bJmVM4B73QFKhT1PpCaTyMRTgoUnGKdhO4JM9PePR10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b225LIDn0tvoPK9UVNT8faDFv9cY8Nh8zqnqf62cMD/i/0ixRjRc3MYm/s3h3b6AD
	 cYv2qj5TG87h6XdtCXoNbhKtwLW6xWOqrfiPsPo4LepVvKGIR6VG6DRWKeoXH1yC+z
	 +Uikqe3O5orN77jrEsdYqJGVhz8yfsjer6CNO+ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/816] ksmbd: require NUL-terminated EA names
Date: Wed, 25 Nov 2026 15:28:39 +0100
Message-ID: <20261125143853.151871923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 688f78254b7bf..e65fe5858a51d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2460,6 +2460,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
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
@@ -3924,6 +3929,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		else if (rc == -EBADMSG)
+			rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV) {
@@ -6912,6 +6919,8 @@ int smb2_set_info(struct ksmbd_work *work)
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



