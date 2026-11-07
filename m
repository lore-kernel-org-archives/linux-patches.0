Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061543;
	b=5O00lvo6nsDmK6SW1MIeT4U99dDuTtYEmUtEcG2cNoHzPAA9vY8Hw/9FiDiOJgRyq5cj
	 JDKpwPfgXmSFAVN1EYhKQnP7+AfbFKyqfHjtVEYFzGTBDlf1d23tKGCeu4PGj19mWvlRL
	 b58BmCNgh+pp4AN1Ofw74xlLB/5BBTbnDsEekaOI6njc2YB1vrwZEQ18Nk82sOppSEuUq
	 tdSzBoRLH5b2vxQLcpRd1g5JM3FqQV6xx1alc7rnxczITc8TDouzTEh6ptQalleiSZ2ah
	 Bw6GT5G+4tP2YNf2jDy3hEpmqe50B+R0WZud09w8hyMmH8h2nXoEWGKgUc5wtOkIFzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qlb+UqbFsSP31277AAT86tPMifVb20BqKB2Frdd+vg4=;
	b=qlVOKFIGkoll4pIOAjzToZH5qkYTU98sX0I/jXeC5EyGRSdIUoHHYM7CjzCGugysOBvL
	 8Ff2qxWKSrB8Ip2x7dmm1vW/5uNEFBN0crQn4jQjxw3SUpgh8tDLCRPOyR6CJ2HtuEqiw
	 WceN6DrlIuSHGHfQptERE9mnp8v3F766o62ZhJSxOa3chtZuFVnjU/38v5X2avVh4ZZnQ
	 638BqX56to2Aod3D4pkRhcjwPmhi9OYvZND9z9YiUT8uWvbCe37z02U1eojdsVQV7XqTT
	 O69iy3Mda3v77Y4PZyr5AZsBLZf8hHm9JYllVozlP7nspclHDWmCA/P/RQbIWKmHpkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W/BkTH0W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FCB606A326;
	Sat,  7 Nov 2026 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W/BkTH0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0181F0089F;
	Sat,  7 Nov 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061542;
	bh=Qlb+UqbFsSP31277AAT86tPMifVb20BqKB2Frdd+vg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/BkTH0Wof2gKz9i0LKzKeSL7gUpvAEH6/e7baM1OKjw7nJ5gVuaykC4U2AiqjEW8
	 6Xn+OvUn3uDA5WvLWwL0bKWVRYju5ISn7YT/kcm2kBMomhDLN1cDm9EzoaMfaK9sSD
	 fyeitUchup5j5fRK/goznjzvJtGb3rFx2oXHl5pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 0620/1536] s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()
Date: Sat,  7 Nov 2026 08:43:56 -0500
Message-ID: <20261107135014.946366420@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 9fd7fca66735307fd7afa3450882a55ef80f2add upstream.

The FQ reply parser code blindly advanced the walk pointer by a length
value read directly from the hardware reply payload without checking
that the advance stayed within the allocated reply buffer. A corrupt
or malicious device response could push ptr beyond the cprbmem region,
causing an out-of-bounds dereference or kernel memory exposure via the
subsequent memcpy().

Fix this by tracking the remaining reply buffer space in a variable
and validating each device-supplied length field against it before
advancing or dereferencing the pointer.

Fixes: 2004b57cde6b ("s390/zcrypt: code cleanup")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1559,6 +1559,7 @@ int cca_query_crypto_facility(u16 cardnr
 		u8  subfunc_code[2];
 		u8  lvdata[];
 	} __packed * prepparm;
+	size_t datalen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(parmbsize, &mem, &preqcblk, &prepcblk);
@@ -1604,27 +1605,44 @@ int cca_query_crypto_facility(u16 cardnr
 	prepcblk->rpl_parmb = (u8 __user *)ptr;
 	prepparm = (struct fqrepparm *)ptr;
 	ptr = prepparm->lvdata;
+	datalen = parmbsize - 2 * sizeof(u8);
 
 	/* check and possibly copy reply rule array */
 	len = *((u16 *)ptr);
+	if (len > datalen) {
+		ZCRYPT_DBF_ERR("%s reply rule array len %u exceeds datalen %zu\n",
+			       __func__, len, datalen);
+		rc = -EIO;
+		goto out;
+	}
+	datalen -= sizeof(u16);
+	ptr += sizeof(u16);
 	if (len > sizeof(u16)) {
-		ptr += sizeof(u16);
 		len -= sizeof(u16);
 		if (rarray && rarraylen && *rarraylen > 0) {
 			*rarraylen = (len > *rarraylen ? *rarraylen : len);
 			memcpy(rarray, ptr, *rarraylen);
 		}
+		datalen -= len;
 		ptr += len;
 	}
 	/* check and possible copy reply var array */
 	len = *((u16 *)ptr);
+	if (len > datalen) {
+		ZCRYPT_DBF_ERR("%s reply var array len %u exceeds datalen %zu\n",
+			       __func__, len, datalen);
+		rc = -EIO;
+		goto out;
+	}
+	datalen -= sizeof(u16);
+	ptr += sizeof(u16);
 	if (len > sizeof(u16)) {
-		ptr += sizeof(u16);
 		len -= sizeof(u16);
 		if (varray && varraylen && *varraylen > 0) {
 			*varraylen = (len > *varraylen ? *varraylen : len);
 			memcpy(varray, ptr, *varraylen);
 		}
+		datalen -= len;
 		ptr += len;
 	}
 


