Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618260;
	b=Tx6thzRzqX9SQ0O/exk1Hm3+YzZ2zjN2PHrVqm86v6zeJylucD4EvHIZ/oI/Sn+AqfPM
	 yWS1f2eUBDttx9SHd+XQT7Rf10BIXExPEKMofDUB+RfjhrlR1UD9wzdqvPfCDMfI0tugq
	 R6NTxbRhKoN/0Enn50xZRymCTqCWz6E2ymK2YerOj/1/eyP57oeDCizgNfpJHcY35zHyI
	 FmbRAsm4DwT59BnzxNH+2xYv6Y7wkAW6VkVxLMiVDNoOk429cUovmizfmxnJLfnt77Zdw
	 NY62/ri9bEmpIRJQQjSGXS3lA6zweEGPnmmT7G4RHnT61VSiZAJIt/W/KD01yNmWNnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2MEJGFdytzJm94R1vMNmBT73fd8VqkY+8KSFnglP9s=;
	b=GHIQCrAPSNAADlg434K1ixJaiod4Q3xoRwV2rdojVpsgPPNZifaFjm/bOoTe598SAtyp
	 zlcw1ePltYPHd6iheYjv5E4o4P2au7/evTUZhaX90AYq894csT9uCIOCSCK0UiZ/CcMhF
	 atHskUY6hGqcPP1+rxEU48njTyLCNLfsgHXedeGH8I4rgaoEv1DDNr+i/SLNAutB4qhjA
	 4LTBOJKXkB2QTIlEr3frXVIuvnaiodF891njRkWIuOZ1juGjCIpzSoiP0iwvNiABA4me2
	 kd8U+CAH4ZVsOyJGmNNOGN894+FBjG3HncozMoZgkuyI3hhJMJd0X8erkZdMkX4uH3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o39OeZQs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6960A606A327;
	Wed, 25 Nov 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o39OeZQs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331F61F000D3;
	Wed, 25 Nov 2026 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618259;
	bh=O2MEJGFdytzJm94R1vMNmBT73fd8VqkY+8KSFnglP9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o39OeZQsQamrnLmS0uzfAJGnnEB9WoaynNg6eAVGh7rEQVp1BsD0ubF9CI2pK10FM
	 gPaeeqfBDIIFctV9uWWFPYBTucY/G4fd7Qbwy0DvovrB2ID9y9QYV5XShuJ+ryEfsk
	 1ZHFQYaFcrTXsDD3WZ7yS9G7xBI1JCQgzZLc0j78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0224/1005] ksmbd: require NUL-terminated EA names
Date: Wed, 25 Nov 2026 15:26:02 +0100
Message-ID: <20261125143826.989343959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 828e2cf1dda54..b64458247b160 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3439,6 +3439,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
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
@@ -5622,6 +5627,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		else if (rc == -EBADMSG)
+			rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 		else if ((rc == -EACCES || rc == -ESTALE || rc == -EXDEV) &&
@@ -8974,6 +8981,8 @@ int smb2_set_info(struct ksmbd_work *work)
 	}
 	else if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (rc == -EBADMSG)
+		rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 	else if (rc == -EMSGSIZE)
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 	else if (rc == -ENOSPC || rc == -EFBIG)
-- 
2.53.0



