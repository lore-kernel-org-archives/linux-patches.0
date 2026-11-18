Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025346;
	b=e36ZWbt5+JagM4eIAwUNXNKByBmoZQrctNbl3yeAttU+OkM5uJSZ4xCwKRJkTxyOV6SH
	 VI8xt6cUuz82LAHdbaRqU5xekEb8Tm11hiBKhFDe5z9CNUqPpNek22XRtx1+v7gBk50cA
	 3A8GMx451YgYIliEvzEpPbDUKuMrkweNfJHqmAYqN12joMgf9F/o5YbXunRLxfdheEnUj
	 3QPeDMzk4A7lkCtyP26DgwrOtSOeruni50xjVvphC4XLivW5hDs79ITYNt4ESgDWKWH9L
	 UlWcuYONPAK8nJN7gmx3GtgIjgUIxazzbwh00yVpyIkCT0IWStPeorj1vP9osCEGQGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nsfr8JIpZ5Ii/19GfYQZKX0zIB7zryXvU2hcY3dTQE8=;
	b=yFtn9kB4io7MSKeA24J2VSi9MioW5ercsae+Z1fFn6VV8HrF+1J12DUyJ/KhSrFlfTpo
	 YYfPM0iOXopFK4SBMwxi8I+EmKjm3iXPhLbzRmVB4o9ZZp9FSYalXQjDVu0nDgD7n0cop
	 0uI3p4l9JxhyELIPqV49LM5tNkK6+uoauEpLDlj4qmC5taCWJ+REfDWjzUofg4/fhMAAA
	 DcrRqVPK4f2u/XVwdFVtEszsTHLuCKlHIHv1Gt8SMiMcs3n562m1nHzZfmGqP2RVO6OfI
	 luTncIc+zPAHq/zCX27+sZnvtxuQjezbPElNSJDpWsIdTPcfDx0K73SVl4Ns9Y9O8Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VX4s4JlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A51606A336;
	Wed, 18 Nov 2026 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VX4s4JlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ECF1F000C5;
	Wed, 18 Nov 2026 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025346;
	bh=Nsfr8JIpZ5Ii/19GfYQZKX0zIB7zryXvU2hcY3dTQE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX4s4JlJAJ2oxaTpcWgG7FvWooleSsztouIY4CnY7N60Myn5ZVudFrEBAYFNlzCHW
	 WDMkXvz0LU7qPySGJyLEUkWmQG5WjYE3gIq2zYJOiKFhV0WP1x7LWCvLwmcgiGNZ7N
	 1eXkBK/HDyy7gweUJpK6r/YKk18OhKhTcjeimC9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1020/2151] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:45:55 +0100
Message-ID: <20261118150159.560920044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 491bd55c35cbb1ce059f22e7f3c6284551970fef ]

When logical block provisioning is enabled, every command that writes user
data calls map_region() so that GET LBA STATUS reports the region as
mapped. resp_atomic_write() does not, so GET LBA STATUS keeps reporting a
region as deallocated after a WRITE ATOMIC (16) has written it.

Call map_region() the way resp_write_dt0() does, holding the zone metadata
write lock across the access. That lock is what serialises the map against
resp_unmap(), which does nothing unless logical block provisioning is
enabled.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-27-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b1e0af17113eb..a54253c369549 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4809,6 +4809,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
 	return mapped;
 }
 
+/*
+ * Callers may map the whole range of a write without checking how much of
+ * it was written. SBC-6 4.7.4.6.2 allows a deallocated LBA to become mapped
+ * at any time, and only requires an LBA that was written to be mapped.
+ */
 static void map_region(struct sdeb_store_info *sip, sector_t lba,
 		       unsigned int len)
 {
@@ -6036,6 +6041,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6088,7 +6094,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
 
+	if (lbp)
+		sdeb_meta_write_lock(sip);
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (lbp) {
+		map_region(sip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.53.0



