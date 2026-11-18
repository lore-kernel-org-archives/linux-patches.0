Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053030;
	b=BnGJo80p6SeOg0KBYOjMOPIRi7yREev8qJkXMQ4ryezMWBdMx+m/5v09O8AHm3zRoQ+7
	 pt7UTW3t2/VfMuzpl9xGsTrYBfWnS7mi+cFNiUX9w7l1TcitH8m60nD5lVwAylEVOB0Ju
	 LTSkchW/UU1BqZmXU24aRmIZE6+FivBODcR02Y6ZVjbe78ifppiNO1wK4THX0sfVYVIh5
	 2GSMF1OHDIEc1FfL5v/R/M7JQCJRcO0FoOImxDu45W9HFmeYJrclzkGL3JARsasBHbnHM
	 kTv0ZsoWZiVWmdxmuiunO/lYxw9Tm0Q0cbFuMg/Tjjpx7QJ0JZ9NTlgrDNrZY7pnqOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr5VuvsN4al45xdsdymBUO1r6C4gYLH+o1HF7c2x8IM=;
	b=0CXfJaSfSbEKcS5bBrC9+77+75OvA9pxDePkyo1646Mb8d4gS68q2vM3Ls3wPYR/uLQV
	 3Rx8TclsbFU+CKnrMt3Kg8yvBeAW9gQl8zAPHbAf1CGxbKO5D8LThLzpKZEyOwNiPls6W
	 WlOdfk1khSIKLpLqSTsdrJIDvXziLZbrh3NI7Jjqn0r88kg/WMionA88+iOkRlMcWp44R
	 JtQq3CPHtta3zkqhW31G7MKI8FKzpA2d1FmN31EyH47yrYgjc8iEPyJnLGEfX5bZKQrmL
	 DR2PyfdQVBDTDVB48kpzddiBYv04bN+jidxBwJXROlUa05EOl3qE9sNk4zrZ98Yj4rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNqKwmA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C7606A31C;
	Thu, 19 Nov 2026 01:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNqKwmA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5581F000C4;
	Thu, 19 Nov 2026 01:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053029;
	bh=Cr5VuvsN4al45xdsdymBUO1r6C4gYLH+o1HF7c2x8IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNqKwmA5LGf6G3BrjLCXvk0q8QLnhuY6MLC8IXlKpky4LlrDL/5Y44HnqwRBYJcOr
	 LMUA8mqrSx83w7luMsH8l17DswQInvqmo9fyqYY+WkdXULPx2Iqny0hfatsflR/b6U
	 5G9HFhHvvCN82ft6H9vamLwx/N0zN/rKoCzNcIy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0772/2214] smb: server: size directory name conversion buffer correctly
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118150042.553811946@linuxfoundation.org>
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
[ sashal: replaced KSMBD_DEFAULT_GFP with GFP_KERNEL to preserve the existing allocation policy ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
index 11314f7c622a6..42fa55c0027d6 100644
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -322,12 +322,13 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
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
 
@@ -336,7 +337,6 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 				      d_info->name_len, local_nls, 0);
 	*conv_len *= 2;
 
-	/* We allocate buffer twice bigger than needed. */
 	conv[*conv_len] = 0x00;
 	conv[*conv_len + 1] = 0x00;
 	return conv;
-- 
2.53.0



