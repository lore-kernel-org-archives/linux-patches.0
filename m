Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061534;
	b=Wb88GBvHoJ8Hw7tHbWsyaI6XRjkqN1v2DhGoaQCPd6WnJ2qWxcXAYw+/+3ONFYwRHxBN
	 Vsh9MrQv/UYUkCXG+97gHv7pcPmckAYx/mmjwRM3f/3En2bSLP5KbX2kEd3ahStwOfNwI
	 VHJvm/Bl9SEoPNNdO/G8qOBufGonucztAhEIo7GvT5HIrolI7EROtCNnQdPK1G4Ld5oVr
	 VE23GnDGyvYU1lw7AEjxm65IGikYnRoUod65FN0TJkCX/6/Dn4SILMQMFu164vZs34EjL
	 5edBMzVmnyDnRycGI6UqNRcvEYp7VlgkAoGPdSBop/PJ7mxlKv17f2pjBhsKwZ7SPTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLTHiERv036JvaLMkJDpSTcLoFSUUnC9YpAbDMjZD+0=;
	b=UEDZQhhttFQqCzWI4GBZwojnc0v1A7n7j6ZrkrjzJ9e4EPalEmI20DsOMIWSjpUVO+MI
	 c2onzxNcWC76moLXlJslJmcqU1n+2yck1Y2OJkHHvOKQBFHa98JYxYxH5nUaLDY20BJh8
	 SCzKr2Wqk8dRZT7TEcWyNzF1WOWQpdOILcybae7DbownsgEWXs60fgftBRq99HZQzKG+k
	 U1PRPGe7YcK7wU1AxIEYAuC2Krom0AHrT304ZsCzrkcBCMxmPODaduixK50c7ye7a1odE
	 wdWtIVGMSknB5qgCYLW1ZkUPlQC4CW/2PiQxydgHqC7HGlJKPmdKiLZlwjVBcfvefRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2mIhqGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86982606A326;
	Sat,  7 Nov 2026 14:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2mIhqGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EEA1F0089F;
	Sat,  7 Nov 2026 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061534;
	bh=SLTHiERv036JvaLMkJDpSTcLoFSUUnC9YpAbDMjZD+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2mIhqGadMJW3iLdF920vp6nez7WHX54vwjsMyRncAsKC3w5AzgpjjfrFVHJ5wkds
	 SdvNoxkyHiO8XkpMMXmf8hA6oc9OAaSI7NhrenFqPa07OGgI1aAeXx8OnWPaixrDko
	 GeFfZbSFyrJGN4CMYcDr0v00r0RrLsaH4Rq17C2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 0618/1536] s390/probes: Fix wrong opcode for cgrb fixup
Date: Sat,  7 Nov 2026 08:43:54 -0500
Message-ID: <20261107135014.892908747@linuxfoundation.org>
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


