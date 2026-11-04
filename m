Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828994;
	b=mqEGoyM+mRkcyP2pMMBsCv4t9zqAyh21OMbz3Iplb3ZupdSGiEXxDQUSpURpJIkgQ9ef
	 RcwpQvsKObZ1EZqnlzfCqMdK0kcz4ZzG1H0nMP+y/eVJnwCJOkdP5lyuRp/z5svSrXOid
	 5++KoQEtJK7g/F7ISd2eoZAmWDywgQCssqAHVzpd7J5PW9VR8a6Pua8ldKEuVj4EnqjEM
	 6laAJYefaPD3sdmd0JL1dKNIGEB25nBbCtk7/Fak/0lKIwqFN8jK6mjDvgp0KgNpgkkOx
	 dWF1d5L5cXvaaK77QZ+NK85E4wvjqx24xKCLkYPDW2cLLNbHW3S5R5DLVjfZx1Kwoew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xN7Ia1jf1gy67j/ce4k1si6XcOE/05u/wJqRF7FfPr0=;
	b=oy8RhQXsdDsK7O+gV7UNIcDBWIthlkqNU2p/rJBiTiIDUI8C5N9Xw3h1ACvOol88QF9y
	 l7j0L2TwuyeuqnSPXbUobkW3IHcJtL8QpPCUzbp32c+yUahecyp/rluawIvuPzdFgvCJ6
	 je4vtgeD1TZdqkPm8LYKPUxkiNppB0wwC7Nnzrs4FkEFuA6tjIeak1OFVhAEKR16FVrKA
	 LbH6jEY/MF9GPrqp9DXahH+z7r3fI2xRWUIE6X0nJZBRNBYS3FHdMv9Rp2MbYBwgeMNVG
	 rS5hYO86BwACZNq6QnIoFQlwmU5FLlG8bWmL5J7ReviaVhCy9fbQ2IvZPNFCJrsNREw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddTUXTnS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215B1607266E;
	Wed,  4 Nov 2026 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddTUXTnS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9491F00919;
	Wed,  4 Nov 2026 21:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828994;
	bh=xN7Ia1jf1gy67j/ce4k1si6XcOE/05u/wJqRF7FfPr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddTUXTnSa8aGHnpCmfypH8v+elxbmVd97vCCWAwF+9eyro9gtTA7kBr5dqfbSDVRv
	 xmZwlqt9tM79gi7S/jkEnCMtJ6tSgyvt74FJijeP8P9oiq6ARRRBlV1iLq0TFALlAO
	 5Ir1ITXmsJStg6cjfaq8BbCRqzQ2pr7/vfTuoFnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 375/547] smb: server: size directory name conversion buffer correctly
Date: Wed,  4 Nov 2026 16:09:19 -0500
Message-ID: <20261104211048.955405454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -296,12 +296,13 @@ char *ksmbd_convert_dir_info_name(struct
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
 
@@ -310,7 +311,6 @@ char *ksmbd_convert_dir_info_name(struct
 				      d_info->name_len, local_nls, 0);
 	*conv_len *= 2;
 
-	/* We allocate buffer twice bigger than needed. */
 	conv[*conv_len] = 0x00;
 	conv[*conv_len + 1] = 0x00;
 	return conv;


