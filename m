Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027075;
	b=wlh4pmoFtdfwiON4CW1Yv4PtMoNurr1y+Xtu5DSVivN03QFbQTGAMkVVM4MjeHzIAGdz
	 In1uccHR6HjYDQ8g5sUR+efu1AD6If5thTw1yzM7g7w/NmKdebcob/1h1NWEruoYvlD7V
	 E+khY3CFSqO3H4aBOZg/OPshdWUw8s43gwOG7PCes14dixFWNnl7BCRMxM0Xi44ENhe6w
	 JwVupPaZNTMENE0traN1AinQO/UpMervXnrm6i43qc9F8VqlOsnVGOmierwXEwBuMbZQp
	 40YEj3ykewmSDdNQlshI0AS+4I0PfXc0PbKKiyDiZmtcCspHsBJ7Bpxkzml5uVJG/aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0na+AXrWN5T/tdHd0J9VU0pbdHz/+B+bXyWJMfvCKo=;
	b=49cWCAjEYQD/3dCfrlSI2Ltf+9pzUw6oTjzmj7bPTH/Gxhk0jcusLCLtWjTyA/rfXez9
	 LhD4QDK05oCdSipljpsEocnBSmnbcZbE38xyHZ3LVUvl0pwdY59mtaMtUSuNNFfbK0630
	 Yq5GBBKbUawFM4lKyte8EoVsNrWn0z4syafEk5nvOm9FsGXtH6m4tkVywp6IBs8vVjVkt
	 84n4w+vbBXfnOKtvyS1Zrv0QjHuzsUvbFqH9nzvyEg9uwnN1d7pSqHyyD0x0TlhKliPCk
	 wRD+P0ddgrzhmqYCLdtt3DZ4azFaS4Toxdqs5wrX9P6L1EaOcuzpzmEPWDsQ/nNJ5ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAbFoMIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B05606A31C;
	Wed, 18 Nov 2026 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAbFoMIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55FA1F000C4;
	Wed, 18 Nov 2026 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027075;
	bh=r0na+AXrWN5T/tdHd0J9VU0pbdHz/+B+bXyWJMfvCKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAbFoMILHa8S163O1nlfCx7pBYq0oBH5U7EdjFAzyMKHeiT0C6Yc3tVDVTMItj4Jg
	 dn9bYwAVAJQmuXubBMlGjazyJqMjpNLlFPB59fsD9ofkBZ8ZkEOTOh8alt8TmDnu47
	 LbY5UsWUEILXd0kabMSRkjB9Y75zsknyPAEPfQ0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jianyun Gao <jianyungao89@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1662/2151] dax/bus: Return errors for invalid mapping targets
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150222.384517581@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit df6cc0a24717c38ac81b5ba1e839c35e74e667dc ]

After the DAX configuration locking was converted to rwsems, successful
lock acquisition leaves rc set to zero in mapping_store(). Two error
paths can return this stale value: an unbound region driver and a
misaligned range size. The sysfs write therefore reports success without
allocating the requested range.

Return -ENXIO when the region driver is not bound and -EINVAL when the
range size is misaligned.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260924025035.1265035-2-songmuchun@bytedance.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b1..53d4f5ac29cc2 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1180,7 +1180,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 	if (!dax_region->dev->driver) {
 		up_write(&dax_region_rwsem);
-		return rc;
+		return -ENXIO;
 	}
 	rc = down_write_killable(&dax_dev_rwsem);
 	if (rc) {
@@ -1189,8 +1189,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	to_alloc = range_len(&r);
-	if (alloc_is_aligned(dev_dax, to_alloc))
+	if (!alloc_is_aligned(dev_dax, to_alloc)) {
+		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
+		rc = -EINVAL;
+	} else {
 		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	}
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
-- 
2.53.0



