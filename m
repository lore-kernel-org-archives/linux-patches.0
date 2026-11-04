Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831584;
	b=Q5683RUIucFP9mo+1ic17Orc9zSFnPIHxLRAmWivnCr6jvuv+J/IaGzIz/NOqN6czUgh
	 d9Sv+wnw9t0p4FW7TlHNViOskFZqmK6+UnARkQYTTUZ9Tnu21FZ4LMQmqvHEPGZ3GOojp
	 RoNVkIxehZAJWKoY8jSNamSwZnCgrspzyYzjZmQEzV6R68rTISJKpc+X4rwfHiI70cfFP
	 apZ2wA816f/j2BvwbRPxNofxtLZ2aWsaCIjeFV5a3iIIPR1jV02NKUrlLzefSCKX/Ft5z
	 ya6ssDIhEY4EaOt9eaH4MRegST/I2Jr1un+n/KkYE/2MRcpFahIAGlhW+izqSvHyGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0k26RVC93+Jbfuk2aLRJycmXTY7PaAUMlR3ma9+kzg=;
	b=oxt1CweTaIpHBIl1ebWmW5gg65vbdsbBxwdOjO3k/oV6t4w0kMaitCe1wU41lY6vSZEM
	 J9sPANrsNcx9dGOBBFOQkg/J2YCdlRU0iqdTfVMEXcrw9GguMi9Xqqd+hJeDUN9wKfLsa
	 qqTm5xgxCwDmaPuGKs0XFsXoaZ8jpMbfFPBjumNi80EikRhff636udf8lBoqdnaOuGpJU
	 dFtOZmdk1JM/g9iayLgx8YUA3tsjVM/1fIp5KXPc49jTW3OTsJQSf05xlPwvljJu98Obw
	 +c7z+vuDZJG0rilMtga9CTOpom6rAArhb88dGJyI44tOQ2+g0EGOGjjKeWi2VzCyBaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wN4tt56O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD32E606A844;
	Wed,  4 Nov 2026 22:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wN4tt56O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F3A1F000C1;
	Wed,  4 Nov 2026 22:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831583;
	bh=p0k26RVC93+Jbfuk2aLRJycmXTY7PaAUMlR3ma9+kzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wN4tt56OVtaVj9njayyXvevJKCUjGrnnTcHmJjq5coOeyhkDQHyOJ+mtc9gCg60ni
	 zJRX5iuThYsqDU15GorqEmcXIKIhPdyGPPCTwVab72ksmeL1N/JE9u3f7LPwgiQSAd
	 Ro3Lbq2j89esvg/NjKobvXBQ4bkZOpcw3LGZpt9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0790/1005] xfs: flag excessive delalloc rt extents as corruption
Date: Wed,  4 Nov 2026 16:08:43 -0500
Message-ID: <20261104211105.469827385@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 2b47be015a5e54f4a3d62afa636ba593de9b67f6 upstream.

LOLLM observed that we should not allow repairs to proceed if the count
of delayed-allocation realtime extents exceeds the number of free rt
extents because we can't install negative numbers into the superblock.
It's unclear how we could end up in that state in real life, but let's
at least complain loudly about it if we ever encounter it.

Cc: stable@vger.kernel.org # v6.2
Fixes: e74331d6fa2c21 ("xfs: online checking of the free rt extent count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -607,6 +607,13 @@ xchk_fscounters(
 			try_again = true;
 	}
 
+	if (!xfs_has_zoned(mp) && fsc->frextents < fsc->frextents_delayed) {
+		if (fsc->frozen)
+			xchk_set_incomplete(sc);
+		else
+			try_again = true;
+	}
+
 	if (!xfs_has_zoned(mp) &&
 	    !xchk_fscount_within_range(sc, frextents,
 			&mp->m_free[XC_FREE_RTEXTENTS].count,


