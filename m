Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044373;
	b=ea538Ypncwt450VUA+5rl/4QCbrb5k/LKthSCpy0kCtxqPCQJQNpKiDxQWh3sC1SWSDp
	 JawqOB4PxcSfrRaINRB8PekJAHJv9HYw1s9ld6zPv+yltWRzd8ViJW9uYMbd6heRuA5C1
	 uPol2OodONn7wDoDZ8QYFuMdt3t0V1BJ7EtpU/ygotKI0Wxa8957ItCVlRlqkHu7k47ZU
	 qptEqIA0+UPmKMa19gkV80FhWAT1uHNoKfYTj5n3FzH3u0JLEnr8NhqjLKVJpkSFn638Y
	 LdXHvaFa22DDsAcC4BHpYQeFBaLhZX5lNxd7ltBDnHBnCRuIA92HopJgSZQ88I4KB+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSDoRWBlwVG2BfyZV35Yj6l8NCsmQ6xBdXUj2cHVaWU=;
	b=ujJ/L4Ebx5XZThY0HTv+g6eB4jx1csC7mIPWoSaw/1Z5JuKCCopb3fCvPcXKCtYJHUuU
	 3qmtmi1NeKtUN1M0djxwxUhcTn/aTrWMoNpLLQFct/in/9fR/OHg52CEs5eEBcY4v9JpY
	 ZXf3Le8MMsbXxjgFwUyaPUD+Ti7m74emIM0iOhZfvOJVPvxT0bMRATV/tXaNFlnuwgC+k
	 GHNs4qJUsFVGAO4dlEZ4ITabZqdTMmvQOhsEpxM2UrFXgiJvwLT45EO9rSdR8mPL/M/Nl
	 JeFLRGcK5v1vS/o6/zmF632gcoxYSQn0MR/zUJqVSs6mitj5dZQqtVyl53nRRKxmu2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxxrWcbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC9606A325;
	Wed, 18 Nov 2026 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxxrWcbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671571F000C4;
	Wed, 18 Nov 2026 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044372;
	bh=PSDoRWBlwVG2BfyZV35Yj6l8NCsmQ6xBdXUj2cHVaWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxxrWcbcqRe0f4KMxwFO/icXxp2dDW41jj9Bou1dmgJHoRgv9FE7KpqqHD+WtXt/U
	 tdEIaX4jKtJ3zdyf8PlxiFa+XWRn6ur9D344zXSovvpJz0vAUpsObSQtoP5NsJNIeQ
	 2P+/yd6eTHpfDiJnyjCSdORBV3FqCy1eQVhsoHQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 0544/2857] s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()
Date: Wed, 18 Nov 2026 15:26:18 +0100
Message-ID: <20261118150221.073843492@linuxfoundation.org>
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
@@ -1583,6 +1583,7 @@ int cca_query_crypto_facility(u16 cardnr
 		u8  subfunc_code[2];
 		u8  lvdata[0];
 	} __packed * prepparm;
+	size_t datalen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(parmbsize, &mem, &preqcblk, &prepcblk);
@@ -1628,27 +1629,44 @@ int cca_query_crypto_facility(u16 cardnr
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
 


