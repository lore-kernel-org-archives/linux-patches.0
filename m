Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061003;
	b=f5krm9tm0oowJ3jTvh/+d9y7LqfWqCsZuBGd8P1BDTQyYGk0pz22PDW/aPlqH3iBpJoa
	 T2VwNiZAlocsiWLPoGhqeDAsQ62IOPc5/fHyvtL06rB/dTHmCE4Ks5nkU9oNzsoMKLPZ3
	 x2Juy6ES78yMzWQIu+p+bNlVhfteb7Giz0Te3fiRyg5WCYLJc470XmsyVbx6tyHuT9A3N
	 Sv6fOlUN9cxfRHPq651QK01je1bKgXcBL4qejMlEcObArp51ayJxaL3bJA2EOnR19p7XW
	 S7ncCqMG/j2bfRxcbPc3QeAG5YJ9suB/prlIJpHSK0/6ZysdflmdBLPAXPW+paHDEBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vSAXvWyHtWwTrETQ4Shtf3gRiT4OF44MispfkVhKWU4=;
	b=5stjFmFT86D5pDqIKcC9nN6Tu8Yn/HRkGOlfxuONrdKbrbMmUCUwBA/wS6/o7cQzfpD2
	 Q9Y0dVZIAGTlXrZasKzUhIOY5qbl7elndcV2IFVBadwAFlIvPZmSMRSoSQKuvkhAld0km
	 ky8RecA7uq5QJ/5vz/9txAcO/57BJFmHW7nCpnZtHxMlN+zqdcic5TT7V+Ls8gI9QAj9g
	 SFMzyuAM7LiZIZyWJ/ImAan3SsCpXlr7Ud4NppvWORCI8zFQgfRftOBAa2PcgHIGb3Cai
	 +s4mPvjcJnKOSsxZ7fyVVIoupN8gGNUC5xl3FDvyXR14QwusgmwLG6aNpL0sCzGoeBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v9c/I35r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF557606A33A;
	Sat,  7 Nov 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9c/I35r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FDB1F008A2;
	Sat,  7 Nov 2026 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061002;
	bh=vSAXvWyHtWwTrETQ4Shtf3gRiT4OF44MispfkVhKWU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9c/I35rslnxIy8jD20Y8NgCoaDzOeWU9+WuLGsSTswpmWRMkv0zNNXdHCaNclqqK
	 MSQ20eaHv6wlJXsjoASeK8n8Q1IsQfSj1p5VOkXbOYHOXsuvfptyWB6d3EzPaN4s6h
	 U7jAEAx1RVEFZTLHAvddvb6tmCExq3tWId6kNrps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0347/1536] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Sat,  7 Nov 2026 08:39:23 -0500
Message-ID: <20261107135007.424113929@linuxfoundation.org>
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
index e0accc8565f70..b4bdd98bbbe0f 100644
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



