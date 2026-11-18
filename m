Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034330;
	b=MbBAaVFN+4Xj19+oPfpiu1+b4gjSeB5VBrLO4LF7xF2HGi5pn+gk+1ihbQzXgB8A1rvO
	 Z0V+blSyLYIsSG4pyR30eqEIl4WhiPytWS8m9yr3cc1BCOzZlOWPGbAGMWXol5ognEImx
	 6ieQ2DZv/pZNN6p4LCIzAyZNiMJfvCIc0ycIXzCKYtOR7ua1cIQUvVxdfjL8lgeKFZtlE
	 BiHNdfwlzro0MWls/Mjuw0cqGEPaio0NmmlcXRYRQ57opNsQ4HfTqPvw4KNZs3LnuqKa+
	 UzZTwx3ViqgNHcHm5QnGbgdrXPkJA1EDY98YxbGGHXceekYWWhvx5mJFVwuEr+3hXJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jbuSDg86ToMTIEt9OcSm+QIMi3TiOc5dgBkibY9nDlo=;
	b=xHiLZfxxTE2giVVBJ/4pOyXOKlvZU3vn8KkrDbqYuFIDO0oXN3x5arsP63Vf7b1D4dyi
	 UNVI2qL//7aF4qNPPDaqZLZ5qdOjF6Imdh+xLPAGfLr3e6TMMv98FNI2pwmhKUxOyxxh4
	 ipjnBAir42ST8wGNpE8i0b0VJbqvVYgkUpuNM25v9Bq4Q8TQ+Pw8ihS8Rgy86g0mBC9oj
	 +ELWco1fpqzUFhb8GqJzHlE2A3C3oXVcRZ23+xeh0VZzyDgCjc5Ae2unzBU0Rko4bhFzh
	 mnL6B2sg1PnKWU07bb7IOzuhaVlokpoYTKS2G7j9cBFS3ayNaotVyv7ODqm9wQoZTwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAf7Fuk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5E606A31C;
	Wed, 18 Nov 2026 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAf7Fuk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C2D1F000C4;
	Wed, 18 Nov 2026 20:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034330;
	bh=jbuSDg86ToMTIEt9OcSm+QIMi3TiOc5dgBkibY9nDlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAf7Fuk9VSkWeENyrdR6YHje7ABhaI6f1I/0EnNPExvP/jhXZONgQqLLRzCwaW3Zl
	 ETP0vAclbmvilpwHGXaeJ7PRapZ9w20oCFJJnOTOZZg05scX5kibWPi+oaXpWSPEOn
	 YVs1peTZpKD262DQV/xJz0KmlA93X4/LmJUYp3RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0290/3318] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Wed, 18 Nov 2026 15:15:12 +0100
Message-ID: <20261118150324.301602992@linuxfoundation.org>
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

[ Upstream commit 7f07791522a251e2be087d11ae9cd51eb3408f1d ]

FSCTL_QUERY_ALLOCATED_RANGES can be issued with a valid input buffer but
without room for an output range.  Do not reject the request before
looking at the file layout.  If the query would produce a range, return
STATUS_BUFFER_TOO_SMALL.  If it produces no ranges, return success with an
empty output.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 986513090276b..b22780a5bde75 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8240,8 +8240,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -8253,8 +8251,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (!fp)
 		return -ENOENT;
 
-	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
-				   qar_rsp, in_count, out_count);
+	if (!in_count) {
+		struct file_allocated_range_buffer range;
+
+		ret = ksmbd_vfs_fqar_lseek(fp, start, length, &range, 1,
+					   out_count);
+		if (!ret && *out_count)
+			ret = -ENOSPC;
+		*out_count = 0;
+	} else {
+		ret = ksmbd_vfs_fqar_lseek(fp, start, length,
+					   qar_rsp, in_count, out_count);
+	}
 	if (ret && ret != -E2BIG)
 		*out_count = 0;
 
-- 
2.53.0



