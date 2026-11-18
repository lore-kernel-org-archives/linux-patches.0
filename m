Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043547;
	b=F/nacoqZUeNPzwyd2ZEf/VjyxYLEudVCTug+TLpgjxE3qYQItOr6BjGveUWOdE3qXkVC
	 peEmQ3UHRlkJAw2iGt4RU7EzMRzHZrBvijWl5iuLIEc6/Zp9H5bVODafMKyYkCbFffevx
	 EZ6jSiU3+k2reFd3NYvFkkD+knqHMG4OLiDXPRDpGT0hOw6RVBpVblzZ5GCtDFJ5wNsxK
	 R4EwXPBuQFOSmADyT8nwoRU0/AimfPk5Y4NXEtdKd9mfljSURg93jrfH6EIKMF4f3INSH
	 7XzmBKn5uOcViqI01g+UiUwroTHKHNdWItXJx9Z+BKmQY7/wfPhH/90ieFCkx0/OJkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cjpn2FIryIrxYSAavIg9IH7bDM4qUxJSES91nsoa5wk=;
	b=XCylbTEVIMYPxBtviGIw3WVdSju0QvnqIl0kAvPAlt6X97QILuQszzNGtNIOAD6jraie
	 OD41b/OzAnW2HWh1yBwPQA6Af1NXUPth0qrzIrIzk2ySLRxzWOO9a/H/KF6lO0YA5Fm1y
	 xIMYWh85Bq7oZ8cIPgmxTHoIaZNOrS7Iwsv+c/Bzxbos7g2MYcuPG6DwQeAuc83l/7gIU
	 yEl+OdfRIV0v3fYH1SaAsPdb0C9SbviEx4fIazJm/wW6SW/GmLcKPsP4DL9TbxYrN+qd5
	 Dj3s7zsOOqQjpMhpoDBThDIjJaMYc3bsT3hjkvF4pPAbHKvrgRvJACYsfSxFaEGTY9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9dsMrqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A362606A320;
	Wed, 18 Nov 2026 23:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9dsMrqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498531F000C4;
	Wed, 18 Nov 2026 23:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043546;
	bh=cjpn2FIryIrxYSAavIg9IH7bDM4qUxJSES91nsoa5wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9dsMrqEEUZgH2Uh3VJQBQ2Qy70MiZeJerbYcChHqmag+EVFbjQbCPa3A2Bkt8p7y
	 oGYXRTrnCwNdGOy0jQIdk0xzEgdUJRfzC2X/I8YAfqxBJV2LJ+FPemo4c/BdlczfKB
	 g/DbYYFK1og1jMUiHOuEr3/gz8c37IIiT8n6E4ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0250/2857] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Wed, 18 Nov 2026 15:21:24 +0100
Message-ID: <20261118150210.444222039@linuxfoundation.org>
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
index 2b5adba9c25a8..3b99e45492ad9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3378,13 +3378,22 @@ int smb2_open(struct ksmbd_work *work)
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



