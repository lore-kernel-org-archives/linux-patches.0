Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624373;
	b=Tui1BPBV4KZzXmSIuobfKq4GFBeWTMjzUkIaJ4Au+q389+OwTdiBuckWflqn/47eKqI3
	 PIr1aD2mlaPTXtzALSuqCgnFnXoHMyk9CBc8RqMFWWX/tmp7uOtRyWjbiYaSyebVb36IN
	 B8d84WCERgzD1SfOqLcBXC/1TqusBzqxev0q15dHP1TXgNQfXxi1D+bkdLj+QoT2H6qN/
	 lPyS0UWxY5/l5d1r7W2JRnFYiswe1YDG4VWee3LOWnn2IcfoVf+oI5iI71CL6o0x8kAm8
	 ZoKnf/bzHZYZJyFCfjilJM6Hwvhm+u4PNHPgMbqqOIswY79CEb+7CvdbwM3qNRM5pxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkTsPpKE9pIqC6xw4BxSllB9GB1fOoFWMwuQO4SwHHI=;
	b=STdqHnSU6cgsroYtlDovbsDGDMTVSh8NEPinxTppPgD5m9+j32qcM8E5yPZRoS2rf1Pf
	 /ewW4chGTTVMBGyTUT4ESBHO0sSYnw1I6bEQpQ3q0oLd8jWs+x/XqkEd03AThFGq2vDTR
	 n+t7pdc9YqbA2KxLlAyV54N5JcuOi7VwWbPsUqTiHMeZyw/vRLtef46IKCTfZ15CUs9wW
	 wAkFyzBUKSyOisS69XMMJ94pbb4/fvhi2U2gGXJANqiH/Iv+qSm6rcWe5I8iIjbCzJI+4
	 wsAiZtT5l+9dUIiyVBwaODl25lPqaIHAXxPGBTA/jyq1TA5bZtGbTrTTlXHy9aj/0OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnb4BJiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1E5606A696;
	Wed, 25 Nov 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnb4BJiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832E91F000F2;
	Wed, 25 Nov 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624373;
	bh=OkTsPpKE9pIqC6xw4BxSllB9GB1fOoFWMwuQO4SwHHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnb4BJizoJHjZwFTm/xio8hgfiSGigTaWcosBMTIuJBCnKdastuyKlrnBeSZYJ7D8
	 yFi+ZLW0XYC5dJlmZlXA2t/y/9jdVhTzE1XxvebN9w+hX/FpQ5+Zt/BSyYOPN5LRwU
	 4XYyQgXNIkPvSwkRl+XEdXg4YNiUOFOHRNbctEu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaditya Kansal <aadityakansal390@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/816] ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server
Date: Wed, 25 Nov 2026 15:28:38 +0100
Message-ID: <20261125143853.129064242@linuxfoundation.org>
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

From: Aaditya Kansal <aadityakansal390@gmail.com>

[ Upstream commit e4442b2e95baf0901830c924d0a197b100aca970 ]

Add STATUS_INFO_LENGTH_MISMATCH mapping to EMSGSIZE.
Currently, STATUS_INFO_LENGTH_MISMATCH has no mapping to any error code,
making it difficult to distinguish between invalid parameters and length
mismatch.

Map STATUS_INFO_LENGTH_MISMATCH to EMSGSIZE while keeping the EINVAL for
invalid parameters. Although the buf_len check only checks for buf_size
being less than required, there was no error code for lower buf_size.
Hence, EMSGSIZE is used.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: e49296d51ccb ("ksmbd: require NUL-terminated EA names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5587687dd6a4..688f78254b7bf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6714,7 +6714,6 @@ static int set_file_mode_info(struct ksmbd_file *fp,
  * @share:	ksmbd_share_config pointer
  *
  * Return:	0 on success, otherwise error
- * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
  */
 static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			      struct smb2_set_info_req *req,
@@ -6727,14 +6726,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_BASIC_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_basic_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_basic_info(fp, (struct smb2_file_basic_info *)buffer, share);
 	}
 	case FILE_ALLOCATION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_alloc_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_allocation_info(work, fp,
 						(struct smb2_file_alloc_info *)buffer);
@@ -6742,7 +6741,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_END_OF_FILE_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_eof_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_end_of_file_info(work, fp,
 					    (struct smb2_file_eof_info *)buffer);
@@ -6750,7 +6749,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_RENAME_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_rename_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_rename_info(work, fp,
 				       (struct smb2_file_rename_info *)buffer,
@@ -6761,7 +6760,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		struct smb2_file_link_info *file_info;
 
 		if (buf_len < sizeof(struct smb2_file_link_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		file_info = (struct smb2_file_link_info *)buffer;
 		if (file_info->ReplaceIfExists && !(fp->daccess & FILE_DELETE_LE)) {
@@ -6776,7 +6775,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_DISPOSITION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
@@ -6790,7 +6789,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 
 		if (buf_len < sizeof(struct smb2_ea_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return smb2_set_ea((struct smb2_ea_info *)buffer,
 				   buf_len, &fp->filp->f_path, true);
@@ -6798,14 +6797,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_POSITION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_pos_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_position_info(fp, (struct smb2_file_pos_info *)buffer);
 	}
 	case FILE_MODE_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_mode_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_mode_info(fp, (struct smb2_file_mode_info *)buffer);
 	}
@@ -6913,6 +6912,8 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	else if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (rc == -EMSGSIZE)
+		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 	else if (rc == -ESHARE)
 		rsp->hdr.Status = STATUS_SHARING_VIOLATION;
 	else if (rc == -ENOENT)
-- 
2.53.0



