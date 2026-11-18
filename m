Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044303;
	b=JnGz1yUSlizzmx0Bz1Dd+9cv5MFrGEZK56waV2J9LiXPZ4iQ6SqOd3UPAQw+piiNqyRp
	 Mm1jPpqwbtF8qoS4UM52caGCtjx4bC2EfRPhy3o2PkimzOxiavBWPC1+J8EhY6kVd020z
	 JKMOLv3beq+1y5gYrUtgWxQk/Yh8qqpFlXulrImfi5gDUIqz9JWocDjkmLzo9/JRbrHQO
	 9osP9BlpD2sHI7vyYO08ton3Jt8db4Ti5TFtETsk9LP7SE73gMqtHuuk3bneqLuh63z7q
	 Zd/HppCnbumIOv2N46/MYAbgH48OFytJtaxECU51kVu08bFVckQbvjws5lZ6OljyDxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/u80BT8sRt8EMOIlBWvScChc+NYnvVZ3OSPuUNvn98=;
	b=oxSoWGHz0F+m9lcLj6Oy46Np/ilvOagicaNcbuBoMKICtzLgPyKhUmFywPUQmfuSkyB+
	 hPwW1hxX9s407yCiP2L1qeSPwfAz9+Pv7PxFH8+ByyRsPS0gM6PJFok59b2sZW9UZKUjF
	 P+JCXGBTEpnypePjr19YKY+EVdmSgBvmTNiyHgEHUPTin0uYFmHfTOw5mjCeNxoPEsXw9
	 2hEd3Xx24SNCAF4YBTSASc9ECPCZBBwDwWmVDODYz6y1KcpZzi8BBMi3yNhfMQEt8ASkh
	 ZF+AP9iXm/7NoXQmhgIQVpNpaZinGUtVBrSDFxdmFX9fO9nfZXcOuyEycdsEg9PR4yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtxEaJ+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5954F606A325;
	Wed, 18 Nov 2026 23:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtxEaJ+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D4D1F000C4;
	Wed, 18 Nov 2026 23:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044303;
	bh=O/u80BT8sRt8EMOIlBWvScChc+NYnvVZ3OSPuUNvn98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtxEaJ+oDKmQIiLy1nMwNkryqyV2wpayC5fOTveM6RmuVCcCN10Qr17K4WTD07u4i
	 QtPTqw2n0TcISOy2o+Lm6NVAdYNfuHsca/VoMPY9X5KqH5VZGgBce3gNY/9wiNfndf
	 GCVyKltbrUFXm8gu6FkWoKHPsPCtBrcrdKjy6vuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0516/2857] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Wed, 18 Nov 2026 15:25:50 +0100
Message-ID: <20261118150220.047225997@linuxfoundation.org>
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
@@ -4837,7 +4837,8 @@ static void get_file_stream_info(struct
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len) {
+		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
+		if (next + sizeof(__le16) > buf_free_len) {
 			kfree(stream_buf);
 			break;
 		}
@@ -4859,7 +4860,7 @@ static void get_file_stream_info(struct
 
 out:
 	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,


