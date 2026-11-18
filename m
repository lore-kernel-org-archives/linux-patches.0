Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051519;
	b=xblhzC2+bM8qWH4mJjgVuav8UOOY0G6JrhxjVV+Dz1qboyWd2zLgN1QO8LhP+fIlIjLS
	 gyCHwG7QepdihtfxyGOeESrSAKLbwm4y3HtJP14Nse4LmVeum2fTng4tZtJAVFhe4ncnw
	 N8C7i2XWVoheQqrfvWnGrxwnNsJ7KEjv76YU2aWe8biVZQZHL7PlkPH/2bbJ8+i7KjsJt
	 r4wXKV4AgU7un1fMg9m3AKww4R62UzNtKG9CbfMsfB4EhVqe+qFRp1zCcKWDaO8wg8T9Y
	 8xInsRQyC+ekH5biUT3YG3AT8AfzB1qVEPFQeQJP44tPN4+WaK8DwodkRyN8EOWP8Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CsiJDxzAGU120sEZf0P1ZfYRGvSykTGqbE/UAYmV85s=;
	b=iqVMNeSdHM7Q2yxnWVUVahk1xBwH9joMhgbMk0/MvKuA4p+HAAjR5Tnn8nbIva/LGirz
	 uu/rUHOu7oOI6+TBKSeqSmamlXE8oYSGYTlhHtWlhPAktZz+WWWy5hPgG931N6vldAyEW
	 J38yviWu/HM6YutElv5wn6xMFAFD8s1NAtzsgnJxO4QDmeO6zhYIJZC8GC3MdNz59YLw/
	 Xntj6zWncDSVW9CgpFUvaGRp+CbDTQ/gW7hvNkx+Zgi+C3/xo+mFOY+hqDHhcQWJuwbZx
	 MKu4UW6J+QOsLMCROWxvYsaZvAQDX+423TQwuhVWwhBGfN85k0WB8+YNyiItOsGii9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCADmRLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CD9606A31C;
	Thu, 19 Nov 2026 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCADmRLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D701F000C5;
	Thu, 19 Nov 2026 01:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051519;
	bh=CsiJDxzAGU120sEZf0P1ZfYRGvSykTGqbE/UAYmV85s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCADmRLDHKuTbTslyWKzsl7xo2eNtgCM0QA2yRAQzd075YZPPjPVxN3fFwD51xR0U
	 tgGu72h5Xk9hqEOdSsQGPl6PJzUsQvEm6Osf6ISNvzVgXfGA8xO8Wqu9vN8Looj3Cg
	 2j+egpsgRCyKd77fOBCgr543nmfbfI9HfThmjMMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0210/2214] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Wed, 18 Nov 2026 15:31:26 +0100
Message-ID: <20261118150018.589151875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
 fs/ksmbd/smb2pdu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bd51c02c24ca7..66f3bc4ddd2bf 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7626,8 +7626,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -7639,8 +7637,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
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



