Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831344;
	b=ek9OcmoGVD1aZVFKqu8wvcQHYA1Oer/nnqQrdqQfWu8j3Ad4h+3U2XXHB9y4lbWhdRqz
	 e9avTAu7ggTFsvviFI2maeHyBKGLyAZ3A8hnurgFNIk1NuPEdeEJbi5WbuDdvBDpfmPN/
	 EEeibMLEdvVbf+WfHzr7kZOlESkGs94s3wuA3h52BxWBdWxBIcq/To09g/DwlApEVmTbu
	 DjkDQGDKOjza5WoPFQ6rvBSPiB3qzGxvtoE52c7BoClKW39vluDL0etPJ6p2u/MbvRbNL
	 h1FZrMrcfUeqxVPcv1GBkfvapezFqeRERoh3gFCeAJ2EZozVACnaRJMaOsfAy+haACA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6XYsqfrj6v3W3PDPY04qLEbOZWinf1/hG7O4pWZvEs=;
	b=STtrpxGyavWiz4KhLFra0ZIxPdYI8qN4bqZYJYb4uLXaJWJPPWf/WAde++JQBO8uLoCa
	 kQxToSigPCUyVN+u9x/yTq86g0lMHtfM02osvkNe219kIk/+49s5WAyHs5DMkxAWk9Pdp
	 G0gDn9eU2JjRmazXEUqKZu1DaZdvhs1gSaySFVLbZtFKh5UWHVX8nqvaquw33DQyVH8bA
	 n+rqdYjgb3Ce0SmcubCKLYVEiI3v8ckCco3QvniwzwOQVXwun58d6ijCs+YQ3kcPUSR7V
	 wTF7QqcG0uLtnGFzDZAN3poVpY5BYyJaHAFfF7c3xiMyPWtxVDh8fyfIMiKuBN0x4JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiD6zxFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F51B606D82F;
	Wed,  4 Nov 2026 22:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiD6zxFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BC61F00919;
	Wed,  4 Nov 2026 22:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831344;
	bh=q6XYsqfrj6v3W3PDPY04qLEbOZWinf1/hG7O4pWZvEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiD6zxFYgf+b9xW9lsBlN+aZ+VjuyepW1+6VWlV3ciQJz+hcJ0LhJkGMeOckwrbOS
	 nxBEnzJQdVPsvrgdcxi0rljcsIcrHNfrs+mmI4KnaugrLqXFoufBNRRhpZMuofaW/l
	 TFZ2bug3YSFEh4IpL+G3CX4FLSRkaUk7HR1zt2Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0648/1005] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Wed,  4 Nov 2026 16:06:21 -0500
Message-ID: <20261104211101.882237310@linuxfoundation.org>
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
@@ -5220,7 +5220,8 @@ static int get_file_stream_info(struct k
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len) {
+		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
+		if (next + sizeof(__le16) > buf_free_len) {
 			kfree(stream_buf);
 			break;
 		}
@@ -5254,7 +5255,7 @@ static int get_file_stream_info(struct k
 
 out:
 	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,


