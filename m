Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831593;
	b=EKQajXPNRjyneLlMKHiCKuypTa2TqISTH9uxpp3NgNLS7KqB0Wyyo1cHbnvXa1+JdZ9H
	 v8L5c2mwigOcL998cy+2JjXeL3kmdZl0EVzsq8tjOcdnWEboqfS5TttNMhQC85G8prJJB
	 wCCcIruHR542W+NICGylRQmJxnW9qhciMogZEj2j2DUzzDvLlV6ISaJQhaRmrquvmVpa8
	 Vgunsv27GjPLAsXTG5KaAaixgdL6ObzbPXUyF9grpmevBlGNOX+PcyXNw+kwLqoUgcjVW
	 Frn2kEC3ahJ8w4jKo1Co2LZnPjnfZqF/dzbddG5SH1hl6JWRmI5FPI2sVmwX8lGYWmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGvBPe9L5MfPpRjHMz5++8YEs3w+nGXTuX5qlKUnf7Q=;
	b=Nc5Blw6W1a/H8voQvkcn9P46eGR0YEDdt9QqZA+6BizuMVqJW0vNnmDEcoyJg9m7EEDN
	 QJhk3nhQeKGJaFCzRUZiN8Ao7Y60tnJqIw9CC3BHxfgQvnQkAy47ULfLUZ78zU1vMntCo
	 j1mcus7rsU/zmnRZrNxn7871hYWZALH6BRyqEpe5pkVGB1hFDzzjhbKsefXZnDlB6VCTs
	 x63jnp2sOiP4llv30V/Crtsi7kXUg4Qa0SP+szbT5KswukEHsqpSkVL/oq7ErrkQRclW6
	 XBXhJznsv3Cg8MkJ5hndRXrHky+X+zMaFtvUa1/MaZKPSZWMCdWSTfHTPsTd3fLddNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f46bIDO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3F606AB34;
	Wed,  4 Nov 2026 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f46bIDO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F11F00919;
	Wed,  4 Nov 2026 22:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831593;
	bh=rGvBPe9L5MfPpRjHMz5++8YEs3w+nGXTuX5qlKUnf7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f46bIDO07PheWe7ee5NfFZvrgJ4w2SYMU2RHDc3DTFKUNcJjq23BnWZZaUstrYGYe
	 1tRq3ZRijCFz3CmfET1XooptGljwfqgAfw9o8jRvluSW7qwnfi8gGyOMOtwTcV3O2+
	 BZfwwiXlFH0zTOJbyD+9D0PxFoXh8qXmMJtepqGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0795/1005] xfs: dont repair fs summary counters with garbage
Date: Wed,  4 Nov 2026 16:08:48 -0500
Message-ID: <20261104211105.612974640@linuxfoundation.org>
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

commit 22a8a7501c0146dba4ce99b8256975ffe945125d upstream.

LOLLM noticed that if we scan the filesystem and come up with totally
garbage numbers for the summary counters, we don't actually mark the
scan incomplete.  Because we don't do this, repair can install the
garbage values into the filesystem, making things worse.  Don't do that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -368,8 +368,10 @@ retry:
 	/* Bail out if the values we compute are totally nonsense. */
 	if (fsc->icount < fsc->icount_min || fsc->icount > fsc->icount_max ||
 	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
-	    fsc->ifree > fsc->icount_max)
+	    fsc->ifree > fsc->icount_max) {
+		xchk_set_incomplete(sc);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If ifree > icount then we probably had some perturbation in the


