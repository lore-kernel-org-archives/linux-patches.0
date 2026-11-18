Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035018;
	b=u4f4tlQTJgtujPytnI/zoHqQqVytnAbiQ94L2wBI/VoZYhg//poNEsmCjzf6GHy7HcEL
	 BL7rx9GIQgNgJNtD2sxFAWrKfk1tcVwufwTAixjOqMRbEUPkYc2K22QAMZwi1WBAPeUU2
	 9AJksK5Bf/9KsEqmfdIJyM8xoBAoNwvGO5rAnpx5Wj82ONrdxK+MYXl8dhu1xGmnA8BB3
	 5GvwFGDwsqWjIC2j9ylA9vLSMc87A6VbWBKgmvyijBG99F9/grqXeNU8uwau4lHi70yXc
	 n1KXg/6LgbkIjg29eT6e2Ixp/GIBnkllEJ9gTbuJuDRWhN2EiZKBVkBymjlhL574f8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQbfL76fuwceu0U551H8mu272SbJ9TGp2pRH6R+Emuc=;
	b=3PJu8wGXdmfTqrZBgJ7P3lBLH6N0uwfsXvrZ+0RBccY4ah2guMxjweAQp2GmZmBjgATy
	 +oUh/424hGgar7oJVqvUTPBZM5OZXym84D+O3YGGvdCCZAGbSiyFx14AG2AIBrhzYs2L0
	 4AGw/p/PM0HT3YbGrdLmHIJedSJdQlwza1YS5u9tDfYU4P8hbNeRqJJ9YvbaSrPIg878U
	 hf9prGSiswvxZEb3rnpMcE+ar6a65NVljHjYGf/cjhf9t0suYrcQ6RZ2TCyGxKJlnzmQQ
	 TroDwHLsfAjwba4c819pi+OzicnIcK5FO4jke4HJC3/mMH9la6AbxFnutduYLPGvahw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUWZmYTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990B3606A320;
	Wed, 18 Nov 2026 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUWZmYTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82661F000C4;
	Wed, 18 Nov 2026 20:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035018;
	bh=VQbfL76fuwceu0U551H8mu272SbJ9TGp2pRH6R+Emuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUWZmYTRcNgKJVfOEI1UtYqW2/5lvQbpnFycLWhjoQdfAnp/mQdlUhDe6APttmuNE
	 +2MlITBK56VYDWJIBTaZW+CYUyukKzgmc1AQVGoh1FILqnA0WoDzAvDUdJ9OsKi9aT
	 Dvd4ICvMF+Wg5ATZfnF5NIWZOjaxBVPDmanqLdjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0575/3318] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Wed, 18 Nov 2026 15:19:57 +0100
Message-ID: <20261118150334.729401713@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

commit a025c4991a7d83edc4dd339e3ea86d8ff6226eca upstream.

smb_strtoUTF16() always writes a terminating zero UTF-16 unit after the
converted characters, but get_file_stream_info() budgets only
sizeof(struct smb2_file_stream_info) + streamlen * 2 for a stream entry
and sizeof(struct smb2_file_stream_info) + 7 * 2 for the trailing
"::$DATA" entry. When an entry exactly fills the 448-byte small response
buffer, the terminator is written two bytes past the allocation.

Reserve one extra UTF-16 unit in both budget checks. The terminator is
not part of the wire format, so the reported lengths are unchanged.

Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5192,7 +5192,8 @@ static int get_file_stream_info(struct k
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len) {
+		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
+		if (next + sizeof(__le16) > buf_free_len) {
 			kfree(stream_buf);
 			break;
 		}
@@ -5226,7 +5227,7 @@ static int get_file_stream_info(struct k
 
 out:
 	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,


