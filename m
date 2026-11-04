Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830933;
	b=aMDB/Gt0cptHLYg7dz0BVUvwqquqwQZ4Le8nWj5hEHr2wsV7pI0zXCmEaGflP6+pvs5H
	 2rEsqTgMiP8WVaEDEpvEIW0iubUQXpw53nIVU757ne+0fLzgU5ea58nvRtDK5jVPdgul5
	 Jbrlt83jn524a2oZs/7snvNxYaWsPtUwWW0Ded2sMDB63q18YmcXmPuoug+XYOh2R3LXx
	 6gDAXj1138LuPThU7aK4WHdHyj5i3BZkzQil3F6HU0qrTy0YHpIZ8V9qHyybBC85NJiEl
	 WNVmtnP3Kd0cVnA9gRN5MwQrLsjGPy457OCc5WAkE4rQmDnRGu2jMnYybnKyx49UHTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FgCu6bq9Ao7enMAJZNxYtAvqnjt7WY+Y+dgoyG3oKvQ=;
	b=v/eSuHMM43vGkw+kRgW6rgWjfcOCjX/omnq1Gs9qqPQ2r321YtT/u97FP0yztdWm39yS
	 qPa+lAvQMPRFQ2XAfliT6vd5kd5PmS4oOHgzxbRl3qPZ6dPuo+JTE0j394nua68pBNcq3
	 U4gB7+ty0izQin8Tnm7xL8a57Yxcu6M93YHgsJCeV6tRGXnGw25QFTzANfswYH9fbzVdv
	 K75luqwiZZfndPDGeeHs1XVfWmrL74+sYApjsCydP8qjAa2B+28gM/IYJFYUjzLjjL4Zw
	 WxJBV/OEHvv3g04KpQ03smilCFWDh/M2hGPkbFEzsHdYbLK7rkkJvDmH/AhHqCSdPJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBi6zEJk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C176606A33B;
	Wed,  4 Nov 2026 22:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBi6zEJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B71F000C1;
	Wed,  4 Nov 2026 22:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830933;
	bh=FgCu6bq9Ao7enMAJZNxYtAvqnjt7WY+Y+dgoyG3oKvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBi6zEJk6SkWNmBvLnU2Hz6V6InpezL3o7YkB7TlkrbOmYKWYQ1SZjeXMMGy8ok/d
	 WxEJ9TrVmulK7RM/qQF/q3+v7Ivb7B9lCo85DadYSJgsYKZX8zE2WoIUDckqGs011m
	 YWzNFjSVr1G5wFWCee2hJMloEk4YHsf50Yl6TZpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0410/1005] ksmbd: handle empty QUERY_ALLOCATED_RANGES output
Date: Wed,  4 Nov 2026 16:02:23 -0500
Message-ID: <20261104211055.562095988@linuxfoundation.org>
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
index 0de707a77faa0..84fcd84d6a666 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8307,8 +8307,6 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	int ret = 0;
 
 	*out_count = 0;
-	if (in_count == 0)
-		return -EINVAL;
 
 	start = le64_to_cpu(qar_req->file_offset);
 	length = le64_to_cpu(qar_req->length);
@@ -8320,8 +8318,18 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
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



