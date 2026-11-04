Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830938;
	b=HsBQBYNgdLcstC5IdsWRAAd9DZqHXjXkI4cdHIBM5kwe2BemRN013pW/zOiIKLwI6Fdt
	 LkRQxS0ZUf0LPHC6JrUXYMOMRQ52Bm83txYGIshWnamIkKVYXsid7rAwfjNp4af/EAfzU
	 ADaRVgsBfC++PiwXptHYUzOSA8Gw5MvyyO1QxzE07DWNhSlR7N0yb99oQo3E7g9osXbGm
	 tGuqGfJQc6heIQiUPJuFiLg6l60qPYhWpgr+PQqRElAWWcNdZNYGqqNEIE7mRVn1rCvxV
	 sLNXCk6MylJZU5b7CsTWolTEdTrAMfi1PsaFoxI9GZrLYdwJ6s72o7BGJjBhvT5N3tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62aMbUc/nlDf/mdevxiLTAEq0DGSvNvt7NE/F496dNk=;
	b=BhDoH8Boy+WIoP00f1DGBoi4dtqd9k59bpw4z429r1n+E54OGtj8MRfl/NIKz1j5QE5O
	 6LmycRlIHgfmkHNJd6/+3TQvb8n7kJAU1EmYpQeHf4+fOWY8k59qHQ0MpZc3UTRHqluC8
	 IYow6AlakVMQvyX3dbLAweRinK5mqqddWFySUDP6szFlc0w3udx37nCyRGGekCOeIC5P+
	 kgrPKiILh/iIBSm8L3M5yMlkeiQBYIunSaQuYp8kJBKxAp28nrkTMS6BeJ5IQBBKJOx4I
	 DSrdLQl+DIdn3grdAoTFBPtMrQwNGJ0hwOFPRJqQt9Ppcx0pOnBTuz952/uj9efUFTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR0lxUki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925D606A858;
	Wed,  4 Nov 2026 22:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR0lxUki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FFC1F00A02;
	Wed,  4 Nov 2026 22:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830938;
	bh=62aMbUc/nlDf/mdevxiLTAEq0DGSvNvt7NE/F496dNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RR0lxUkiSxIuc13x8ydxFnNOdiRmfeQdDxn3lcfwu75tUR0yvtmlk/a5NfDMiCCHf
	 SoZ/56s+313zyd5b9w6A3UYDFJW2OjOykwAbukXzs9aOvi8/8h+fhXc+U/yxDqqrfG
	 p3uCH+qBRgq6ZIZd32yzZRpPH30/Sn9rq7gQI1SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0413/1005] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Wed,  4 Nov 2026 16:02:26 -0500
Message-ID: <20261104211055.653207556@linuxfoundation.org>
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
index bfc60fc9fb275..e473cd3bbee36 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3633,13 +3633,22 @@ int smb2_open(struct ksmbd_work *work)
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



