Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043538;
	b=pwk8pkmTvE3FwBx1PghjVX8L0kPhZ7+4Kugxvd/TXuTjRUObk2w52hZn8Hv3k86Qaew+
	 7o9/VfS1ooNsIqS4mcWq++TJeWbfFdl+CFiejMs38B+mTnTcPcMQsykGKNIU9E9sOKwiW
	 poVaUgH3anEwlvySZEhfWXYY9fRu8RWEc8GdIoIaLJFiiuYxSnvdgpKMXHLwkeAzW3GiQ
	 0HnFEIVDitDW8yXAIlidsD3g8LAcSnIfQLRiQ6XiJ01wo6RzLkMtdMMCjw3ybyqTESI6k
	 O/jmB+PHBGBtrjFkSQEjdDNPLG7VyiHqOIUVELozRQU5VhKMHB9DEUSDDG4USpaLPDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Je1a62ZWW1LFeerHPi8t4oACd4uMeFPRR3gnUJ1bzQ=;
	b=W0BMOMmFmTE+CFPauvkWWIrWcXos7zjYlmmPxVxooeKKTZRpncuPg21sU+YybvcfZ8CD
	 k+DOXlyx486fcTlcx5bl3/SBAZueD90lLfgA1lUr/Z6QpNq7E1HEtOonwiVZh9dWkSxwc
	 wp7KOdtR/oOPs1N60RV3b9vnttBP42Lo5RMzfozh7ePyNIm/oop0PwnGXF2lK2T3aip1t
	 AuUeoJWIbYSbxfJD6i/ubMCv0/7VXDdSWb/1kMwERYvEeb5QdRfF6pVueQd3Ujnx2sPyS
	 6AX9Co4ndhokNUfBse5J5IrE+9DTpS4fwkqAemPF2Rtq9A2zctSg7lDMq35UEd0EDeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hBtc5o/6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FFA606A325;
	Wed, 18 Nov 2026 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBtc5o/6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C531F000C4;
	Wed, 18 Nov 2026 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043538;
	bh=1Je1a62ZWW1LFeerHPi8t4oACd4uMeFPRR3gnUJ1bzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBtc5o/6ZoLXc0TWljOwR5/wM6QiXJ66r0TlVTOwXiKrYhAuUx7S+c06BWACjELgd
	 2bPz0RBZtxPar/ih6WrsLHW+UX2BoC9wwNzvj6OakGeaJZADtZyvQe4oJ6j7mNxFaC
	 +lEpTv4jGVYlUcAjhR0nOI7pjxmorL74UV8kDjrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0247/2857] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Wed, 18 Nov 2026 15:21:21 +0100
Message-ID: <20261118150210.335879036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65dbd33753b05..2a7b5fb185dda 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7797,8 +7797,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -7810,8 +7808,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
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



