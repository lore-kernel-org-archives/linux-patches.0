Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051971;
	b=VLBBEccbN+4gDuZX+fZJRlwLemSOsiuFUpQGBnr2Njos1wDbJpEtS785LOW62t0k9DUX
	 C8DrhPSXUV9/F9MF0ZV0BYAeXgX0CoajDA4KjpkeMi5c/BaWEMtZZhMdJQXjghzKGqLNt
	 oQrWW5MduLSRdHqiaElplJmAgUkGGv74ySyPBDI6RmN+0UXvTqAo9PK/WMWL1/dYsRbU0
	 XpUCgHJzbeXySAiZgnII+j0vyGAtjKmBT1CCV+uAqb0fSkEdlE6qDdRXq6j3NjDE1aYWv
	 ZkGAwZLyiPopOa1IsKzcTw46ZzoCzJ0IkQt3BzghHn5obHZ7JAyxWv88yobUB3UljAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQzeZCOxaBSrAo8zDklbugyoNU4jhI/kXTRRO9Vtes0=;
	b=u2zdGUQFdRDskgGYYgSX+s+F3zic9HhoxKW9JViCfBGK4RSdxwx6ezsBBMdXeMQGDWxE
	 5M2vd5KRvmMtrN9x4gP4y7z4R0ZwIRiP4dyu+hT/lZCA1eeze3GZB6EvlSoOX/SVQ70ae
	 tbT0L0uwn4tMTc+dq6XTFWpI/9myPZ8sCEpx63tR/DbEhW5+xy2DFcqZ8XlkSLgCAY0/Z
	 7T6gIMA7JW2GI/Hmlvp3yfgcQmkoUnvwobgdZCaJAq7z9utbGR+eMGXS4CWIFGwr9+f+M
	 AmUZrD/6Ioy6qrDACwT844eTnwUAlM+HVgTq85AjNO/YJejBwWsw2u3qKzvDeDvyTwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqlTh4U8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EF9606A325;
	Thu, 19 Nov 2026 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqlTh4U8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336FB1F000C4;
	Thu, 19 Nov 2026 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051971;
	bh=gQzeZCOxaBSrAo8zDklbugyoNU4jhI/kXTRRO9Vtes0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqlTh4U8QkljUFjZmN6Y2c5vwfCgE+YHjGgb4sb3W5u0aGeApn5uLv+CFjz1GTcsK
	 eF60394LHkdZ5qwqE/czK2SE1+j5A7ovr0eN30BbNfu21JDstOfQ0ABYLo78cHIJH2
	 9oLAmhvPQpzmTb/+USAcBS+l/TUpg/uhAZ3LIET8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0397/2214] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118150026.637819426@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit a025c4991a7d83edc4dd339e3ea86d8ff6226eca ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4c42205fe5261..0346305edf8a4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4773,7 +4773,8 @@ static void get_file_stream_info(struct ksmbd_work *work,
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len) {
+		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
+		if (next + sizeof(__le16) > buf_free_len) {
 			kfree(stream_buf);
 			break;
 		}
@@ -4795,7 +4796,7 @@ static void get_file_stream_info(struct ksmbd_work *work,
 
 out:
 	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
-- 
2.53.0



