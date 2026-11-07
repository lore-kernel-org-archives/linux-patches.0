Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061745;
	b=NPlERvQ3OCdU0NP4JhIT4VVGxR6+hIPxMDPc7NUjAKn8N52iluY8OuKSBSuAeQoZls3/
	 J7DnTAAb9mSqFhHJ3n0UbsqYdz7jciolDiGBrigyQBh4g04VBzw9MAgeZZcCYnPK3pAu5
	 AkWuj8Ug6JDp7mmUOEjkC3v9pdP8964yHhjZgYFnDIPNs9NQN1UEXuHc3nJgizFusQtgb
	 Yzfyj+UatO/3+QeFukzbt2YssIMupL3plSJkOLezD6JAb2vfv0m/iVLsrwjqzgOEEIUPP
	 IbBTHlEQtJCaiX7HPyUzx7oCZCH1F/5M8S51GI56XJG+NNTYuofujVfykNnM8pKFPpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PxxNri9hHiqAqDhaEkFpeX8CWn521GrrrAH9Smj5CU=;
	b=SGSC7dto9Dr4jS9zQ3LHyWIfIkiXkh6roAHNLTMkchL1K7m7F39SB3AbmKsfnWp/WkA/
	 wU+jS48CRWMv98IBEQnRFo/q2BKv1t8DPA8mmk8Ry4qM/PJidUIV96z2ohevqSNi+ZLmF
	 Qax8Z3MOQV5IfRe7sTvUmoOBakaezo7tKxmZbqtCHs0grzM6S2Uzg1F78D/vWej7KqjTN
	 EpiyPsx4iGF3xBgyhBbInZpvYHe66d/X2f2sJcJVLSK6YBDC/R4PI8XWXDZZKulkSXdCd
	 FoDY8S/QesP3+gepp1Pp5eSnHySG3C4QOu4wVHuSXEE2DzBmdPyQc3Wy9cXzTUt6iOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui26CC8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB86606A326;
	Sat,  7 Nov 2026 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui26CC8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294B41F0089F;
	Sat,  7 Nov 2026 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061745;
	bh=7PxxNri9hHiqAqDhaEkFpeX8CWn521GrrrAH9Smj5CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ui26CC8pyOxfZUnVIqMSuR2ytY3lW/rvXCuXFV3op68jT35WvmABB+yxxtOj9+wJ8
	 JNeuqTptYqh+WXB7eo8jPE9hFHh5NbFQ37Hrxj+M1ISC0IjEIoPpJ100kVCfrCnYaN
	 U5wsSlcnZZ9waMsnf5Z0J/55697NV7vO7eg/+E6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0747/1536] smb: server: size directory name conversion buffer correctly
Date: Sat,  7 Nov 2026 08:46:03 -0500
Message-ID: <20261107135018.512353503@linuxfoundation.org>
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

From: VeroFess <coderzeng@hotmail.com>

commit f1f37834eaba5904103af1f18afe3510c7e9dc71 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/misc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -291,12 +291,13 @@ char *ksmbd_convert_dir_info_name(struct
 				  int *conv_len)
 {
 	char *conv;
-	int  sz = min(4 * d_info->name_len, PATH_MAX);
 
-	if (!sz)
+	if (d_info->name_len <= 0)
 		return NULL;
 
-	conv = kmalloc(sz, KSMBD_DEFAULT_GFP);
+	/* One UTF-16 code unit per input byte, plus the terminating NUL. */
+	conv = kmalloc_array((size_t)d_info->name_len + 1,
+			     sizeof(__le16), KSMBD_DEFAULT_GFP);
 	if (!conv)
 		return NULL;
 
@@ -305,7 +306,6 @@ char *ksmbd_convert_dir_info_name(struct
 				      d_info->name_len, local_nls, 0);
 	*conv_len *= 2;
 
-	/* We allocate buffer twice bigger than needed. */
 	conv[*conv_len] = 0x00;
 	conv[*conv_len + 1] = 0x00;
 	return conv;


