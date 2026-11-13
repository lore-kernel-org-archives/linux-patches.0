Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590813;
	b=zinu0eLlcqrb1DHL3RIxhTiGI9nfFgzkSBqvuw27NSrnriltE3w9CTWT7jIuu4arRWDh
	 f5aXp3GvOQ0zwBQtBoSdRPrV5Lz2YI4JRQDFZPCJg4gBhEbTE3sBxzK839U7U70f10mEV
	 /9dqaCz1SJc7Z0mclni0hYCPMWIlduPm7ciRfHLA1qcbZNRa/pBpNel5F45elboAnDCRg
	 DaDCvxczdfkBwi/8bd1hDM7KBJMqAjMJMCr3LQ6dT5qfPtV7Kk9stL5nrrFoZI0ABS3HD
	 8KpSA3d3Y49ru8GRfd2U4shlS76OTn2Xo65/CJ6H1HzhF6t8mlr4leDeDsM6FbpvvcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l/CsF55IYLRQ3CHnkXxl35fozoGANYp0MrLe4L3zgB8=;
	b=AkHsUQbFIjHJY22A1mluG6C0WAkf/Wi4DXaENSkER8v+zxFsbEC4T06gzXAKspz4fW63
	 8UgL8Wo87oODJlrFglr3mVJJtr64/i9xb5f9pWWgu3zWzZVme5kK7RePfZVNE9kCP/ls8
	 /HvhYMuoRw30sr7iuB85QjY1d97jNy6I8R3i+0f413B1KPTLQnb36vjjVh6VL1egsPdHe
	 d7kWSPaL6q1sj5383ItqMdCnTJXeJCCWhwv5hHZCWFh3z6mFHa1dSyJc9EEL5b59RO/cM
	 X0kI6JRXmgB1OP3XlEQydWHDMYeqVeudKOggWNVep34V2Y8ibThL732hQC2GA07gGDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgQKnwp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B07C606D480;
	Fri, 13 Nov 2026 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgQKnwp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D0F1F000C4;
	Fri, 13 Nov 2026 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590813;
	bh=l/CsF55IYLRQ3CHnkXxl35fozoGANYp0MrLe4L3zgB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgQKnwp7ooGziNCNbuVNuU7Y5CcZnIIOtnBM6VjmOtsqbTKpZQK9/32KmZUY7jN47
	 eyNgvSCf79kEWEFZjWvVBah34XGOZzD5vRX4N7pIHswyP5wv0rETsCgUgnxTul3x2O
	 BXXzfdTv6mIJyh0Rm14T3yX0bytID+Q4lrJWRQfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/670] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Fri, 13 Nov 2026 10:43:06 -0500
Message-ID: <20261113153811.941103345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit 32f0967ea296d447925465c98e7eec71d4e2f755 ]

decode_devicenotify_args() hands the server's notification count
straight to kmalloc_objs() as the array length, without checking it
against the message that carried it.  Bound it the way nfs4xdr.c bounds
an attribute length, against xdr_stream_remaining().

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
[ sashal: adapted allocation context from kmalloc_objs() to kmalloc_array() with an explicit element size and GFP_KERNEL ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 1aa6a6e14b057..34fa00f1a1c20 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -275,6 +275,13 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 	if (n == 0)
 		goto out;
 
+	/* sanity check the count against the remaining stream */
+	if (n > xdr_stream_remaining(xdr) /
+		((4 * sizeof(uint32_t)) + NFS4_DEVICEID4_SIZE)) {
+		status = htonl(NFS4ERR_BADXDR);
+		goto out;
+	}
+
 	args->devs = kmalloc_array(n, sizeof(*args->devs), GFP_KERNEL);
 	if (!args->devs) {
 		status = htonl(NFS4ERR_DELAY);
-- 
2.53.0



