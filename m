Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211561;
	b=i59GJiAR66LLzrQCWzh1NF+XQqpeNM5GcUOGH2fEeuXLHaMvj13nZ/bHDX9A5Xaa9dYR
	 7GX0HYel5AP09raIraJ+YADeChOQv+9w9HQpXDdA4grLytH8wfBUx3lBgEwADRepPVZWp
	 OTTd2FDf6iLSg4U8kMIqhzOIIUrAxyzajzzFuhvyuJ4cxq1YZlRwDctorMrQVXAp4jF+a
	 /VQYtEWd7WIWQRm4Iituyp+7ldtiu6cw/rEn1BeKh2e5Vv8Ba7EGLHrE/LKmSLpdp0R3+
	 4YVI9aBj/dbMVcDS6x9QiL2q/s+S3BfdZvT7rHZvIrxC5ZPYmYLECg0/paBYrap1vhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VrjHWsUNzvK/V323Nbc0d4k0zlp6j0BK2x4VfUOU7nM=;
	b=m0jnnRd3cNU70vU7mj2m4lwWVlE5ckUipUmcmqVIg8ExgW91hUq9PZcaYLy4vHZ+orRJ
	 EDIuJENXdsjiM3J4H45FVvynCUa69igqGyhnOI06s7LQCtrF2/ReTVJtRmmJeTKTIDEQu
	 zQZuJCO4uO1jkqHXoJDTi/i1M95W+6QYkLlHCYF39NaJ37v0kOxu7MfYc/38fBWrXvfnm
	 m4bwOfz9M1iGfDVmK1a3YViN3rqRr6rRVKBp41tDoDbm8ajjo1ZkynSKE44hMztQl0ujf
	 TgVw0GE6V4Gs2grXcGDgEtG34uXfMDkKqPdeXuzzwGbrZMFzx3aMseQG2aWQkKqxr6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhMkMtU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D641606A31A;
	Wed, 28 Oct 2026 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhMkMtU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1151F01825;
	Wed, 28 Oct 2026 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211561;
	bh=VrjHWsUNzvK/V323Nbc0d4k0zlp6j0BK2x4VfUOU7nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhMkMtU6Mp/IfYWPK+QxJCsCJr9jSLoVR4yGLjAgLl3xsw2rckltOcakngB/fM6eq
	 VeZZ36OjmR3qlZeWwnQc1BqqsLu+HJ7o7984EaYN4TgdD/4W0O/Fvq3yH2fh5NaviH
	 ntUnxhQeupIDOQUJsrzTlgDouzNhqvHAarbk1vZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/571] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 28 Oct 2026 17:59:21 +0100
Message-ID: <20261028170017.835339097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 1b3221bb121079ad79a1f3c3aa360ba649832e7a ]

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
(cherry picked from commit 1b3221bb121079ad79a1f3c3aa360ba649832e7a)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 46f40bc3ef7ac..57ba6f7d813d7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -529,9 +529,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}
-- 
2.53.0



