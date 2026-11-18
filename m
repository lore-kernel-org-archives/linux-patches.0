Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044572;
	b=nomNyV/l4mDv5RNe2z/PpbEgx94BzWW8EC3JiM422cXRNhZpUrZPycsH55ejEY58LrL6
	 Y+HIPGnDaQk4snLsdTK0hzaXzBxuSaaB8GTed6SL2VQNaIiZw2MBM2dNBjmj8TUjP56cy
	 EW55MxHu/3en391u/F+fkcvpBh2JP6IPpXSd9CEBaYrfYHqoyzoV59iTuHzBneXJ5bpX2
	 FrkP/mug1HUCxXNOgcJq5s0gkz+dv+tTlNya/saPoLCidOWZZSGxybH0f5WT7cDIDqCbZ
	 6cBwLPD94iDVV42b4q6WtJb2eam44zCMrf1c/o1UlISCS0JZRTHGqZkkEXxcAhed9/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lYvByjyrMo0d/WZ7xlrkYe2+PkG//067kZQsRhNcyh8=;
	b=0OBZ+1DkVnPLBGqqDR1rD/6HO6vvDJbywI6q9M73sqHasNYXiXD7YAFWB/N4Wu960sCC
	 4JgeKHbtLFx9cpGrL9GqleJCF+hpSzfeBskQBudsqnhkXo0XStzRokPH8IvwsbW2bZMH7
	 e7nI47J90/jiAjbdCmlyKvbn/TsXqH5KzWlFD7mkxzeMmT4UEHuF7sA0inOEmzqspm6Ug
	 WtTmjJDRK22mpEKSKDxSK03+dDLFGyDIQ/G1ctWGAt1h8gFrdymOIdMvRwfqNFzDQRKno
	 qlYGf5OHAyi/IPJRVcv527sLBXPFmi0/0DQS/SaR+oEMebvtGrJGbhaOX55Ha54szCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDG2rH3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC374606A320;
	Wed, 18 Nov 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDG2rH3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4901F000C4;
	Wed, 18 Nov 2026 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044572;
	bh=lYvByjyrMo0d/WZ7xlrkYe2+PkG//067kZQsRhNcyh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDG2rH3knf/HGh8l1IRMIHLOdae3/QqpcN953hxLvBRd0cH3/DgEi46IB4hDjSFvk
	 NwUbBv2P6BY6eqCQnw64BnizXUUCK5pqfWxsqAL0KRqrAh4hf2Ado7RnWENEsi8Xd1
	 Ob6y6DcCbOsmkOq+q278YCS8PGhHhKweW+L5QPCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0613/2857] nfsd: propagate SETXATTR value decode errors
Date: Wed, 18 Nov 2026 15:27:27 +0100
Message-ID: <20261118150223.563167722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit cfcfe0b38a66bbc4122c78a2b75e1b97b3534761 upstream.

nfsd4_decode_setxattr() stores the status returned while assembling a
non-empty attribute value, but then unconditionally returns nfs_ok. An
allocation failure can therefore leave a NULL value buffer paired with a
non-zero length and allow compound processing to continue.

Return the decoder status so that the operation stops on the original
error.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915125636.2849626-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2251,7 +2251,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


