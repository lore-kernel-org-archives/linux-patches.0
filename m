Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061720;
	b=L/8oxvTe9zePwOzsU5RiSlTJUudLm/2qzSMxQTzpIQyYVy8XfP8yV0I9T5Yuo9XCCmzm
	 icj3b6W6Reyc0UUmE1BuSswbV4Yvv93U1+yp0jfEx2YqeADKjMZAQTAV5KhpsWDItXXqq
	 +KzyhO/qPD1vPVU/YgrS5QJ8PfhofEiBqOOmLiZTGECl+8VfSn/w4QJHLmujTDt4P+AB7
	 3J/6k66ZJnAt2REWHMq894YjiB3ZPv7CjK37MeUiFQ5KAXsMpvPuNfyt+s0hBZiOZH/+G
	 Gr3jKFgqO0BpgAygJnfCKWu4f2rKTFH7IYfGFuW/Ma7Gb5lmDRXntGKWEd8dgItlPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUo1Bi79aqxNj+YfeieqzhVtTOeM50XAg41PaWbvgMk=;
	b=ZvKow2N1Hmtk+Vf0jes+hTyZ3hMidenB8hghrlPwVmpkAdlfIf3+0UpncITYd2AuxD7X
	 1TtaW9zm3wNEePRy0omE9B/xycVbO6Bol6/fR06HAIT+UdGmD0oSV3rQ9hhO3yprzf2d/
	 jSpMWoqsecfneN+B5SeoOIyv72avAJKHLFqLsV1lcMUsU8NWjeLcaU4QLdoc0mBHsHvHZ
	 iAwyT1xYbQHRrJP8ysx1Vu1CcEeZvk+HDrDlWPwx639yMfE75EH3NhBa3zyX6q5qDYoRQ
	 n9DWwuFksqqEnlAxNq17uCqGmgGVH/33m3ZQRJxKNexT1GvvH/c+QVlBv4uRqXCH5qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4g4+w54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86253606A32C;
	Sat,  7 Nov 2026 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4g4+w54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338741F008A1;
	Sat,  7 Nov 2026 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061720;
	bh=SUo1Bi79aqxNj+YfeieqzhVtTOeM50XAg41PaWbvgMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4g4+w5499dByhITTAG3DfrRAwTFU98sC0Or+laBl4LMqzAbywgzmvtlQtfe0pGDg
	 j9+RfhdeOsMmXx+DHsFNFpuDsaKTgmTpMNmgUhuFmsjvFDke0xAtVeQ2m/avpmm9aT
	 ldehjQ9VND5aViZQXYoItG6R8RWHntBJxwshpm7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0765/1536] NFSD: Fail a pool_threads read whose reply does not fit
Date: Sat,  7 Nov 2026 08:46:21 -0500
Message-ID: <20261107135019.018590907@linuxfoundation.org>
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
@@ -471,7 +471,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -525,9 +525,13 @@ static ssize_t write_pool_threads(struct
 
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


