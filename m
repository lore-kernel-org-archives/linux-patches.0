Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034336;
	b=BjhTXEArU4KvARLBLh1S0YhsFGZ+eLsxenWAzZdhjPH2rYGQdJi7GGcZNee6ER0vnxJf
	 9cHTd+FlkKEI2bNXgf9TTRoOhSzTRm4E4ShOwRRm4qvsN9+ZAkgJ1Rt6+GQ/h9lSVi0Uj
	 P8DEZlbIw4xVMdSDRpUPN4SQbDmvAgrAw185OcnOnPSWrmZBImEeWGB/tMQFJkSdpNglE
	 xZFFKuSDXKOPJ+S/zYJj85GI0tK0ybQtKag4o4pu2c67DfNEhclR/nrhqQjRHBDBlPSbw
	 K5UB+CDgyv8pfO9T20LK7nRh43tHx96Rxo8uom8jZDcN0cilEPJk6EK44ZD2tzlvgPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJfcLJng9sMWOmKqF4gY6AZwjrsgbNaG2WTHO5ceVro=;
	b=1YBlp0RIZMStGPCNWiYHPGH08dPOwh4Z65q2JyXA1EOW/2A+InKEDEbHTNH5tucTdlbH
	 goNFYl1nKjMF0karqasMw/QqWVUIHG9iC3u0k2Qs9VM9ESMDhDwVKRz4VR+5rpuaPaSHw
	 n0CdVxT889q31IqgM2ANWk6gZ6V+LSRPOb5POzZjir0tuacXj4EY6adva6qEe22C/RVFa
	 CfjcFt8tEa6n30HkO4ZY+BRFhRyj5Xoe/+4vEdOzJu+n68gPk0tMHloutUSWATMmujcba
	 7L6aZHoYtGR/OJbSxtkk13N35wzC35Jyhky/YkNMRhz4dblzMkX4Vo/TDv1fvXryzXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yfq6IM08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597D8606A31C;
	Wed, 18 Nov 2026 20:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yfq6IM08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBA01F000C4;
	Wed, 18 Nov 2026 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034336;
	bh=IJfcLJng9sMWOmKqF4gY6AZwjrsgbNaG2WTHO5ceVro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yfq6IM08ot2V6hYOohdSdknTY5f4FiccNCRs62UFnvPxBJy72msmUiMkQkYG6/031
	 32X4d44WjhiIsusU5JNCTlGDuY5EMQQwziCWSr6xHLiLi6KvI/onia3BonCgFKVrgn
	 1OBIjrMzrgWYBAseEl+aeUTI1jg4CE00L2CjNIF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0292/3318] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Wed, 18 Nov 2026 15:15:14 +0100
Message-ID: <20261118150324.378309607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 86c84cc760080929b7be44bceebe5854957b99da ]

FSCTL_SET_SPARSE without an input buffer sets a file sparse.  Treat a
zero-length input buffer as SetSparse=true and keep rejecting truncated
non-empty buffers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 07cd069d2ec47..60d13595025d1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8548,15 +8548,21 @@ int smb2_ioctl(struct ksmbd_work *work)
 				rsp);
 		break;
 	case FSCTL_SET_SPARSE:
-		if (in_buf_len < sizeof(struct file_sparse)) {
+	{
+		struct file_sparse sparse = {0};
+
+		if (in_buf_len && in_buf_len < sizeof(struct file_sparse)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = fsctl_set_sparse(work, id, (struct file_sparse *)buffer);
+		*(u8 *)&sparse = 1;
+		ret = fsctl_set_sparse(work, id, in_buf_len ?
+				       (struct file_sparse *)buffer : &sparse);
 		if (ret < 0)
 			goto out;
 		break;
+	}
 	case FSCTL_SET_ZERO_DATA:
 	{
 		struct file_zero_data_information *zero_data;
-- 
2.53.0



