Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829025;
	b=w2eGCjStqTJgDKImJV24XYJuDQLVqjpTjZ4XHR7DQoiNi+B9c5eQcZVX/FWTuP+AioPk
	 35NvuNgSiaEn11BEWZDjtyzLu4WfPdAQu8hxUFjm6eG4zb1odO5UZDN/tfhwfcO37PEab
	 FfPU0ZDCRSG+jwJkUVtpMi5EV03048CpWEz+NNbtn5Mec99Jjen3hLIQ6Jp6huWVj7Pbk
	 Ob1e8saRh21jfC8ar1QmAyIVohVEt/z0rDHiZjINcIc7Kv55wuwx+/KMruvmr6mHMWrTl
	 hvsKFxmI6ll9DMCar+4bFcbEbuqcD7MnUaVBNx9lq87eOnIPSK0gGge4hkHMbWuFQTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+2YY19RBQY49RYlOeeEjFBwvm+N33fJ/o+DHqu5XOUU=;
	b=iA+aAqvDsTpUumJhbgkf3IzEh2eWG6J9kaeDhXwQMkt/uSp8aIq2MHMJNNTLh2DCVh4p
	 A3vmJm7Dhbs1bZAV2Hg/OqCt539ZYRXYUa6ODjHpwJ/H01jn6GSyHFK08sTe7AgAtELom
	 7Cjmavy5YnMVQOHoRNbp1xCHbecua3ETmUMgmWIxdf4IOkEpRObfZ/wC3OsxPTGSgR3bq
	 P3Q+962VIJk+nzNypQ7lOnaRXZKpoFEf+IiFaVZkroLqaArJKM62GUtQVUQ2r+OQIXWSC
	 6weyEbq1goLQnlRgLKWl5rOCflHtiyHdT9PaqswWWlz6P9KAaqnARcgnxU3NGPlU4xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SpQla/Kb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925866070745;
	Wed,  4 Nov 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpQla/Kb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CBC1F000C1;
	Wed,  4 Nov 2026 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829025;
	bh=+2YY19RBQY49RYlOeeEjFBwvm+N33fJ/o+DHqu5XOUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpQla/KbhBVfJ5lwKrw7EtN8TYngxQRa/9wlOD0FhuUUM2bFU7gsTlcAxhku8+JWm
	 0ZnRAh8lHs7NzY0FVQmady8/Aq6Y7sIWsohhyx1Er854N+u2GgERVZDNzX8uEaCw4X
	 lfkasfKFy1UAcTYqG0EaDRiYQZpUAZqWHR8LFfNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 397/547] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Wed,  4 Nov 2026 16:09:41 -0500
Message-ID: <20261104211049.586999157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 32f0967ea296d447925465c98e7eec71d4e2f755 upstream.

decode_devicenotify_args() hands the server's notification count
straight to kmalloc_objs() as the array length, without checking it
against the message that carried it.  Bound it the way nfs4xdr.c bounds
an attribute length, against xdr_stream_remaining().

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback_xdr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -271,6 +271,13 @@ __be32 decode_devicenotify_args(struct s
 	if (n == 0)
 		goto out;
 
+	/* sanity check the count against the remaining stream */
+	if (n > xdr_stream_remaining(xdr) /
+		((4 * sizeof(uint32_t)) + NFS4_DEVICEID4_SIZE)) {
+		status = htonl(NFS4ERR_BADXDR);
+		goto out;
+	}
+
 	args->devs = kmalloc_objs(*args->devs, n);
 	if (!args->devs) {
 		status = htonl(NFS4ERR_DELAY);


