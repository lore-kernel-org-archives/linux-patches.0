Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622763;
	b=KwsYW/IHqMo1HLLXVm6e1dK+6PwdWSvKUs8TctvE881lI0OhmGaHYo6sPGrGZrA+nbcM
	 STYCWAKydUbpp/Ah+4t189aUWAPZ4m825jWegXTMmwiKyjPRcJ24fd1NxB0+8j01dT8DW
	 rGkljIwvNWmnAFe4RuBEmMTwlJFGDKEG7FQ2a1WCZR5/Pw+w7yiQPSPbbQ4YEu996axLN
	 ApuQ06fXuxu6Ln/UxW/vPTXnwF8UbaYhQ96rjWygfAk9TnNxBDXDt9xEom1jMgOgH8nzv
	 LG3pLefSSkY70IvNhkGDeMDTVAaViquwwMmLxty0ABoIDe5vzRCf8+x4USaAkKhx+Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRI1/j/MEUiGEQ0Y7EqziBsx7z5Eqo0KivxCfEK0LgE=;
	b=HcwEgmmYkzzhwdoEOhVrng+lc+EWsHeNfdqJ3YjrsvbGBtVOLcqU1UEMy7fG/Zt1NjIt
	 vK7z/itJAQr8xuJVTZtTEuncJCVM5d/PRLmQugQ8qREC9MCpxdQJOSNHsHOxH7VkrB8va
	 cE6FVc6g1au+jop0MVSoAkhCmrYhqPvpIw7FQueSQdrXoazBt3AH+wYaN9YcjT9w4FbjS
	 sDGy5NyAnaP+fbjyOVfVEGs9qqXOhyf7umXAHxTLCHhqaPt0kCdLQhr06ZPEgEwYlZQmK
	 VHHHNfNGinM5zI5OJo3i7zlTPffXPt6Fxc6uOfr4NIGB72vs9GCA/xvUFhJhNzaEX9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P70PYOah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E6606A321;
	Wed, 25 Nov 2026 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P70PYOah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2259E1F000C4;
	Wed, 25 Nov 2026 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622763;
	bh=XRI1/j/MEUiGEQ0Y7EqziBsx7z5Eqo0KivxCfEK0LgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P70PYOahZSOpM4h6gLHfhROEMUYK9r2qtBJXveIjkukLm7JrfrNpEQaHzIV1Ifp9z
	 hEPWzFQNEZ3CoEuNIVBHAee0mMdDdQ/g8D0b0BoqZx/4TcSmnGqoTr5nCYTUknItAy
	 Tbg8eNPczknyUcWnn2Sl7bbC1DI6cunsuBtJ3JCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 638/990] ksmbd: return complete and aligned stream information
Date: Wed, 25 Nov 2026 15:33:25 +0100
Message-ID: <20261125143837.038881639@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 206fc30f71b005156085fd8523ccc84a2c67791b ]

FILE_STREAM_INFORMATION responses are assembled without aligning entries
and truncated to the client buffer length after the fact. A short query
can therefore return STATUS_BUFFER_OVERFLOW with an incomplete entry and
a nonzero NextEntryOffset, which clients may reject as an invalid
network response. Standalone queries can also exhaust the server
response buffer and silently omit streams while reporting success.

Allocate the same large response buffer used by other variable-length
QUERY_INFO classes for stream queries. Pack only complete entries within
the requested output length and available response space, aligning each
entry to eight bytes and sizing names after UTF-16 conversion. Return
STATUS_BUFFER_OVERFLOW when more entries remain, using an SMB2 error
response if no entry fits.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
Link: https://github.com/namjaejeon/ksmbd/issues/522#issuecomment-6391152923
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Only the FILE_STREAM_INFORMATION case was added to the large-response-buffer list in smb2_allocate_rsp_buf(), because FILE_NORMALIZED_NAME_INFORMATION isn't in that list here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 183 +++++++++++++++++++++++++---------------
 1 file changed, 115 insertions(+), 68 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 88f07ec22723a..aae6e9adf2e84 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -555,7 +555,8 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 		req = smb_get_msg(work->request_buf);
 		if ((req->InfoType == SMB2_O_INFO_FILE &&
 		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
-		     req->FileInfoClass == FILE_ALL_INFORMATION)) ||
+		     req->FileInfoClass == FILE_ALL_INFORMATION ||
+		     req->FileInfoClass == FILE_STREAM_INFORMATION)) ||
 		    req->InfoType == SMB2_O_INFO_SECURITY)
 			sz = large_sz;
 	}
@@ -5255,41 +5256,107 @@ static void get_file_alternate_info(struct ksmbd_work *work,
 		cpu_to_le32(struct_size(file_info, FileName, conv_len));
 }
 
+struct smb2_stream_info_buffer {
+	struct smb2_query_info_rsp *rsp;
+	struct smb2_file_stream_info *last;
+	const struct nls_table *local_nls;
+	unsigned int length;
+	unsigned int capacity;
+};
+
+static int smb2_add_stream_info(struct smb2_stream_info_buffer *buf,
+				const char *name, loff_t size, u64 allocation_size)
+{
+	struct smb2_file_stream_info *file_info;
+	__le16 *utf16_name;
+	size_t name_len = strlen(name);
+	unsigned int offset = ALIGN(buf->length, 8), name_bytes;
+	int conv_len, ret = 0;
+
+	if (offset > buf->capacity ||
+	    buf->capacity - offset < sizeof(*file_info))
+		return -ENOSPC;
+
+	utf16_name = kmalloc_array(name_len + 1, sizeof(*utf16_name),
+				   KSMBD_DEFAULT_GFP);
+	if (!utf16_name)
+		return -ENOMEM;
+
+	conv_len = smbConvertToUTF16(utf16_name, name, name_len,
+				     buf->local_nls, 0);
+	if (conv_len < 0) {
+		ret = conv_len;
+		goto out;
+	}
+
+	name_bytes = conv_len * sizeof(*utf16_name);
+	if (name_bytes > buf->capacity - offset - sizeof(*file_info)) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	file_info = (struct smb2_file_stream_info *)&buf->rsp->Buffer[offset];
+	if (buf->last) {
+		memset(&buf->rsp->Buffer[buf->length], 0, offset - buf->length);
+		buf->last->NextEntryOffset =
+			cpu_to_le32((char *)file_info - (char *)buf->last);
+	}
+	file_info->NextEntryOffset = 0;
+	file_info->StreamNameLength = cpu_to_le32(name_bytes);
+	file_info->StreamSize = cpu_to_le64(size);
+	file_info->StreamAllocationSize = cpu_to_le64(allocation_size);
+	memcpy(file_info->StreamName, utf16_name, name_bytes);
+
+	buf->last = file_info;
+	buf->length = offset + sizeof(*file_info) + name_bytes;
+out:
+	kfree(utf16_name);
+	return ret;
+}
+
 static int get_file_stream_info(struct ksmbd_work *work,
+				struct smb2_query_info_req *req,
 				struct smb2_query_info_rsp *rsp,
-				struct ksmbd_file *fp,
-				void *rsp_org)
+				struct ksmbd_file *fp)
 {
-	struct ksmbd_conn *conn = work->conn;
-	struct smb2_file_stream_info *file_info;
+	struct smb2_stream_info_buffer buf = {
+		.rsp = rsp,
+		.local_nls = work->conn->local_nls,
+	};
 	char *stream_name, *xattr_list = NULL, *stream_buf;
 	struct kstat stat;
 	const struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
 	ssize_t slen;
 	loff_t ssize;
-	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
+	unsigned int req_output_len = le32_to_cpu(req->OutputBufferLength);
+	int streamlen, idx = 0;
 	int buf_free_len;
 	int ret;
 
+	if (req_output_len < FILE_STREAM_INFORMATION_SIZE) {
+		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
+		return -EINVAL;
+	}
+
+	buf_free_len = smb2_calc_max_out_buf_len(work,
+						 offsetof(struct smb2_query_info_rsp, Buffer),
+						 req_output_len);
+	if (buf_free_len < 0)
+		return buf_free_len;
+	buf.capacity = buf_free_len;
+
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
 	if (ret)
 		return ret;
 
-	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
-
-	buf_free_len = smb2_resp_buf_len(work,
-			offsetof(struct smb2_query_info_rsp, Buffer));
-	if (buf_free_len < 0)
-		goto out;
-
 	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
 	if (xattr_list_len < 0) {
-		goto out;
+		goto default_stream;
 	} else if (!xattr_list_len) {
 		ksmbd_debug(SMB, "empty xattr in the file\n");
-		goto out;
+		goto default_stream;
 	}
 
 	while (idx < xattr_list_len) {
@@ -5299,69 +5366,49 @@ static int get_file_stream_info(struct ksmbd_work *work,
 
 		ksmbd_debug(SMB, "%s, len %d\n", stream_name, streamlen);
 
-		if (strncmp(&stream_name[XATTR_USER_PREFIX_LEN],
-			    STREAM_PREFIX, STREAM_PREFIX_LEN))
+		if (strncmp(stream_name, XATTR_NAME_STREAM,
+			    XATTR_NAME_STREAM_LEN))
 			continue;
 
-		stream_name_len = streamlen - (XATTR_USER_PREFIX_LEN +
-				STREAM_PREFIX_LEN);
-		streamlen = stream_name_len;
-
-		/* plus : size */
-		streamlen += 1;
-		stream_buf = kmalloc(streamlen + 1, KSMBD_DEFAULT_GFP);
-		if (!stream_buf)
-			break;
-
-		streamlen = snprintf(stream_buf, streamlen + 1,
-				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
-
-		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
-		if (next + sizeof(__le16) > buf_free_len) {
-			kfree(stream_buf);
-			break;
+		stream_buf = kasprintf(KSMBD_DEFAULT_GFP, ":%s",
+				       &stream_name[XATTR_NAME_STREAM_LEN]);
+		if (!stream_buf) {
+			ret = -ENOMEM;
+			goto out;
 		}
-
-		file_info = (struct smb2_file_stream_info *)&rsp->Buffer[nbytes];
-		streamlen  = smbConvertToUTF16((__le16 *)file_info->StreamName,
-					       stream_buf, streamlen,
-					       conn->local_nls, 0);
-		streamlen *= 2;
-		kfree(stream_buf);
-		file_info->StreamNameLength = cpu_to_le32(streamlen);
 		slen = ksmbd_vfs_xattr_len(file_mnt_idmap(fp->filp),
 					   path->dentry, stream_name);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
-		file_info->StreamSize = cpu_to_le64(ssize);
-		file_info->StreamAllocationSize = cpu_to_le64(ssize);
+		ret = smb2_add_stream_info(&buf, stream_buf, ssize, ssize);
+		kfree(stream_buf);
+		if (ret == -ENOSPC)
+			goto overflow;
+		if (ret)
+			goto out;
+	}
 
-		nbytes += next;
-		buf_free_len -= next;
-		file_info->NextEntryOffset = cpu_to_le32(next);
+default_stream:
+	if (!S_ISDIR(stat.mode)) {
+		ret = smb2_add_stream_info(&buf, "::$DATA", stat.size,
+					   stat.blocks << 9);
+		if (ret == -ENOSPC)
+			goto overflow;
+		if (ret)
+			goto out;
 	}
 
+	ret = 0;
+	goto out;
+
+overflow:
+	rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+	/* An empty overflow needs an SMB2 error response. */
+	ret = buf.length ? 0 : -EOVERFLOW;
 out:
-	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
-		file_info = (struct smb2_file_stream_info *)
-			&rsp->Buffer[nbytes];
-		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
-					      "::$DATA", 7, conn->local_nls, 0);
-		streamlen *= 2;
-		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = cpu_to_le64(stat.size);
-		file_info->StreamAllocationSize = cpu_to_le64(stat.blocks << 9);
-		nbytes += sizeof(struct smb2_file_stream_info) + streamlen;
-	}
-
-	/* last entry offset should be 0 */
-	file_info->NextEntryOffset = 0;
+	if (!ret)
+		rsp->OutputBufferLength = cpu_to_le32(buf.length);
 	kvfree(xattr_list);
-
-	rsp->OutputBufferLength = cpu_to_le32(nbytes);
-
-	return 0;
+	return ret;
 }
 
 static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
@@ -5646,7 +5693,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		break;
 
 	case FILE_STREAM_INFORMATION:
-		rc = get_file_stream_info(work, rsp, fp, work->response_buf);
+		rc = get_file_stream_info(work, req, rsp, fp);
 		break;
 
 	case FILE_INTERNAL_INFORMATION:
-- 
2.53.0



