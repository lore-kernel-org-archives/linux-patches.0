Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030811;
	b=2j+uWnp4nrh0ZQ7cgL7+JhzFoZEytQieDNTC6A56hVzSEYrT24aUJ93AWufS2kwC7Fcy
	 ZfGp+kQTRtf8WUwkVoBgrx2mUw+lJRmFpGoBUvUUEUWZvmcPJ8lNKxzlXN0TxgVNeBbx+
	 rl5+QZ4QjjsJ1LgdYLwhmsxu8D9GFSOR5O3j9CUNa8hn7yEPBcXVO5c74M9ZnQWbbcg+e
	 0Lno+djp68HAV0HmYHOIixpT0YlzCqtKQNcZuzQxLtnzcQ6w+B9ACs/iNYfneBHjLLuZZ
	 IJIwvIqQm/zcHek+Oe88YIqCwLNh44jXWulaym/G132JyqXMb2XjHaIRg3Hy6PpKJ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DLSKDMr47Fh+bWJcEzHhjAbOc7VhVRtUnbJaYIjKhNI=;
	b=XMOuXjAxmL2Ee0RTG0R7KsLEknogY/jamt85MgrhANlNklKmXHma+M9HYuatN8YmFV7z
	 83JBoUVqGCmWG+N6+MlPXU3i1ZADFgzGPjZwdfx9hSRF1dnoKTJ0QPv5+WjAjW+TjZ/jT
	 8v+WgqUwPrZzo86tvFHlfcBEqbZHR6wI/cAK4X7rfYAXcHQg5SFipMrmqv73OaAFpP35c
	 TttdjAsjUo/7t/OUEyn4F3pgzVk+dTzMFwu8/SSxVf8pTiF1zrl5uK2NYQRT7K/5SGkzg
	 uEWFxliiBrZuBh6xNMkwtVObTDRcrkrt6OwtZRh+8pIurYnqJE7kzFWlZ5u6JGpvcBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0QsL+rk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D47606C71C;
	Wed, 18 Nov 2026 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0QsL+rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9DE1F000C4;
	Wed, 18 Nov 2026 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030811;
	bh=DLSKDMr47Fh+bWJcEzHhjAbOc7VhVRtUnbJaYIjKhNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0QsL+rkfNTi593Ao0FGVAyrN1WfwHQrDbFGrzGCENHfEcjuU+fUtaJv8p08cIPGR
	 +AzrY3j5Us0mb/mbjcWt//NhLEr7lR4i2Gt091suyhOfCbC3ne3vRexnUZASkUzgAy
	 V6p3lV7Qctoarx/tca3a7ZNABVbHdmeu6jL+a1e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0796/1756] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:48:43 +0100
Message-ID: <20261118150041.389153982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 961496432fcb3..1d9947dc14351 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4173,6 +4173,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
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
@@ -5335,6 +5340,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -5387,7 +5393,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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



