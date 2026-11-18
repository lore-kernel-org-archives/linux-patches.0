Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058794;
	b=gV5xOXO9Gdtp4MdwyhEbH8cvAsJb3vYCsp0+Ka1JZeV1UCsxtudMb3U4mW8t2kaSf3HA
	 sNKG0kTlbmuJLvN9D5SsCwAFodXQ5v5Eiq56reAQDToK8hJpVyidHkFrm1xfhd+JlR0fR
	 8UaiHw81zQKIK2G3R6Oin9NhnGxaVxZBvhvzrZWNXP3PI0Uw4DoQz/kyMr/kSga098WMl
	 lprz7gePnPVCPiWJd4bKVsbsZgveh5czgIUO/I3WNAXOn+fMqviRC3iOjaFNB8yIQMBYE
	 NapAKSC+qe2p+EWDMRW6Vowl0/vCZr+3zDfth/p82cyZoiVtpkgnzeD3NHyM3eEZz6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mmTksT6SU+PvwMAfXtgh5iR4xcspa+txk03JDXbkaMU=;
	b=aSgI+LjZfMdjWiaH8TloVY5hITtNxGQPxZe9qR7ILwTeMPh8CCjQdu0/X0siq8W2V33K
	 s2bHl7dgogtRkvNJiMseLAh/l07VPhwwxePzf74Clvc90rg90zK1CzkhIGZFMjajbLcoa
	 EyTu/j9MAZJdtnYsvVfp7zyt41yxE7zozMuxqReCsQdm73ekpd/YPvKh7b5BlgDDD2k+v
	 HGRaadDBBJA68eMKMBkiCRb8Y5PZ+zuQqyApkZDPqUAjEmTgySfF7p9jc5LFRDbvY8FdX
	 0uVR8xkg6fTmAITJrs4UY1vNFw4bMbsJYtkSUzT1JKDmSppuqZzVuObUtM6SNfLFwlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzQygOy9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A5606A31C;
	Thu, 19 Nov 2026 03:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzQygOy9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781EA1F000C4;
	Thu, 19 Nov 2026 03:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058794;
	bh=mmTksT6SU+PvwMAfXtgh5iR4xcspa+txk03JDXbkaMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzQygOy9lPs0BRsgwF8hQ8QYjBI1LtSshR9hBVfOFtwadyUX6SyBFxp2k797p/US4
	 PbbVgM35BNOcIUBTHH68vQWFQBnEWowTTVhM1KedM7PdixnhOq9zwX/O5dxhP9x697
	 gj06BpwcMw0XU4qZvM2bm12wgEGeqHyLgJ2+TzaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0576/1848] libceph: only set read_from_replica on read requests
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118145939.268979186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 92d379c60da5c..819d29dba0a08 100644
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



