Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034339;
	b=J9ULuHHPXOqBopQZlLixJ3V6jIl0pQc1jNSurFFD+lCDp23vMW33MIZa8Rbf/x2dc81A
	 9ayjXioSa1kyPaXsHKWAHMZWQ1eI51Ha6GtoIVmn0tSqQZ0nSCl7BT0TOSBciQMe9ULoz
	 NmPanAcQU+b4JEqh7uh+mTqpKPvA6j4b8X3kKPXhxUdBWL0E8FeCcXJ5HT1g7ZRkQPuP8
	 gHWM4fPU+XdGTmdmzIgGFl3Hu+eWvxRUWvYwfZVpdNhyG8IcTXUhMQnQrhNKP6DtSDYMn
	 yTKJIHx5vHPLFbart5+/aQCEbtcvbBOA36201WSkdBewKZCt1m8ymTns49vMcUH9zdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzlKmj7GZSuUAPDvq5NgQzPxnM0v3PaaXFp1QX09Dag=;
	b=zZAhdOn+xQZYFiI570zobRwPC2uho6xUWkoZJ7u6zz3+yHWhEV+8DSNjmbxRxsZyLnBm
	 WlMm1sWNgIcIyFFLNYn9315SQfpnLwPdYYzO5bSEiflKPrfgXmEL5cGawE2K7z/qFrG9l
	 8B2ZiyJEZ5d2GHYsyPo73XR1D4Ii4w12b7cNr5vHwN+VajpbnuwNM82nglWEZDQEMJ0Wr
	 8t2Nu0VEOeUd8jQ0JDHb43RXr2d7PB8K0JlURaTxhpONY/xLZ+DGFjtV9JXqnMvMKLKZg
	 otVIEnobAPhyIe6xkKP0AcD28yiRD+3zFn50Shg71VMSMDw8sXynbJyjpeJt4AxMM5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6X6Y206;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845A4606A320;
	Wed, 18 Nov 2026 20:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6X6Y206
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC61F000C4;
	Wed, 18 Nov 2026 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034339;
	bh=BzlKmj7GZSuUAPDvq5NgQzPxnM0v3PaaXFp1QX09Dag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6X6Y206IKGOj0GSh6W+7NwtQ9UhfOIsHSYQBDxsIddnJqC0zPrle75pIGOdD/DtM
	 hEmTZWcECi6yp5M+KY/2OvCXrjkLeU4O+6FgSmWgIWY4Gk2E8dGSESfoOoVWzOQf6K
	 c80l/KY+s7LkZ3QFjow2Y+90ve+U5L43EnLXwfIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0293/3318] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Wed, 18 Nov 2026 15:15:15 +0100
Message-ID: <20261118150324.418596501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit bfdf81c62f4f52a3626ea62db0744def6778e83f ]

smb2_open() calls vfs_fallocate(fp->filp, ...) unconditionally when a
client's CREATE request includes an AllocationSize create context.
For a stream handle, fp->filp refers to the base file's data fork
(streams are xattr-backed on the same underlying file, not separate
files), so this pre-allocates storage on the base file's actual data
instead of doing anything meaningful for the stream -- fallocate has
no applicability to an xattr-backed stream at all.

Skip the fallocate call for stream handles.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 60d13595025d1..58d2113cd44b2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3606,13 +3606,22 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
 				    alloc_size);
-			smb_break_all_levII_oplock(work, fp, 1);
-			err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
-					    alloc_size);
-			if (err < 0)
-				ksmbd_debug(SMB,
-					    "vfs_fallocate is failed : %d\n",
-					    err);
+			/*
+			 * fp->filp is the base file's data fork for a stream
+			 * handle (streams are xattr-backed on the same
+			 * underlying file) -- fallocate has no meaning for a
+			 * stream and would otherwise pre-allocate storage on
+			 * the base file's data instead.
+			 */
+			if (!ksmbd_stream_fd(fp)) {
+				smb_break_all_levII_oplock(work, fp, 1);
+				err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
+						    alloc_size);
+				if (err < 0)
+					ksmbd_debug(SMB,
+						    "vfs_fallocate is failed : %d\n",
+						    err);
+			}
 		}
 
 		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
-- 
2.53.0



