Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831408;
	b=P+JbYJ+bxZMGVgUhVTseQnNW3Ws5Ms8cRyr1T8Y0niF7tKH6higJWa13xsLr0BeuDSO9
	 10JFNnDVO2QEV5nsW1lCAHEtzMOlAIBiUUz049XbLTJZkaEBt61QgE4Hu3+35SxMwF7yY
	 FFMbTbQjYPw9mz2De2SGT2+oJNzNweFFxs0TVNXZ3oSLjMBu3wlpNLWNiwvz512t6gszq
	 qgHaU1zq7bzlVA6cPH3Too9uYHl59ml6ubCuPWW97p/4JsXDM2OHhe8grqD3HjXcmZ2DW
	 eWTVJcIoSw1csXc00X3CCbLHIz/C2llBqLVn6b4qsq7N1A4Ksx+GKpvMbYQl7FwsjTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+92QIkkIIzBnqXulst8HbfmrmKvPXVpbH5PpPDMK5vc=;
	b=NPttcFx2UNMElgA79zyvj7JRAixWCISqIXMG3gcQC3mn5bmiAcdxRmHDOyQMtvKieE4C
	 x+BWwzGkLQcaa/1ZvBmbywOsa++Aa3AQ354yOB1aQ6o6tfLv6e2/2R0HLh194ZqYVgEfZ
	 zS31Ogpp48XH4gQxh+cFL8AqAWzyyn1lqBWdfft3/a3jXpefhYxzQknByCRzPr2dYIT3P
	 w6fjbLl72Pg2PE7BXXWLTIEOUgmthcxUhFQRF59jJOaVE8sY8Kj4gVjmMB25JV5LOJs1f
	 UOXVzRSaVguN8IrhWyUQddivAuPJ86CHIXsauSpT0bLnAF/33WDG1nGJC/SGh9l2UcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WtSEr2vy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6074606AB29;
	Wed,  4 Nov 2026 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WtSEr2vy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512341F000C1;
	Wed,  4 Nov 2026 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831407;
	bh=+92QIkkIIzBnqXulst8HbfmrmKvPXVpbH5PpPDMK5vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtSEr2vy/zZoDjaKuB7qYa7eIGWFXKi+YDCbb3Y3d+eMANKe7SkkM8KgX9nC/QmcR
	 xfXUkH/ZaEYb6I0mrXzm7S1QBhwtP/htH9OdhNffPQYPs/1lu/iqJ75zAY+XrzAsVx
	 vg+A+eJugzx2w+3wZMez9X0solSLmfTdr4ug+ePw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0687/1005] s390/probes: Fix wrong opcode for cgrb fixup
Date: Wed,  4 Nov 2026 16:07:00 -0500
Message-ID: <20261104211102.861717256@linuxfoundation.org>
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


