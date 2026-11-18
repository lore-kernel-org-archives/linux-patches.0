Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057897;
	b=KK7Z+bOTLeeqq056N5fAMcqIjxaXhUaBLxrxUMNcL1LSLiYNl8WoOO9C9d2o5ROMjRbh
	 4/bJWFvIkjDAUxCq2CKd8oiS94YGEsnW4vp68uqMaYBfB1tcE0rjRN+EUiI+G7FppN3nz
	 bZmvnQHWh8DdNAndz5wYzHa8A37Iil+s0szj7vYSrLkfnHnVlHM2fRPhMgaz/eKtv28Kq
	 /DpKg31AUpbvjcGMKluyHVhrbK1oQ/CM9UrvLwj2bmvpWeUoBqJqM43BtSD6VyHalAXI7
	 47g6yml/K/kYHDLRNXlHLJRVJuPOtPhnlLCQCbep7WX1ItOjYKA0by1J0Dktn5rpAUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgHGz1J5NQCNK2DUjsjLR5Msgh4/aon0c6/ul+n24FU=;
	b=KhKrHKmwGnepn8nVlbBNZ/NDqNfufaAWHnUqNb4jU14ixqdQWKEIKxrw28c+1DlgS9jJ
	 QwFUGP78G2n1xwEsS9MgxzQZYQtO2niM0F1T8kVck7w4nl7JpGpvgGSA6O6HNguZsv8qR
	 RnE8ZBU42uVIDyGWE8ZV61NVWXVoesTuVkWKGVbdkF7PS+0Pi9hW9dXurIV2iAccd0CMJ
	 9Hr8P5qE++qHyKZOSfqfufR9iLw4nkspzQGY1f/nKS3F5QBKh2lf/sPojtUr2FH90+ebc
	 lkvqrucrGC8uLal5xPBbW6PWM93tMfV2Un5Wu4g1sqU2kfB9tp2M7poK5SUnkTRphcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyxRZjPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC54606A320;
	Thu, 19 Nov 2026 03:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyxRZjPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40071F000C4;
	Thu, 19 Nov 2026 03:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057897;
	bh=qgHGz1J5NQCNK2DUjsjLR5Msgh4/aon0c6/ul+n24FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyxRZjPGGYT7TTx5ai8KOAslvsKaa8JQCv9GAJHKHyoLYPTpMPJoxEoKdgj2rkpNC
	 st4xl3hqkvsu1DB+M54hpoLojAvW7GnoD1qNPhFH2HO0nVUZ1p0GRH8+hlvmlUGDJh
	 EtlSQu58jStfdt7SMQkUrbMY0KY3b6MG+cB5IljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0292/1848] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118145924.314025351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit e27c63245903402ccfdb46c576462981a7e032e3 upstream.

The reply to a pool_threads read is the list of per-pool thread counts,
formatted into a buffer of SIMPLE_TRANSACTION_LIMIT bytes. snprintf()
truncates its last write and strlen() measures only what fit, so a reply
too long for that buffer ends mid-number with no terminating newline. A
pool running 4096 threads is reported as 40. Nothing marks the reply as
incomplete, so an administrator reads a plausible but wrong count.

Take snprintf()'s return value, which reports the truncation strlen()
cannot see, and fail the read with -ENAMETOOLONG when the list does
not fit. That is the errno svc_one_xprt_name() already returns for the
same condition.

Suggested-by: David Laight <david.laight.linux@gmail.com>
Fixes: eed2965af1ba ("[PATCH] knfsd: allow admin to set nthreads per node")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260812193349.13347-1-david.laight.linux@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -460,7 +460,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -505,9 +505,13 @@ static ssize_t write_pool_threads(struct
 
 	mesg = buf;
 	size = SIMPLE_TRANSACTION_LIMIT;
-	for (i = 0; i < npools && size > 0; i++) {
-		snprintf(mesg, size, "%d%c", nthreads[i], (i == npools-1 ? '\n' : ' '));
-		len = strlen(mesg);
+	for (i = 0; i < npools; i++) {
+		len = snprintf(mesg, size, "%d%c", nthreads[i],
+			       (i == npools - 1 ? '\n' : ' '));
+		if (len >= size) {
+			rv = -ENAMETOOLONG;
+			goto out_free;
+		}
 		size -= len;
 		mesg += len;
 	}


