Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051580;
	b=Jid3Q7tD8scABBdPBMPnrFuCiySSf5B+PZjgMbHVp6U/G4UpoL3+0HhRWJrhpHOGcFaA
	 v7Wx809TQM5HR0wDVqrwDM9H3ov3CFU/52GZzm2xGQJB6+um/tno9O6ZvJDdRVPHiDozv
	 Wt6fGBx1LQcTHsVLmKUuyV0dC0AUO74z3BxlThTIUcY1PuO76co8tSBNHVHBcTvx1VKZ5
	 z+XpW2+pU1Z7yMHlOAx0hgYft97ncP5InnwZck1fz019Mez0XG8mwxB0cnEPNbJOSQUr2
	 JpRJ5re+/3JSP1C1tsQkwvM55eGS/7VjNtP8ORQgrV1qYo5kErNrwCdzx22kMaJ9v4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GIOAH8mirx1foI0+oRwGh0yopHrdmL0PnBw8GR8bbdc=;
	b=0P9paHgOZk4NwtBvXx/5vZ3tfserjKv0Kka8+YqZV5WNdsNPhDD+lV/CYl+WljRlYsOr
	 8/TI/yeSbNmAvwWEHEJ9UsNhHrSqDigmOMGMn1uW9CXJ7SCjpmchCVH6MB1eAZ41MO1p2
	 SiSAwwyk74pV6kthV6HWMNnPWoe2dBB5W2yEsfqcY1Dvyhe/6/lCeYJ4/mjSKVtAfimZT
	 8Xm9zca8/W/DMf93ZfnplyLTkzkd618R3t92rMyg9VGWbiwpdyHHp1qKKlQ8E+qgfxjfS
	 1pJ5ahQPrCPteglgEW96yjJ2F6A/3XIH0zQVL7byghUN44tZn8Q9ffZXh5ktHq2MY4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKAbsPYJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60EC606A31C;
	Thu, 19 Nov 2026 01:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKAbsPYJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286A61F000C4;
	Thu, 19 Nov 2026 01:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051580;
	bh=GIOAH8mirx1foI0+oRwGh0yopHrdmL0PnBw8GR8bbdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKAbsPYJtBdznQ8I9jPTBQS/KCW6PvTV5v98uCgUs/TSS8TjbYJGcNU7DAI4sMNfe
	 P2lAPJjfHtpjEjdmMT0aIzKbuDy9rTShoFglPFJCLLCOX9iz+mMHPToVF/WwT5OjfR
	 qZVtDqMv91IXXPy6mWQaTBBwNi505AaHudXlp6Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0212/2214] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Wed, 18 Nov 2026 15:31:28 +0100
Message-ID: <20261118150018.660233515@linuxfoundation.org>
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
 fs/ksmbd/smb2pdu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 53be62debf2d4..1f55c1bf69b9f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3347,13 +3347,22 @@ int smb2_open(struct ksmbd_work *work)
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



