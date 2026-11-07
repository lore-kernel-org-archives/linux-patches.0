Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061494;
	b=pBTj0bldb6XLDh97aAAssXZefYwKoQyaTkq7xrjMfzWu2FDLsqL/jlzYmqVa2ePDBWBY
	 IHEfeuNq8SCwuaWcnSJH36OQyStCWAUVmgdkgX6YqtIismSjPDm42w7QUCsBG4sRN/Qdp
	 2qqTLnKkfMRVD4qDRcyRXSirFuG3pcc9/5pHahFieXDePRrBi22+bu8fN4I+U/gluT64Q
	 1YSt9p7PmFKzP/kcCYAjCNCGE5sgidDJitPnYrbWpiCHms3VvTmiJzx9aSbaq3Hu/NtXi
	 PayRQ4IIIWCTYwayH29pOXZqMiJ4/+Xbl3r4ZcUYDm1A+7EFvqjzpsvlaYK6TAahHCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jBJ6xdpeE+Fl6T3I61AI0thg7wlBhd/Nz6xPbkwp6oY=;
	b=JAWYc9oUcXYB58H46aoKU4WMAcs7IZRlHxlWGx9zKZJ+Ww1umqQBuzHqek7o7Lq9VrkR
	 yfdS7rQ5JkRjgVOGqAMb1lRy2l4C0p1OglqmhKW35Y9b0Avl93+TUl+YRApS/JC0LxFC+
	 Qjh7uZRhisVzyThRZpv85tYO/P+RD984C7IVHI1asLZ2emEpjB5luIfgw5EqGwUuIzPAe
	 s4ni3q6VswRWEcnnN4SPMsZIOTrjn66xcYoqI9SWE2pea7888BZ19KnrDYUI6XMVdrWRb
	 JXlKxrMbf4vSOlb/u5fy7nbmZrm8iejQL9HJmRnkI1f9HfDDeeossBzkZbpfxELP/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTWTKEpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47300606A336;
	Sat,  7 Nov 2026 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTWTKEpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF361F0089F;
	Sat,  7 Nov 2026 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061493;
	bh=jBJ6xdpeE+Fl6T3I61AI0thg7wlBhd/Nz6xPbkwp6oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTWTKEpGwvgr6dfBC6x64W5Vu5z/6UR8P/GE2Nx/N/qtTWXYkcSHWZDnZla8tdLNJ
	 FOdNilULdSiiihffPHdLLz+it5v9BnQVS00WuX8DnWqz+3muyywxCwPFuFCjaxJpr0
	 MoYkvAAuY7qe/S1CXy34iPmR7Ew5Q7+VFiAn8YTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0590/1536] ksmbd: reserve space for the UTF-16 terminator in stream info
Date: Sat,  7 Nov 2026 08:43:26 -0500
Message-ID: <20261107135014.104497260@linuxfoundation.org>
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


