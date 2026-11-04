Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831686;
	b=utpUXyuxlneeZhubznCOy0GdPHKp2Zxg8YvtEbBxGszmPnaEuRibY+fYux+51Q/sH6ys
	 0b/oeNbEeOmHjqJVmagpJXFGZEkszAum/OpY1NzHdHzMS4cxYnPYvJc5BuYy5S+nDHZfS
	 7S9IMhhFc1UOzP4Qy6DdQOnyyLjRolbThATRzW+zFgGbwaiIzs+/kKoSd778ngZLBSdxy
	 YgqSX5kgFNzWvgyF1KObXTsJKNcIUVNaORGgY6adaV+zOKJfxDsvgEUam4EbN8H8cYvZn
	 qOgo6EoT7bSCaziePbGsxzIwmQUp/oF1KI1SUGRhDvslRqXGu7WGzrkzNJxo+8voPEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U8Z/0O12iA39FzglBPcEhb3/sd0zNGloRw11YiQwshE=;
	b=bX/itrp6X5pzwzmImvhgn67APyV1+qe82MRdvmBjCMoYcj+/IstCT3Yx6a9dNbw3P0Q+
	 ZzQPAzsqCQGMFeYRft6+Yy5aHc7eIOC1xxJjpA/BGjV3y7t87oeVv2uY74SAUhbbirxkR
	 /B2tAZfUErMvseKqC/AYl82AjGpzH2IAeYRHLGNWE44NiBBJWXQflnvKwStgOi1yAo0wt
	 YwupOcaUoYTOZfMYw75U6zWu4PpTpju1ZrbuzlsxNXUw+sc46RDasJNI3bL7XRlJTg7rv
	 TPtMM+zjuz/IHzUBQ0wn6wjsLBn481Yb9QM2BIBjNWxcrfAkoMXT5XwFJmkQFvVFnOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOgPhECv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A50606A33D;
	Wed,  4 Nov 2026 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jOgPhECv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0E61F00A1C;
	Wed,  4 Nov 2026 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831685;
	bh=U8Z/0O12iA39FzglBPcEhb3/sd0zNGloRw11YiQwshE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOgPhECvObggk5GJ8nO95lBFEljUo4dNLpQvZEPPUJjd7Sz86J/0Y7Ii3nSFIu9YC
	 ZcsoRy2wxiBS+FWoeH5GKZuUEjWVsdwa4WFcrTSlxLMNefxw2RVtVCNtd12/w73QEa
	 far+lwE2Q5GTzxmtQwlAIbNQKt7sl3TxK5VBuHKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0855/1005] xfs: dont try to scrub self-referential dirent in metapath checker
Date: Wed,  4 Nov 2026 16:09:48 -0500
Message-ID: <20261104211107.236510600@linuxfoundation.org>
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

commit 1e7337a3ecebab1bb2ba02187d88b94e5146e4f0 upstream.

LOLLM observes that the _ilock_both helper will loop forever trying to
double-lock the same inode if mpath->dp == sc->ip.  Callers are not
supposed to call us with parent == child because that makes no sense.
Trigger an assertion, mark the scan incomplete, and return IO error
so that this fails noisily.

Cc: stable@vger.kernel.org # v6.13
Fixes: b3c03efa5972f0 ("xfs: check metadata directory file path connectivity")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -324,6 +324,13 @@ xchk_metapath(
 		return 0;
 	}
 
+	/* Callers should not set the parent to the child. */
+	if (mpath->dp == sc->ip) {
+		ASSERT(mpath->dp != sc->ip);
+		xchk_set_incomplete(sc);
+		return -EIO;
+	}
+
 	xchk_trans_alloc_empty(sc);
 
 	error = xchk_metapath_ilock_both(mpath);


