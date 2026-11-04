Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831708;
	b=S5KXO2E7isJLKsD1254ksFR1FT6FM4urzuXuAr1hjtTaD8zY3reE/ZIl7FqwqR/0Ft0f
	 cvTiXUdDg8vMczb9hHnXUH553dAVabdgM+jIC6b75HRUhQPpQfOGnV313rVLTZEhcUFMC
	 OH710//cIiDOknVyIWiKMwqjndE1JYVWdJrGmsKTAD9ERmsm4ST9VtjJfkKk2IhnuWShu
	 vkZ/OMn8jRW2xqZzU2i8+YRNLf9J1PWUnD5AaAIAA5JSiw7bsRKhCN0pHjcXslnsWtp5+
	 DgftDtrfv6F24CpKBAD+7BHT+GBsL012e8SVx9ezeWuvy/jny2vmOCHNswkS9UOfhyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EycqpjHVvKIBHEmZH2TWXQ+vYx/UGfaNE2v75f34Me8=;
	b=j/u15nxj65mTodrPlEniBXlVuw+0Khe+1TNW6HL1xmNMoalolCFfO/+KAGBHAiFheFh2
	 CqBXptfxsil5IsTl13Q6JmyJnzfutP4sxHfmZ/67OzGHcGlsvbb+mX3yjaEPTsNGrBXVp
	 5HEFqYJ/mIqFR4s51XQNVucZDsabA6H6v96cttQ3Jx8s6FLJUk39isyJGv5XQpxuyzAyU
	 gTS9kDqrOXJBMqRJMkIcQvB+CG/RdT61uvrS6ARxImMH3ZECEiJfFA25kxpN0041Na9GS
	 VtBqVOcWqviEdnK9/K1YwF7h4lDDZKGt3EWvPdSECVyFyrESRCZ9aMkNuGV6me/HGFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkIHHCCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8286E606A337;
	Wed,  4 Nov 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkIHHCCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE4B1F000C1;
	Wed,  4 Nov 2026 22:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831708;
	bh=EycqpjHVvKIBHEmZH2TWXQ+vYx/UGfaNE2v75f34Me8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkIHHCCkrM42s+uc4jfmi63QR8UPtG59NGlcQ+G1iVcnjja9KHNSyYe6q0VmZiSJf
	 ITPf07eIg4UruCKMf3FztuoBssoofZ3SlFmsid6BqDxBfA4B0xfMIU9GYbJ37lgW7j
	 aSS3bMJnopBeDTxpAAZzxsFTVInu3BKH3SQDm3SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VeroFess <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0866/1005] smb: server: size directory name conversion buffer correctly
Date: Wed,  4 Nov 2026 16:09:59 -0500
Message-ID: <20261104211107.532279157@linuxfoundation.org>
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


