Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617722;
	b=Kz7Cw+zeLow9xe+uGVLQqYBbuPNTzizxNJkTqplMzcTieJhSDHYBHQyNFvVM4EZO109T
	 tv22nTh7uuzrERAeuxa4mtP/+vP4NI3W8p/yzw/57x+PBbdVSgV2Fthhc8mQmVHpg3bLB
	 2vmqgdDUXgkVLZZBtZxaWK9wLgmZYFwRy2fC/yTpGwXA/3OKs6khsIOyuH3rylD97BYM8
	 jAyL1vgCjMtm7U9qf36Q7v/T7OyEJxLuX0SD6kYxaG68oNI2SWZ3LaJDnhoN17tUjym75
	 1558VR0GT8kpX81n8ma65wBE0nMKCHa2EIH+YnurSxASem33yJ6bl72uk45dblXxUDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+gFEbO0SAUCX00ic2Czgx8a0pjotk5k3wY/VHPdaRvY=;
	b=sGRFnwWby25gGKsTAMmEszvwEXtGlT232LUq76vDOQWu4k+LAzV7wz4LqO4FtVI9xjzF
	 vrteeV/f9n2oEBjOXgkAoJWjYWioAfzscEYscWnrMthYOoCBThShs8XWGDhHGNcbESSov
	 xVx5rjOyKs4FXTtBPpsqeukjxj5+iNV0h6385HjeMPNCy/WPB7u3VYF6fTQREfBtjiXqi
	 hpznMPbYZqpg0NArQSF6RW73B4IFKXX37PkclDAz8E3Z2/F+hkiB7xcDZh6wHsE1KRwe1
	 LyVpkvlr/kJBnhdfDQIK5FaxfcPzfSeema/Iavg/eJVl0Lm2/y3RgXt1LqlWe/jBIgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXAMbnsq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48E606A32A;
	Wed, 25 Nov 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXAMbnsq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8151F000EF;
	Wed, 25 Nov 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617722;
	bh=+gFEbO0SAUCX00ic2Czgx8a0pjotk5k3wY/VHPdaRvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXAMbnsqWV4yBhHay6YMP/g/Bj1d5GTkBynuFTECFc03cEA92XXb2BFEXiJBJOfHv
	 xyCcXSkIvVBHry448aMTkhREggDvfs24Mj9vetAGGfG/E/Je02khO+GADbcLJZERfz
	 JlHy3Bwq4V+7YtVJZT4USerXA2D+KUGQTBrLsme4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0053/1005] scsi: core: Balance the pseudo target reap reference
Date: Wed, 25 Nov 2026 15:23:11 +0100
Message-ID: <20261125143822.983258543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit 8a832fb632da303cdf0704e0d56722ec47799f19 ]

With memory allocation profiling enabled, unloading scsi_debug reports
allocations left at module unload. A stock Linux 7.2.11 VM without OpenZFS
emitted the following on each of three load/unload cycles:

[    1.644665] drivers/scsi/scsi_debug.c:8863 module scsi_debug func:sdebug_add_host_helper has 1024 allocated at module unload
[    1.656260] drivers/scsi/scsi_debug.c:1261 module scsi_debug func:sdebug_target_alloc has 16 allocated at module unload

scsi_alloc_target() supplies a reap reference for its caller. The SCSI
device initializer takes another reference, which device removal drops.
scsi_get_pseudo_sdev() drops its caller reference only when device
allocation fails. On success the target cannot be destroyed, retaining its
driver-private data and its parent host and adapter.

Drop the caller reference in the common cleanup path, as the other
scsi_alloc_target() callers do.

Fixes: d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI device")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261027100859.1031135-1-ooonea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6cd77b0592e45..53a0af2104ef0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2156,14 +2156,13 @@ struct scsi_device *scsi_get_pseudo_sdev(struct Scsi_Host *shost)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
-	if (!sdev) {
-		scsi_target_reap(starget);
+	if (!sdev)
 		goto put_target;
-	}
 
 	sdev->borken = 0;
 
 put_target:
+	scsi_target_reap(starget);
 	/* See also the get_device(dev) call in scsi_alloc_target(). */
 	put_device(&starget->dev);
 
-- 
2.53.0



