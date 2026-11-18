Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023841;
	b=n/y3wKPSZvMI7kVsf6le1IJEEY25FxmdkOiiHRbVcRsaZw32Z1dt2aQrGGzl4xCJPql3
	 Inpid4dRQZ3yZavJYaUWjVx7N2XKV07luwfR293Cu6FamGPBXi0gYEw5OrCVCNPdK86Y1
	 mxVFTRBNvmKF5hO9IqpSI2bb6xkjlYQA+u6SpZyrcVD1DRN5OFUj0H2falLedDyuvij1j
	 QBanb6phzqk2+dHc7SmbHGAYI3JISBFq8rr2XLKP5ppEqvpjfcuZ9GR0FFHaIZZhvVjje
	 cvbLPJOzEZsIyEDv8v9rGV9x4VM4wlZ4qYoM3Pqpcwc4j5hK5Cg3yTkttk/6PLwCRpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PDPZUYJVCgyZT8m61Ah2os0EBLORuWPtl++pfYutHeU=;
	b=zePwp86x4wIG22dMFL5rJgF0lRDNQuHLSfO5WW5qBrwYWABuMBlQhCe6Z5rOP8j1bsNL
	 6+Aq6KXXLqQyjBVOwJaXChk9IUQ9paUXRpYzI0eLRcvNxj8aacWAdcyDK5zMIoiltNxWc
	 ueFViC1dQH2dcy2PFo2fnsaQdcrO83qq6CJwW7O9qnnP1Us/2d5rGjoJJXIl7GRPG1AVX
	 7ZGHJa+eDkPhuui38Iriz3XOgOsIevkbUoN99WvL8/cSN5NMfNxdHco+XOuoI8Pv9keFm
	 V/sEhdQBY85hCiqIUyPA+RacYotVPCvIydxmWtNLlfMSjxzP2HmS6se2V7tX13g53iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuyRPahg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E1606A31C;
	Wed, 18 Nov 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuyRPahg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDAD1F000C6;
	Wed, 18 Nov 2026 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023841;
	bh=PDPZUYJVCgyZT8m61Ah2os0EBLORuWPtl++pfYutHeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuyRPahgJMAuLk7LQ+ZDkKVRLW+LrHU1/zjq/oqHn8lBra//M1PiR+vJqzyk8kCXo
	 w5sFDKvyqfPhw9oATfyadtr3bJTHndvMOlEHB9J2HFmfPf5nZStkiih9ESYe0qw/pT
	 4Wwfd6aK24Ml0p/eY07QZKM+RO7ueyvOn8MdhvFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0511/2151] cxl/port: Fix uninitialized coordinates reported for RCDs
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118150140.662495477@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 58b2b1ef28024093063de536c05aaea792226e24 ]

cxl_endpoint_get_perf_coordinates() returns success for a Restricted CXL
Device without calculating coordinates, so the caller's output array is
left uninitialized. Callers treat it as valid and can expose the stack
residue as access coordinates.

Initialize the coordinates to zero before returning for an RCD. Zeroing in
the helper rather than at the caller keeps the @coord output contract the
exported function documents.

Reported by the Sashiko review bot.

Fixes: 5d211c709059 ("cxl: Fix cxl_endpoint_get_perf_coordinate() support for RCH")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831092216.540644-3-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2416a72e38ac0..62c1ca6680881 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2402,8 +2402,10 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	 * Skip calculation for RCD. Expectation is HMAT already covers RCD case
 	 * since RCH does not support hotplug.
 	 */
-	if (cxlmd->cxlds->rcd)
+	if (cxlmd->cxlds->rcd) {
+		memset(coord, 0, sizeof(*coord) * ACCESS_COORDINATE_MAX);
 		return 0;
+	}
 
 	/*
 	 * Exit the loop when the parent port of the current iter port is cxl
-- 
2.53.0



