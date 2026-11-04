Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831608;
	b=tGsTccGnpicwg96KUk5IOTC3BTeqZY9pSMS55vnA9Ijm/Y4IXrIbJ6a7jgNqZ+xmk/0r
	 lAKYUV5TI8WddL0Q7RBkg+7c4mfa7NVvVNNCft2BBYWPuH3lXg4cssT2taZ6enAl5dqoH
	 ndpPyuy2EzhpGOJjgQX1Q36dMVvh7Niu8jdombMMaoq2OQuogiyuAEntOwccSSxtqYqxX
	 5L4jlqHWQZml0Qdpv5eRIECTDkNRXRCrh8vY6NtEIkmQWlBVtxe1/3EN6YyNTrVw6PNhh
	 AvpG3dPwDJKyV8mPQyZE6Z2iqH0O7kq9Pbu1ct1vpm7C7Dt3voZN14PqSlQIdLOXG0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9TkqlE7AJSrveWrGMTLpbCeJVYg3qGF0OMvOJjX8BI=;
	b=5MqsCCiTQ40qemmOgcFzDHSCXtEjv4dLpCo3Lvmm5Hn2CSCO3DwcNQXqP6a7VSFboyXi
	 N83E7lJTa78vDH9oHzPif2xkdQGinwji4Qy0ioaxDBflBsQrtt9KZ+lLGqTQAu+AhrQ4C
	 /6E5mtT5vwpJqMEbO1WbWyks1YFVTT4fElU5IVe6R0RpKhSvm9oGvfXOuIguZUfPXV8U3
	 eTC3Q9N5e51ao18FsghndUn1IrFGjxNa0A7dotqajdwk/pVVp9zuE2OoYwgEVJ0dUj5iT
	 FgYdMTyO8PzXpIm2x/ws6IihPcpLF/BZrQIRDwXeqY7S+zcHEvHWxqAT1hYwVXKZ49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOa3uKv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCF5606A31B;
	Wed,  4 Nov 2026 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOa3uKv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C461F000C1;
	Wed,  4 Nov 2026 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831608;
	bh=y9TkqlE7AJSrveWrGMTLpbCeJVYg3qGF0OMvOJjX8BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOa3uKv0kddhf57uVMhine8t9iH1CKSEVZQMEtFS/Btg/AZE9AxwH77g8D11g0pjZ
	 9FBc0kFn1xz2TdQRNY7ND/WDV9Lyyq8tYvljST2Jg62Xwm+3cQty5FkJVtOYv6Yi3H
	 ec5K/t4s3AIL5OdMQuMhT1JE6Zyhf8svq7m0XAiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0808/1005] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
Date: Wed,  4 Nov 2026 16:09:01 -0500
Message-ID: <20261104211105.988503407@linuxfoundation.org>
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

commit 6b8d60784b61a17bd591cb4c6e8aa9ed29c24f5c upstream.

LOLLM complains that xchk_stats_estimate_bufsize underestimates the
buffer size by 1 byte because scnprintf wants to store a null byte after
the newline in each line.  Each call to scnprintf overwrites the null
left by the previous call, but we still need the null byte for the last
line in the file.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -166,7 +166,8 @@ xchk_stats_estimate_bufsize(
 		ret += field_width + 1;
 	}
 
-	return ret;
+	/* null byte for scnprintf */
+	return ret + 1;
 }
 
 /* Clear all counters. */


