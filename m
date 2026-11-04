Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826997;
	b=nJCFiAP/OpRsTZZhfUVq0E+BdQR3bO5PcbSVDzNW9JC1TEYh42wCj0nMXl7rXw9kAG4T
	 NB5P+Y28ghMzQ2cqw3tleJ5CKNqwmo0AwAqsjbgs5sR4rDT7df9QVPVs7d3G4qI8PPV7b
	 VnHyPM/OAR/b7R+hO4IYtkuNVUGDHgrAZlv1IwT+Fg4wOYiKHSyGKslnHDrC5Ejaj9Xbg
	 7iPYRa43L6kwfLXPFOIofbDd727PqSrd6v15lgQ2wJA5pzz1T2teS8indSImNxg8JKkYR
	 mdqzW+/xbcu1z3QxxJlTDN8OKtuyMRNVfIzKjOXL3QtaQlniMsgWIaZO5aMxPqtG0ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O613nbINAxQYIAQRpN/GFJqlKtjMd2oVDmizEQgPbRU=;
	b=G88sYViL+jSd3khtMsUeF5tL59JLknbxXn09ItqeDjcN7EK0MbBy9Hp4wdSBguG8TEc2
	 zYP7DouAwWp0HrKx85svdgAKakhVeEbTCJLsoJqSGI4XthEff4LXjFVC7ri/d7N152CJW
	 g9wYgzTWDnl9GuBz8sHffPhIwwXCrsKj+80A6NN2MFd/4s0UeK9VojDe22QMrN7tp82Rr
	 PQOjMWLahkgH/gJI7x/5IzdfNbtElOAgWFFC/PEMkqQ2EA4SAZbwrT0BUZ6iSqx+XqlRO
	 XcO0VZNVLVlZTKE+BUMzONIbSf3qQoRDyzilLp6HGrhVVM0+iMKkbb113hYloLleQhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtW3lHHM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A2B608660D;
	Wed,  4 Nov 2026 21:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtW3lHHM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC51F000C1;
	Wed,  4 Nov 2026 21:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826997;
	bh=O613nbINAxQYIAQRpN/GFJqlKtjMd2oVDmizEQgPbRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtW3lHHMKDiordikw73f04yOQSB9pKOYKq4IMsfCDA9QjTm3ma44rKEhrd80NxGtw
	 07cujSncdpxf9fxjQSndhMXZcTV5EnPdsqpWBaNIFdvqNPnIymmp1/0I5bqgx3NWRu
	 E7xN7glaPsiucgoQPp+dJGP7dTtsVdXS4K50v6Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 131/547] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Wed,  4 Nov 2026 16:05:15 -0500
Message-ID: <20261104211041.899375397@linuxfoundation.org>
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
@@ -6936,7 +6936,8 @@ static int get_file_stream_info(struct k
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len) {
+		/* smbConvertToUTF16() also writes a terminating UTF-16 unit. */
+		if (next + sizeof(__le16) > buf_free_len) {
 			kfree(stream_buf);
 			break;
 		}
@@ -6970,7 +6971,7 @@ static int get_file_stream_info(struct k
 
 out:
 	if (!S_ISDIR(stat.mode) &&
-	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + (7 + 1) * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,


