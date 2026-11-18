Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046026;
	b=bTaHpWEziNsjlN/RLcnrKDqsdqUTPp20DAncBRBOoebUgIFKN+1uRSDbQOHGCs83jLHK
	 EAqDAaEArg5tOwMCE00alV1Ctct6HdJhT0p1lCcfo0w6XU6aHdxQWrOphbYLWwiq1t5qG
	 umP7SXnA85muXCXMzYZuNHy1v2DGsHDwLLzbNZDjF4fBA9vTVQC8Yh4JlHKvL60skUo6o
	 EK+NagxdRVB8xK3Zu6RPbU+LkWEu/iOSWCH6j0rH0V3pWhTZUE+267fiJ5SlzqOBA9OzH
	 ynKfjCZjgwY8gYlriDOrCvWBkPibFecLFni6pTJJOee+aX8Ld8kA8DjM95MvEONiWEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVzUVHITcTMpOWRaVLj3lxRGjnUK4m7GfBlp3Pgerxc=;
	b=dHYJ6e9mK+DNaLFT50rJtSVxKKQX8+wuWJ1PsNE505LT6KCZV26k4Yj50i4p4umUiMi8
	 JZY/sJUszM3KmcNpUw5CIeL5odvqesp36c1UdzIbfWJmXMzkF+aW4cbd5VWv9sXhorCoG
	 g1Sp7n56zLHvhmyG5mIu4parROWGlVXvBxa7ooeeCMn9H5g63tR5EZcNJIYUA3rmfNzVy
	 MOHej2nKx0fPRbqhEHvUDN4KsycxomUaz+X2pnzl3qUbOoQr7KU4XchxBF9UWV1syZ37+
	 oqgADPFUyNqv7s/EzBrz7KQCOZ21V4j3nTJY955Ndy0FqFNVaD8ZQlMpUH/xUFmDMwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZRv8Svb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15288606A31C;
	Wed, 18 Nov 2026 23:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZRv8Svb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5291F000C4;
	Wed, 18 Nov 2026 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046025;
	bh=rVzUVHITcTMpOWRaVLj3lxRGjnUK4m7GfBlp3Pgerxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZRv8SvbEslGrNtH/n45JEathjfmlq9f2ZLU2rNL+cm4GC1EG6v5isoOpLp+6ylla
	 tN+bcLLwu/nXEw1FgjYnGCRDHE2wvB+f1rt6IeZFXDVz/jjtU2DMB6yPYfzjTk7H4B
	 fHI8Oyb61U0dgfa+T/HOUWQRccciUkhbYB6VjMS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1117/2857] smb: server: size directory name conversion buffer correctly
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150241.839635286@linuxfoundation.org>
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

From: VeroFess <coderzeng@hotmail.com>

[ Upstream commit f1f37834eaba5904103af1f18afe3510c7e9dc71 ]

A 2048-byte ASCII directory name needs 4098 bytes when converted to
UTF-16, including the terminator. ksmbd_convert_dir_info_name() caps
its allocation at PATH_MAX and writes past the end of that buffer.

Allocate space for one UTF-16 code unit per input byte plus the
terminator. Use kmalloc_array() to check the size calculation.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: gpt 6 sol with daybreak blue
Signed-off-by: VeroFess <coderzeng@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: used GFP_KERNEL instead of KSMBD_DEFAULT_GFP for kmalloc_array() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 98da57bb5fd29..ea6eccbe81bb9 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -289,12 +289,13 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 				  int *conv_len)
 {
 	char *conv;
-	int  sz = min(4 * d_info->name_len, PATH_MAX);
 
-	if (!sz)
+	if (d_info->name_len <= 0)
 		return NULL;
 
-	conv = kmalloc(sz, GFP_KERNEL);
+	/* One UTF-16 code unit per input byte, plus the terminating NUL. */
+	conv = kmalloc_array((size_t)d_info->name_len + 1,
+			     sizeof(__le16), GFP_KERNEL);
 	if (!conv)
 		return NULL;
 
@@ -303,7 +304,6 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 				      d_info->name_len, local_nls, 0);
 	*conv_len *= 2;
 
-	/* We allocate buffer twice bigger than needed. */
 	conv[*conv_len] = 0x00;
 	conv[*conv_len + 1] = 0x00;
 	return conv;
-- 
2.53.0



