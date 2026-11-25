Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623503;
	b=iw+MXk5mZ9kY7lIRN9iaOTMiOm7+5cerWZUgwKaCD9J1wojrnLnxfCN61u315pTHmoDu
	 Mtbbknekk82aqqshufgE5TRfuV78BceRV0bCPHR/QZbtsgZU0dsVGzZafzCzCeB3z7u8f
	 9+Y0DiV6T1VNHchn2SfCnYhdXtB1U65HVAg6ywZFChcQh0EH80TimYya7bTBq2fip1wlS
	 +CsUUOyDPmYmCBAPiik5HEYRPApykvyfN2v1l1LEEtH+8NJfUfmc6aJ6MhH+4ZJPQskMJ
	 xk7cyB9uioO0vBX4HjQw0VB/Q2gY8I6IlJCWYS1lLi441ia1L9zlkUG2Ncm/cQ0cqzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nXmGzzxnCS22f+ercaHbmUvzlyltd0jr7J80VQksKYs=;
	b=Jl/ysipecLPIScO4uHI7pp6GFXCt73J399HhTAM360eSp368tNy5AhY3LIkzDrTYbQsc
	 ncNJR7h8ktRsbAtPYKcRkOKGd2v2J/YP5k+YFJlkqW5h1s51/f8TAdKPY1emkmHh11ijZ
	 nEYclyuGRT/ytfByz1qEvTJmK0JcdhQGBcO6R1lKqxCEfE8WIPGUxJeLCFrugThiNeHqO
	 nWJfNd/CIwCV++GgBwqmJC1emjIROezi/lJh0jWqDooo+1Nf9g2MOZoJkPKa+FJJyp5mz
	 OdFe95cOJWqtb3pbWLts4M5+viRxBfs/5+n5pAZErk8BM/n+uyOGS/ufmVo4CdCBpvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nF5jdQJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D338606A321;
	Wed, 25 Nov 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nF5jdQJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1041F000C4;
	Wed, 25 Nov 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623503;
	bh=nXmGzzxnCS22f+ercaHbmUvzlyltd0jr7J80VQksKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nF5jdQJcAoPpltwPSsXVso/kPEwBrSjcGS/qK1+fm/QkAxNwf4lulLfFl5TWgI7tC
	 ZgQhi1Iz2b5zjMNPVZxdwv1mRiYbPsswQU3aZNuYPuwcBUcIgnPqF+bERGFm6QeogW
	 hZPw6JnKFliXxwgzFTHOwTpcChTlgzTG/nfxGxwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 836/990] smb: client: bound invalid NTLMSSP signature diagnostic
Date: Wed, 25 Nov 2026 15:36:43 +0100
Message-ID: <20261125143841.613566830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -934,8 +934,8 @@ int decode_ntlmssp_challenge(char *bcc_p
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cifs_dbg(VFS, "blob signature incorrect %s\n",
-			 pblob->Signature);
+		cifs_dbg(VFS, "%s: blob signature incorrect: %8phN\n",
+			 __func__, pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {


