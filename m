Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037149;
	b=MSpjhINU6zdEnSzu1GKBBo8E0yErMhQosIZQzpWxDw6mXDU5qfE6J0G7ZMhRH0GYo69s
	 ImH8pbVboXGjFlED9tWdwXMHTCd4jPJTaonxN4ykAfAaWtN4+QEXVJnGtOcfTJR4pwnI5
	 dDVZO7gnmJdQyGPMU6G+zmEHjE827qya9eteMUTRyQYEjJpJmXnstvtDiHN14KSFMb2qj
	 ZIvxv9A/cjNC+6o7svpX1nlMfHqNKIP2SJQgsEN6+d8Dk16mwHyQ1BvHlucnxUwWfjMsK
	 4oXVhUehbqlOm6bToP41/sSdHsEcr0EK6BvZPwfU2pvYp02gQaQYC6o2KCTLRd3cwqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8drcS4wVzCaoou3A2omQrOcYpf7vCFJnv6h+2TGt620=;
	b=jEJDFY/bZpF2qxzDuuYR0+Deaoo7RGNI87z3NwljLPf+SFfzW4kJEp26YIcLY7xkIGq/
	 0RBN7Gn62ToirgXHvHQpiTL9Iz/jVSqfz+BG4nYxs9+Lb6rO4/kIJrrjF9Iu6wJ7bbQqD
	 eimKDp4CKfK4bmGeT0LXCfDaZbYjiCTN6S7+yiDDjyNvDaCOI7DCvuYUa3ir2d1AjKmaW
	 F6DTB8YMEekkoNcIFyrsKkCthlg1weHw7hnrLTgqSFlmrRL5H7qoIhjhabm+2filyULdl
	 mFturSvWLJ4TeTI3VD6sd3uSZe+Hvcul/UcSNmnTd3tG37Oi0Un3AQZt51G4ESkXN7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdpIVoUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6141F60A382E;
	Wed, 18 Nov 2026 21:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdpIVoUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DFE1F000C4;
	Wed, 18 Nov 2026 21:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037149;
	bh=8drcS4wVzCaoou3A2omQrOcYpf7vCFJnv6h+2TGt620=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdpIVoUz5Ts1WFvfVjVPdUMcncBEPv3d+Y0ufyTVWDAOnkJfk59VR2e6myJ++gKPi
	 7X5Px1srKuXi3VstmXEmVq9NURkrsgOGh8RUVAoW7tua/k1DodTWHLEhhH3eRHKTLs
	 Jp/9RahfDeT+fTy2MeryNG4IhBL5F8b/glt+Xgbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1311/3318] smb: server: size directory name conversion buffer correctly
Date: Wed, 18 Nov 2026 15:32:13 +0100
Message-ID: <20261118150359.610856761@linuxfoundation.org>
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
[ sashal: Retained GFP_KERNEL instead of KSMBD_DEFAULT_GFP because the latter is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 79de46a0283ab..604d8584fb2bd 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -290,12 +290,13 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
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
 
@@ -304,7 +305,6 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 				      d_info->name_len, local_nls, 0);
 	*conv_len *= 2;
 
-	/* We allocate buffer twice bigger than needed. */
 	conv[*conv_len] = 0x00;
 	conv[*conv_len + 1] = 0x00;
 	return conv;
-- 
2.53.0



