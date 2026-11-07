Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060997;
	b=zcNcmRSGIJGAmX9Hd8fFJKZOzGXaf7Zg5ujqgL3ZvIEMvlN+n760imsSgWGjeNgLZXnC
	 FKSHqQwENSp0OUikBxMar9ZMkDGehtkSb7UFoSF1CFKADlw8cAZZBAAFSq/JuDhHy7Xub
	 ZHUdZT4FCEzBXzgmasu+HG1gyr4/Rdt/noLq1ukj+XNpOHi7Wn097B7dQoy2zX9tpdiX1
	 z1PLfgnzUdE1liMmIW3gQVFGzBc5jwl//KTAQw34WB1+LmDF5WUw3J4aEjQeBwNPwVqYo
	 4wbGT7z00MDt1NQ2epO3yGJ2+uPOtb4db7tZ2AsHwHtIXh/qHg1CarOEgaMUjTEA/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ASD88ZdN/+XsvCex5GN3NkMTSkAwc6x8mvVde+aMGO4=;
	b=I6niycvMDv4KUrBxPQLNNR9P0V7Th/ozTLZu/Fh3O2h/XoNtVxLb4D58dDAvIriWtfJL
	 m6T1oXffF7XlbueBXrNGrIQHnS5eR6EUVwMkNJlH+bPRd/Rh1Oq0fJ6aV8gGRPqQc6hNV
	 XBM9u/tAKXe3hKTBwoWBKKerijIA/0B6KQBZ/eNLoVYqGoabegKRTv/EwZEzz5j0pdgF9
	 yxa1ylbAM8YFlXM/ROsHOkq9GTVsb2Bj72Sw4LqB957Pu+UYtOUAI9jNNL5xBtlhzRRBf
	 w0SUVg9+vztyD3W7ii8JkBgKrOJdKvQVUBlCmrnfiRfxtyivSKuW6hC9fHXzvbknDHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElU03gxW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB92606EEB8;
	Sat,  7 Nov 2026 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElU03gxW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200761F008A2;
	Sat,  7 Nov 2026 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060997;
	bh=ASD88ZdN/+XsvCex5GN3NkMTSkAwc6x8mvVde+aMGO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElU03gxWwrDWqBDaWxunfbIz6SKKXlZmPrb/EIlK34iT9OEaQjq3o6SWozUeCme15
	 j1rvT3WF2pzdxstNwBbyJrivFkhDTUBIFbfa/ZGGtw84ocBDTtarFuiULYA3Fc7IVX
	 Kntbf2U6PmEwxGvynFXdp8m+E83UUFDRpBKQvB4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0344/1536] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Sat,  7 Nov 2026 08:39:20 -0500
Message-ID: <20261107135007.340928125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 3ff76c851cc40..2c74e0fd82b9a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8260,8 +8260,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -8273,8 +8271,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
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



