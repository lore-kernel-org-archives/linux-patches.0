Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831767;
	b=Ent/NgfjotmqeJJ/VsbBxZezjNtJfTIsV32n0S8N3m7KJOSpDv9XvOZE5Hux1q6zO/UP
	 WxTuXXnFKTvWCbWdpeCSh/+6ZzOQJJNMWsqpu51+VcQ1bmmAjeu9zAeJ9nXc1LZ378n7S
	 akXFg6x4iMAkdsCLssADa/tikU1PMtSPVV6LwX9k3RckzdpWyEainL3mgUCPm3uvRFGFp
	 wr1nyt+sqT+evJSJvUgNsRJK8zFdl1i56TGiXPYSdz6V9nvP4JqSbRAx5OcTh/Lp7L6vk
	 oiC27muhO2C1/n/9YQs8KFDh0FhbN1GUyFeGjSc4MtSjyYRVDuUVdlMfezVWjUm0pug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTLDNwayPeQqXUCxev4vWaXeKWoySem2X6ZNHf9yyK4=;
	b=lqBZ5cSx3Czzn6TMa9h5i+meesJvCpLm/Ggl8j4hlLP6P4cp7hU/1EqE9Str5mVNj79T
	 AyEtNVmFJuDsCZTE38bJGEzdHGnx47ZxREybIXqquQhShcvHBxIMzAFo3+BajzdnymwuD
	 KnSkX+hzEtTlG0x4beY4K3l0zurhroeH43JhvjJuXCDfAabBH8Qa1BfRk9Gas6TtUjhKm
	 Nkb0WOUauzyGS9EfOgyTrhOpcLsAV2fYgWgDiGazXRPX3FUhIg6HUuNF+dG248SDETmHn
	 VgyUNNlD0v5q8Tbm/thbVbs//SmuNqm9wQCrYJXvhy1tJHeohFOTAhkNfXP1u8s0vCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf+PhCul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76880606A31B;
	Wed,  4 Nov 2026 22:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf+PhCul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1388B1F000C1;
	Wed,  4 Nov 2026 22:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831767;
	bh=bTLDNwayPeQqXUCxev4vWaXeKWoySem2X6ZNHf9yyK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qf+PhCulb79JTb16PNTwJ8d+z6qtBnonA38AkZY1tnMyLNo0NOVHuFLocDdIA40bb
	 ZrVhwx8uVKP9Xj5Y2s8rB2kZInlfZwMzPvgmOCEJTaM+y//+ynW5fNulch+sO/rD6J
	 B1Rz+qFsrDl0mzUM5Z3MaY0l6HEdJABIeliFE+vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0900/1005] nfsd: propagate SETXATTR value decode errors
Date: Wed,  4 Nov 2026 16:10:33 -0500
Message-ID: <20261104211108.408096889@linuxfoundation.org>
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
@@ -2306,7 +2306,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


