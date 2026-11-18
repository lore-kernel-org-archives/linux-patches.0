Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035221;
	b=TULQRbROTJqdnLra/UZBUQ3qc7PRD/DwTJ3HNHnNxrIvxzZ86J1kAyFzHMlej3EYYWee
	 TsfQyBSU7t6s9GG0B3mB4mmCRHVrRedsHJMrGD0vvB6j2fU1V68EX7fOpNK7JJI3Di95x
	 Yf+qkY4eKbH4spQMO2jcTwW2KtQzCPMsjInjEu/4BIo8KEJaJRsY2wfnmRMCGIBprNzk0
	 jQ5vc5rZ6Cg04ZbpHy8n7F42RPjv71MJ2VnCVKIWH4NwvGe6I38Jp1JfkdXSHdoa0C9Ir
	 B/6sMtVrC1qB3pYYb6+0L7chH/BztLUYMjdbNjm8axg9McQsgxLuQBgLA3UKzizXZXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmVlni81Xka3z7Fo4NYXei2oy3Gkf7LduW10a7QpT/k=;
	b=kyOIhz1WlgXern/Vg3UhiFFabwX4tW4yF3lMAySDuIT3odJMECDrV8Aq72AlrrR3pGc5
	 FdOXW+rj3HDJl/yTMFjbyVWBEli2J0FeHWBZXeNKyoBd5bCfZfGrYG89jidN/7ueVc3Vh
	 /SC8R/bXIlHE1TlLmpO7CNrs3aow5ZwomhCbzUIPiG28Gm4K8GWmrItLpDFr5yKFrdcvN
	 XWxazQI2c7uV8ZsaeEodTo9eWwND7SeE7LyWH4Vbnu1pp+1l2Z4qB+sq23cGHRZzVypgg
	 ZWkqT46OR3/hqyXicKb5PLGz9Xk4X1tGPHljHbmEskpx5ky16BhkxIa9j/mZPv3CqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGTooIZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E69860A262C;
	Wed, 18 Nov 2026 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGTooIZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7FC1F000C9;
	Wed, 18 Nov 2026 20:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035221;
	bh=qmVlni81Xka3z7Fo4NYXei2oy3Gkf7LduW10a7QpT/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGTooIZ8HDpM/2SMPZwB4OW8WMgRQw1o40hOL3g+BoP07UXw2n6L1Xb9goZE0Mr8k
	 DiakKMFjqxfvtyxOPMQtGt0KhMo5q+h+MOManDljnE+cTkOJaP3wE7KCfy2sJ9DbEc
	 V1unklb7qKnqq3zd9h3ltBGv7qWHi8d9ar219SjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 0598/3318] s390/probes: Fix wrong opcode for cgrb fixup
Date: Wed, 18 Nov 2026 15:20:20 +0100
Message-ID: <20261118150335.618269765@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit d7ccab11a13475e656b9d2277900422c1bfc12c5 upstream.

The last byte of the cgrb instruction is 0xe4, however the probes code
compares against 0xe6. Fix it.

Fixes: 6b169ac9b434 ("s390/kprobes: add support for compare and branch instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/probes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/lib/probes.c
+++ b/arch/s390/lib/probes.c
@@ -99,8 +99,8 @@ int probe_get_fixup_type(u16 *insn)
 		break;
 	case 0xec:
 		switch (insn[2] & 0xff) {
+		case 0xe4: /* cgrb  */
 		case 0xe5: /* clgrb */
-		case 0xe6: /* cgrb  */
 		case 0xf6: /* crb   */
 		case 0xf7: /* clrb  */
 		case 0xfc: /* cgib  */


