Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052859;
	b=cuQ2bUb+nWUWf/zmpo8tWM1uIx9FZeRikg3yeTVKiO0c/8mtB3SlMnG5hiHGN5Yfm4Uq
	 4iHskIcf1a/tbLLAcc3jk9jIgLxSL5Gbn99XFET7jvqlPTZt3xKwG8eqUxP8mamT0uMQq
	 chST2shMiO6H5U6gYaB4zVLtcNWK32wRpSBb3K8h1F9YbAB+OI1nLkiRwe3K+DUdCKVYx
	 tFzteQAG4dM0Dqr5nXNamCeK01stKrFJFC60qVKt5vqmA6BFpogk1Kj5cF7nVh9j6PRxg
	 ROqD7+xRe0WXKfeZu2h6+qcDsjB7esp1TF2NZxDLreVPAvP0Ab+ZWY98AfNQwYL7cUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/0InQRmVN753J5K2ozBH91mIUZvvMQggXvaYVrGBjI8=;
	b=oLU+jK9UwFc1AXKOjqY2mADkqxFsmP2kKR9aHKyWdrWW/551rFawu/I0ydhLTuvZY7ky
	 7EkQX3PCBFQa3HZri2EJhk+V07kXEfZu+Qyy6BGfJRXentNqLe/sJqaXLzQQTvqCK8riY
	 KomXk+YPrse8/pyJVjKpdJAO8CyTRDrhu8cq/Qm+osFg4YxZW/Qxxq4XVy5G4DTT+bNyF
	 UagqgScZDuE87if33GAZ4XdmgJA3PboWJallmbI2iNtLaia+fXWVE3ARdODstL6BxAQyL
	 mV6ymzSgaIOojT/HsgitXxUOeDf3r5H8F1XhHp/INpAgDPtdY6deNN3HffC18b9jOBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieZlMMny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1B8606A325;
	Thu, 19 Nov 2026 01:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieZlMMny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315611F000C4;
	Thu, 19 Nov 2026 01:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052859;
	bh=/0InQRmVN753J5K2ozBH91mIUZvvMQggXvaYVrGBjI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieZlMMnyz+AJ1ZLBTmRJLNWaKBULUrxKknLoEL0DoPwBXvzo2yZAchdb8J8MDirlM
	 tE/1I8xRk78yYf2gmTKIwLwxmOG1k+IW1JIM/RIJpErs2TOa9bmdum5sE0HdzjxrRp
	 sbW/BM/6bFVLZvrLzyWdpf9rJCZ5ueh277hYHSdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0712/2214] libceph: only set read_from_replica on read requests
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118150040.294522423@linuxfoundation.org>
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

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit d6c7a5fcd08873c45a2dcd645a0690fd1443af50 ]

ceph_osdc_alloc_request() ORs the mount option's read_from_replica
flag into r_flags for every request, writes included.  The flag is
meant for reads: calc_target() skips the replica choice for any
request that has CEPH_OSD_FLAG_WRITE, and the OSDs only know
BALANCE_READS on read ops.  Sending it on writes is at best ignored;
with read_from_replica=balance a buffered write that fell back to
ceph_sync_write() after losing BUFFER to a revoke failed with -EIO,
while the same run without the option works fine.

Gate the flag on CEPH_OSD_FLAG_READ.

Cc: stable@vger.kernel.org
Fixes: 22d2cfdffa5b ("libceph: move away from global osd_req_flags")
Assisted-by: Cursor
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 25f25e026d8b5..794ad91eae26d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1094,7 +1094,9 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	req->r_base_oloc.pool = layout->pool_id;
 	req->r_base_oloc.pool_ns = ceph_try_get_string(layout->pool_ns);
 	ceph_oid_printf(&req->r_base_oid, "%llx.%08llx", vino.ino, objnum);
-	req->r_flags = flags | osdc->client->options->read_from_replica;
+	req->r_flags = flags;
+	if (flags & CEPH_OSD_FLAG_READ)
+		req->r_flags |= osdc->client->options->read_from_replica;
 
 	req->r_snapid = vino.snap;
 	if (flags & CEPH_OSD_FLAG_WRITE)
-- 
2.53.0



