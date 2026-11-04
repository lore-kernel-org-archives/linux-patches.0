Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830937;
	b=ymURYZWnNj8lOlXnPBMkG7uh1LOXZbg376hfM5ra4Ugd7HOUMG/+XAP/KDg1n9T4KKTO
	 ChEojZ7GcPiT4uAgFHFdEGGD8Miqe7tn3CN9eD+Ap+jBkFG5aQKxPiOlKAUi1xeVV+pzT
	 Y8ljA2fgxsPAq+0qn3GDvTAQAm8MOP0SGBtFeS7JMufFnU+Y2H8r7cV0hPDhTirwdIP0a
	 YuLi8s5q49p4Y1Pn5KfjvGfSPUnvA3Mxpgehg6QBIGl2oOFTsdb8Dc+A2TsX24RLhpyIK
	 qwX2WIzXFCIyGHqBaseRmEbgGD5T4Xd7rjCEPe9euz4MZr3osNkQTwWU9G3CZyPXI+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1bwb9hMOwle2ZY/3iI/iCoZEY0sVN4YPaEHgOPdc0Y=;
	b=Mc40H8lcve9OsxiU+83VngSNuW70z/8EMdCQPBzdBkrfC3KDg4Q4cL0Zi/LRyDE95fpQ
	 37Opcsmf4D+zbmfQpjK52YQnQzO6CxU2JWC3rmfNhEGXcrZz7R5rPlPgSQYDd9PphXyij
	 9CKnDv89O9ZawYGa57yZEfTFBPhDWb6SDrPUlwShzDCifWLHRzO/37j2fhh2IIxF0jAFE
	 AczYQ25zsnfwoJ4Xsjc60dS7+bY/M3tDbNyZRurkMEbSJ0gF6IrCae3UUI4xcxuPpeAux
	 rh5sZaad2mUIFJJEfMnVYbgtmlFwgVWYu1eYaKFjuqQT6EulFMA2G9BYOXLGjQXi1Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbxOrjcb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E6B606A858;
	Wed,  4 Nov 2026 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbxOrjcb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631761F00A02;
	Wed,  4 Nov 2026 22:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830936;
	bh=v1bwb9hMOwle2ZY/3iI/iCoZEY0sVN4YPaEHgOPdc0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbxOrjcbsL94Ewxp9uk5w8U0RRc/a3r2YpJf7aEbC2Ym6ULsF36lTvFqOyUuP9P8W
	 xeIfgbjbz7RNU/+rRRp5vkyeqn3/doG1T9gV+XqjmDzEGZBO+KDGaRGTl+cviiecIX
	 NCNv5DAKH05VRrW2vOgMwxI/Jwab+PDjM+DYFsvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0412/1005] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Wed,  4 Nov 2026 16:02:25 -0500
Message-ID: <20261104211055.623149243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 86535283b49a6..bfc60fc9fb275 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8617,15 +8617,21 @@ int smb2_ioctl(struct ksmbd_work *work)
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



