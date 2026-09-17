Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215AD4ABBCE;
	Thu, 17 Sep 2026 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670568; cv=none; b=YCEl0vM3ntSi9bH/StWNfmv6OCoq1UlyjvAHC6pC5j18ktHGNlvetnF9qlB1Pdy2/K7bkp3ZBOSmKgLYKsw2sEZ6XzeNiw+awIySKRseaHah3RVhJtDdilMUnwQeXNd/6CVhjWHzwaWwjUNIKOggUM04YKH4EHJ7vbuz0HmaLYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670568; c=relaxed/simple;
	bh=r+GTdUsOy0Jmy+u9iWLiFIxa3XcFH84Q7lb7NZYC6a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPVRHA0v6BjnObP17Ev6wvDccLXnOmU2y+ueyROo0H1XwvrgI7dO1WSrkDCTJLdLSJZek/3L2Zer55/ip/ZI64DbEzBDWKX3axA9kKULyIXKKNhxar9cDDbsQ+l1vydztbxayCh+BN5Rb1iBk2Yh9QmVPYpk1veN4OUEub/5ovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ2loz5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ2loz5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A001F0089A;
	Thu, 17 Sep 2026 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670566;
	bh=TDZIrfmQe/IiC839tZKus2fJhjNyvWLhQcg4Q0MKoA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ2loz5t7uV1rCXe4ycOMVFXoMVtMB6eOYMzOuaHJvZfhyHowgN0ZSmqAR/yAErw7
	 HGwyGNv1dyI0MXtXiCIPnhAMvc35A7jVTujrTMWh+tWyPG54XH4Fec/52lRpXH2nKo
	 VsbwcbGkq6NB1730F6k83uWONJ9bDntb3XqU5XOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0703/1102] libnvdimm: Replace namespace_match() with device_find_child_by_name()
Date: Thu, 17 Sep 2026 16:10:46 +0100
Message-ID: <20260917151557.959922556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a7512bda7c176553536a5775fa9540223eef3c1f ]

Simplify nd_namespace_store() implementation by
using device_find_child_by_name().

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241224-const_dfc_done-v5-1-6623037414d4@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b4fffa75c1d6 ("Documentation/hwmon: Document hwmon_notify_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/claim.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 030dbde6b0882..9e84ab411564f 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -67,13 +67,6 @@ bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 	return claimed;
 }
 
-static int namespace_match(struct device *dev, void *data)
-{
-	char *name = data;
-
-	return strcmp(name, dev_name(dev)) == 0;
-}
-
 static bool is_idle(struct device *dev, struct nd_namespace_common *ndns)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
@@ -168,7 +161,7 @@ ssize_t nd_namespace_store(struct device *dev,
 		goto out;
 	}
 
-	found = device_find_child(dev->parent, name, namespace_match);
+	found = device_find_child_by_name(dev->parent, name);
 	if (!found) {
 		dev_dbg(dev, "'%s' not found under %s\n", name,
 				dev_name(dev->parent));
-- 
2.53.0



