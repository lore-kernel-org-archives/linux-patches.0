Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831834;
	b=mIMJq96MyCSQ+8q9AC5YKQEbFQFW4u7SuHxjgW9Z6QVPmiPP/AjtGr7l/qZ3GOeNw1yI
	 eYDOUn4+Sqv4A66ssSriyYl7kXpbSh0xArlp86vUJbNAmEJrPUj3UmRTUx7OX3P5NmEXW
	 AXu9nlsaYHxpdRw3suSvSm+HSW1eQKV3tz4mojzUf/zq42DkC8sNR/v3b7mcc3hmbIYe/
	 HkDwP/O1OAsLR7jIE5psXjHjMl8E6X1NEXv+vFeJHD13OmxNrhFMgOsirYjrrpZLj0R7k
	 SmysMwb6LkwJ31MUr6T3yBZb1U0SbPCOWgxF001Ih00+VFa27HAqPl/TxWq276rkroA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7RXHuIWi9S/4ybWPRzAnZd6YW7uJZEhdyxFdkRRbDk=;
	b=EztdQ918N0OkJmrrQjec0NTL8XBaAh2GqnZgf5i03ekNkMXQVt1JZEL/eUPZHx36DMqj
	 m2p6yUiP7q8x0c1POLFkSDbT9qIhekg+T63hMMDEhFK4B+bswsZVmdwnBhMksTFIy8+GG
	 bWg5cY5VAVkGj21HVyo55eC4/o9f/ekmF+UONwMztoHQftZwUeqQ3wyg5NPE4Nh69TzSC
	 hybbESwpVs3SaT2CUTOpvmz0CkE2UkLe3RF2kXLnbfOLH0AQOeOUCkpkMZVnuO2goaz71
	 Xgl2LPPHzC0FWKMNV/OahE9fL/IyzCaTFj/9qkliURRc9VYRa6Trg51Mo/eh5fPCBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZhUJCyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167F9606A842;
	Wed,  4 Nov 2026 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZhUJCyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACA81F000C1;
	Wed,  4 Nov 2026 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831833;
	bh=x7RXHuIWi9S/4ybWPRzAnZd6YW7uJZEhdyxFdkRRbDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZhUJCyzYfHTAJIomn6dZia9cQXylVfqPETkkbMSGPtkIqeM40dlTl8UphB0pMDYO
	 2TM7VCHDDlIP545CkiQNDEE/JF+lg/ybRWYBl0bzLNW38WCMpKHz3VdzkzlvihvkIP
	 sy5c6ZPVu8TaBlbn75dzMGcZLCM2u3zkKiFDYz5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0891/1005] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed,  4 Nov 2026 16:10:24 -0500
Message-ID: <20261104211108.177469247@linuxfoundation.org>
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
@@ -468,7 +468,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -522,9 +522,13 @@ static ssize_t write_pool_threads(struct
 
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


