Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046111;
	b=pFe7/XWUC0mAAKGkwY95W+dHJLWkuhMfYR5o0cghoMWP5ONms3Og8qXjBikVfK6ZyhHR
	 W2Qm9Ymu9HeNCUT4MNXcvIsUDqUxZ9iJ6FU9ITyzzcOplGnBY4MVIQC+T9FoehIJUcpyW
	 3r0Q0Cbk5v5sSwG4mcSgUwo460RoynxQhtswOdQ/QtMVuzvgu5XMZBMAJDc06Gowvft87
	 rTdLFtoQZUrZru79oDfp4jjORHIkZbWG9ysGQMHSjNx0BFPH0qNxBzDj2lNVkjI2iT7Y2
	 pz1ULH12AlVBu8NsINxUB3HyqvocZANeeeaXhnakh3n8mcvMWvBb/kioL4icyd0C+Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRUEbdBbkdNO/BWekCMa0niHQr3KqtPYzeEZ3WufomI=;
	b=j2+IaNNxrnBZXlh4KiPZR3BJTdlZE+jb1ss6VQyGOHFQycQxCOTABBpK0rs/jExgmxLt
	 nsJeIhiHtrfjloLy7E9u/zDWIjb5Z3zLNkw9sJym0Fhk9RYmHDUPHBqTolh3wS5E2abdQ
	 KErlWvksHke3bG3Ie4DaRkyFw8Q33gqdZNniDNfvX7vEA9VjE1gqEsZK/Kr6vjeUmyXvG
	 bI6DgGGRypK+TLCTXrcy4nf/1uWoThewZvBHoLVGbyl9gnUIuksmevOog9ryQEFQEa0mc
	 R5BpYhzRA588FjTm4AyFVfE1Sh2V+5aT0P2cNyDaQZLBrlYHUreNjtOZ0Qpxo+14tIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFBB+k5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39360606A320;
	Wed, 18 Nov 2026 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFBB+k5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2C01F000C4;
	Wed, 18 Nov 2026 23:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046111;
	bh=iRUEbdBbkdNO/BWekCMa0niHQr3KqtPYzeEZ3WufomI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFBB+k5wLcJMrXQhubO4baaTHO+CbezjStIEGl7sbxDbB3P1f2UgYcQ04s2E0LKfx
	 GZJRR8rDZl9DnImBAUkduk16JSLsfIVrw1KTyolHWYDXuu5KNDMCS3aLTaUgASsQI8
	 VA7Ht0HKE7pDaAmR66/UVf0We2CdOCWFEa6yvx7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1123/2857] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150242.046726376@linuxfoundation.org>
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
[ sashal: adjusted allocation context for kmalloc_array() instead of kmalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index d9e9dc3612af7..8d7b0f42afee1 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -272,6 +272,13 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
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



