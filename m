Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018401;
	b=o81nKg2B2U1ZzhKHWFLV59n98bzO2n4RB1aW/fU6dFSlwuEhxRXBXX/y/Rujfdol9puE
	 KZjVQU99Hxp0rR+6Jl7Y8NoOvLB8sulAYN5MBUHV7uXl5mXzaJqJM6EBljGLqRhtihG01
	 zx4OJAkO85tNksXPVjr/sRg1owNMuzdgUp6fMqI1Gj6ztcs0CM2i6bUkuSby1WfQ7S8dx
	 f0upNUgIgI1mK9zfc7mi6qPEn8XrxPZHgd85TFEJIIEGOo6X2jzGP8m42Nd7MVv2Y3cg0
	 MYvzE02gqWi7bkQm/sQmm0BpnCIGx3dWmf8z6mcVs1k1tnBqU4lcEIfhzTpVszESyDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6OnQQZ1lM4/gbXoAsnWg1zkuRprXssy39jN/0BKD9A=;
	b=QxLYEImax2kiC6tI0aZFyIezttcvweHB+2HBWp0zYRmKze1cZ7A5YDjUUUSo/NOEp9Rj
	 R4P1aXnjAB5a6agDgjdRZwH2Pq+QTTBMCx3WIX0DGd8Yt+m8y5cfy3ds23UwGwgjcUM0N
	 KQ7EDcbd6KcrN/+b9Pb+y5/Adny9LCBOie9QpZfSdheK8NRKsn6T/R3qBPJZkwN5l9WK3
	 NU+pmIW2n37XZDgPWf3uNNJnDMOvVxGwfc4oC323eUxmPjyRhyJqTYVP47M53hknwrqHE
	 +MawY2g4YgTE/IyP6UQOGrQMw6/r4JB7/9ayZH+7ZOblYgpZvhp4bzBSymWsGGiQq+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTeGovU+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF825606A31C;
	Wed, 18 Nov 2026 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTeGovU+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246201F000C4;
	Wed, 18 Nov 2026 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018401;
	bh=q6OnQQZ1lM4/gbXoAsnWg1zkuRprXssy39jN/0BKD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTeGovU+hIYRSqAW5HpGxDWC1T2FmEkHfq3KaXT5SirBITRPUwMCpUH0mr0aC9Vo4
	 Fbqb2ubAfuu+QnitY+MUIFVffnGLwUnoh/fKg8iktjix/+nFOr95VCBTNexqm03ft3
	 wJ6ZeKdYSMg+D1hhlNIWmeKpKSFi+hVPxr/Z4kLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1228/2651] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118150332.219355290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a9021e5448abd..5a89742997116 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4765,6 +4765,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
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
@@ -6006,6 +6011,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6058,7 +6064,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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



