Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620178;
	b=1+uXOIq5pUsFizeVL4MZBMNQCi/3ytjajR/98TPl5bJpZVxvipMIgfApurIp9i6C1w/j
	 H0hDCY9FcRR+pofUEfrC+4ky3JAVtDN5OK7HmINupj8oGqoi34Bi3ii6zkg0QX3tZ3ivH
	 yUA/Iwx6sXgxCifexify9dIAvFBeOrIjWoNPIlavDNT7JmBMIvmu+NPHIyh8v8IZXxJ8B
	 P7lZK9ewWbfUXb+iVQex7exE9bhu8mLtMrR5rwk9ot2nh9AfT/zJ3pU4++uhNWnbLB/ky
	 iGXN2FViQTr8sqtD0NwQizhbyzLcxf5Lw0SvgJ6fMmFhWVuLrKxYHx0LzYLxuyVsTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RaYBp+TNEmQupigmM2B6qQmuT3rpts7RkAZXfrLy+H4=;
	b=iMiewqjjGJc+fwLb6AckUMiV7H73Ulu284ZfWTfIjmyo+e2VAGxEjESB8PVK3B8bzUe3
	 6g/9vhi3OI/aI0L7bGRC72TfUJYtT753fncbT9Z+Dl/iygLD/nWjaPblu8GsvMA/bhmvy
	 6BLq5a0s9RvZrCth6o/k3JjVRdWtUaZ8nO0OKQLR5djHZxm+Nb7PowqFtL1AWn1uy/Nq1
	 N8/HCPwghRyDLKYfriCwnoBbaKIcYUL/lE21EduQ3j9wrbI/JNguPjPmcznokyPZhmYa9
	 1f6o1CNnCy/LMY88BZXVzBBnZ1ot+wPuWdVGSrsYnb5fuPGW8qSrx1hemjzWcyfn0ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6y0dFks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02B4606A329;
	Wed, 25 Nov 2026 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6y0dFks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2F1F000C4;
	Wed, 25 Nov 2026 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620177;
	bh=RaYBp+TNEmQupigmM2B6qQmuT3rpts7RkAZXfrLy+H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6y0dFksYmjNdoRViIDQa49RDtgeo0q9QjzhBQuQytz2In/0rHZc5IvyRP+lLcRjf
	 69S5mn6MVdVS6Tw2EozN0q5/vqPiy2XDO2aGnWPcwhbim10bOoc/fxMuBURI33v/O5
	 8KvZM2kaVzR9PF24ml8YI6ODxuaxOcKKUff1uOLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0832/1005] smb: client: bound invalid NTLMSSP signature diagnostic
Date: Wed, 25 Nov 2026 15:36:10 +0100
Message-ID: <20261125143841.211915724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

commit 0584b02669c3e76188097174b4f25ed13723e94c upstream.

The NTLMSSP Signature field is an eight-byte binary value and need not be
NUL-terminated. decode_ntlmssp_challenge() prints it with %s on the
signature-mismatch path, so the diagnostic can continue beyond the received
blob until it encounters a zero byte.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  decode_ntlmssp_challenge

Print the fixed-width field with the bounded hexadecimal format.

The patched kernel reaches the invalid-signature path and returns -EINVAL
without a KASAN report.

Fixes: 0b3cc858003b ("[CIFS] NTLMSSP reenabled after move from connect.c to sess.c")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -666,8 +666,8 @@ int decode_ntlmssp_challenge(char *bcc_p
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cifs_dbg(VFS, "blob signature incorrect %s\n",
-			 pblob->Signature);
+		cifs_dbg(VFS, "%s: blob signature incorrect: %8phN\n",
+			 __func__, pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {


