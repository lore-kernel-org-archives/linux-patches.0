Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045787;
	b=XL4LEI/3jBwmnbM3fQg7aICJ6fsZ45/wkeyFLI9wxZjnThdUNrd6+KQH9tf3SqiFRgdS
	 y9aXTZRypCv0bdI6oJ4S68+EpdnwSB0hHsq4sQE0UZwHIXKl6HzyPA7LbXCBXIUDyJgQe
	 cujd4wZPpWFA6ODmtaTRoRo6BHRt/lCQ9W9lfm/KhIoVrCylRerfktZPvRFCE6wAcGTCl
	 I4aMwOk683MLEavWYGvW+hfF13y99v2RgZLLtAME4cfR3astsC1svZHPQoUKIwJkf2GnC
	 1GGE/H7CAUA3IQn6LhIRgl5MKwRb7ePJwSBkg6bzUsbtl7+GGhwym3nCDMMWvIDEYfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxwAMcFyv63N9vJ6CSETKq9pzPOQjOVCY2CULSz8P8w=;
	b=lijg0DST5ZGnGC3fV5rhuPtJ2kTHQcqf7ToNWYpNmP4/bQVoXDaPZP9wOUHHR+jRES6l
	 Rtk9sUv6eJxHMSCIThFG1MRRzbtMk8BCaFhWTZD85AS9R5ySYQdqVvFBYqlKn1zNO6B84
	 A9Hwot5C19C1qTsmIPPtDug/T6s1TDl12GuTxKDKLPuxis9WlAx/vhtm8TNgSKJxOJ3SK
	 B6nbRMmwzUWGQ+yMkLLTKf/ENu6k4dezOaQ0HSCLVK8xXn4ZtWqPxi9NAfmGY/lGm+6gV
	 1k7aX9XH/MsgZHPxKIPkl+NZvkf4vYkJM58oSeDxNOYzCclrkdhTNvA65PInfeBNnaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmsO59h0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA4C606A31C;
	Wed, 18 Nov 2026 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmsO59h0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3CC1F000C4;
	Wed, 18 Nov 2026 23:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045787;
	bh=XxwAMcFyv63N9vJ6CSETKq9pzPOQjOVCY2CULSz8P8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmsO59h0kS6JfFkPXUHNvX1rsxP9b2d2z7pMD0GrhJlJWiSL/+eMKzItG1ytA1JQh
	 30RahpTt9z4U3l1d+BOVmLxEvEWnwjqNKgaHajJ/kjJDxG4r0sp3xgQeItsINJJn2w
	 RlfaVvxZ2oCjIbrc1SoaL5PSb/1xDCdANhoI0MD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1048/2857] libceph: only set read_from_replica on read requests
Date: Wed, 18 Nov 2026 15:34:42 +0100
Message-ID: <20261118150239.329537121@linuxfoundation.org>
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
index 76194a9e59f08..a96ab9a1098e4 100644
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



