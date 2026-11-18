Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033724;
	b=3E1TlpsrFrhdXizNIOzeiLwHlisCO8BYlL3DfG32yE4fxSAqZmtrlYr97IT+Hn5DsQ4r
	 ysPkuw7QJKmMo+/KHBaujPapafT9d7TrTZrfetdtvQyVY9nb482Z1/yRTyJQyDCQzN/IH
	 HBGAwouq0PnijxSVyS7Lpn/ychhAMV/6H/Vmb4/igfCPzU7gohOE5nc5hw1IKavV+T/aF
	 9EVZ4mv7NkALzWJhrLN0E8Sf6t5yCZzHhc7YejELv9n6RWwmxn8ujnhzPfx6A4z9ifQLN
	 YMdixN35A9wfr4LGDXn2YiltGmWlQoFmRAt0bQSJQrHtJ6SiSskxaSImS0K0CgEnvkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kZerLcQwyBXUD28HSg0SiYvMdV16U+d0ZYuJmiSFBOU=;
	b=Y092cpOOT9WKlpMgFSHP1O6gfizyE3eyvl+uhvAr8dJLzIkD+1mwspxBZqr+1pQz9QAT
	 R16TAMtHJP/wdZfRa/OOuclBleJnjFnwNXRS5+zlfTmrbGp1utQNIozxtXDStTuLH3gz8
	 cprFa1Ik87KrdVmeugDHi1R9cxGwtFKRC1Y/PE7601JSblv3PRZOzT1Cz5zUw8AhO8lcF
	 v9UGRU+VVWEXCZqgGoi3w3MhqAlVRSpNzH/KoHeAJGCfgm9Lqb2Fvh8tqyfKsx67/LoVQ
	 yVmhOa+eta3tB8vVxRaqrDIjHaj0BRb57VKwxSNIcr7BtRg1WPK7mln5l6RHgcoI2lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQFK972K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC28606A320;
	Wed, 18 Nov 2026 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQFK972K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38061F000C6;
	Wed, 18 Nov 2026 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033724;
	bh=kZerLcQwyBXUD28HSg0SiYvMdV16U+d0ZYuJmiSFBOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQFK972KwNG1XvytZYg2xArJo4E7tLekIjFhal8NRo1R56rLt/ncALGKYLnFzKm8p
	 msp21Rb6+XDxwaUu49mojIolULO11LOO9W05ry1gfuUeq0WMSrWKwnSQGsZuq1dJbi
	 mh2DcyYICGL7pHs+HJXuPCNAS8HjLuBxECWnS77k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0074/3318] remoteproc: core: Full attach detach during recovery
Date: Wed, 18 Nov 2026 15:11:36 +0100
Message-ID: <20261118150316.277850052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit d93ffd549fb4df18c934ca7a47d4128a18c718cb ]

Current attach on recovery mechanism loads the clean resource table
during recovery, but doesn't re-allocate the resources. RPMsg
communication will fail after recovery due to this. Fix this
incorrect behavior by doing the full detach and attach of remote
processor during the recovery. This will load the clean resource table
and re-allocate all the resources, which will set up correct vring
information in the resource table.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260630004806.3835488-2-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1e4bae2786dbe..a6f800a00e7db 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1783,7 +1783,20 @@ static int rproc_attach_recovery(struct rproc *rproc)
 	if (ret)
 		return ret;
 
-	return __rproc_attach(rproc);
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	/* release HW resources if needed */
+	rproc_unprepare_device(rproc);
+
+	rproc_disable_iommu(rproc);
+
+	/* Free the copy of the resource table */
+	kfree(rproc->cached_table);
+	rproc->cached_table = NULL;
+	rproc->table_ptr = NULL;
+
+	return rproc_attach(rproc);
 }
 
 static int rproc_boot_recovery(struct rproc *rproc)
-- 
2.53.0



