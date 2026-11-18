Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051847;
	b=zSkyVMl29DvOjNQpb9yBkRzpKknS7oNmAA+GO2y9QiQByR1dvOF1Yil1jiokaGA13jh2
	 fM1alAGWWdroZh7fC1BN/lrvf0ljnn+GqjD3VRj+8O70ellyYglD0kGlGJ2Mvq6hDbX8A
	 l3BBd6ZxrrtPB6nBt/qcBnmnvKqghegHIei3jOOy2fhx2l5BSYsBS/drKzzaOUUN+q1AK
	 k3t+i1XRMpiUDlUhBQnII/3zdL4aSKHl31hKNyG+MgfKcDkvl4eqFwCmDc8JMPBuZaZwr
	 9chPmWSr+ObyJ8Kf1sEt94WUsCtv1c8ikVM7nPJrT6AU+OsGwrHi3tKEt+XJ7NRd4Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhNkWkjMNG/uofO8eT7Dw1V85UPuF6flVcesanbYkZE=;
	b=1nMGPc/cd8cc5CI+MQXxR2s7JvLZV3Haw9WSpfccD6aANE5x1QoHdLbn5mPoLxbqJFK5
	 NMhMWIoCgYx/MM13slzZJVMPqoAPrFfXQbAUKiIAa42AMT9zEinwPxl+f+E/W/WhKJWpi
	 lpyr3WIpgZRVhBzm6P5/h4k9WMsECCFMi2OhUu4BD47qrElSWPord5+m3NFF6pOkAG8GX
	 f3js/Gnz5H6UkGfADojCl7v4z+crAPHg1D6/AoEFnU6z9FAWJK0wU4nVEm9leaybV6Y5o
	 Tgb+9n0Wqrnv3S1B36eWJhe8vHJuy//ZU5GRIO0Vkr41IAzwRAfWkreq2E3dQMqHT6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhCmRvWm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0AE606A32A;
	Thu, 19 Nov 2026 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhCmRvWm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04061F000C4;
	Thu, 19 Nov 2026 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051847;
	bh=YhNkWkjMNG/uofO8eT7Dw1V85UPuF6flVcesanbYkZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhCmRvWmqNw1GnSozoHNDiZN+sP2H93AwdlcjuRLempnKRZwANlZCngvQTZT02u3w
	 xNzK5GE2oUytydWNnzL859XmcJXLs7myNwTgDaQRw/jpf9baiu958OTQ7OkKhXoq1X
	 +2XHty6X1uv11FFX1Es6skcijOMd5t37Ku5mmBa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0352/2214] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed, 18 Nov 2026 15:33:48 +0100
Message-ID: <20261118150024.784064125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -462,7 +462,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -507,9 +507,13 @@ static ssize_t write_pool_threads(struct
 
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


