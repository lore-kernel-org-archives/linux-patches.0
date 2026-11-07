Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063252;
	b=ZR6Kx4bfayw/och9Z+KWp9eZu8y1pfFKI6AaWzxzx8rJxkfeVH5bFfMLvEWObuJ4Q0V7
	 yt6NYipf9T977Tl5KLKZioC7+K/OytFsBgsnfS+hAZH4rJ656tJxcym3aXrR8B4u9Hqdr
	 aeLJHUHUXmmrUFLCKgwaVojvxPTluA+6KixTUngaQc+F2coR2CX1H3hfOk+IaUW9RK2O2
	 iX0I6KI8JWiOA45B2qWeLqiZNzEx5UNIrNNhtEr4Mc+QKxOzZqOFIUc/MysNz8J+WyK91
	 wWYV3Up9VZ7/kAVJlodv+lWYdSiN1RssjXqbXJ/0VD/+sHFJRDIgU3F+LyurS0mGc3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFrERnuEbzvHZSEEYkL+xHJ5wqCs8WS1fVaOEE3PY2Y=;
	b=zS4MwqEjqbmITi712VwH3EbPSZJtEyQ83GqERIKMKRBhw/hvAhdgUrhcpCYrOoVWSx//
	 W8cYB54wAmSxj5rsK+3Lwm4pS05Fi81KIVm7RjpceLTA9K0Y6ZHb16y8v9OUA+eXarLsJ
	 7oMvKVCGdD0xHqChU5aJ2NhmlbdU9TGJ+6LZcmB1/4bTdz2WuoPTilJb5Wf08OXi5be85
	 PGBFAv/wI4U6n5kmISbsmqyl0DklaJ6z/aro4r3C3/+Qcn4l0nQnJKawjnVZpsK24b4Xz
	 sqxXhEW2VXhAR2OmJBpXUByIjYgwUpCtyGUb+Nouhd0DXUDIDrUSgKci5tDsREp+KLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6G2fnQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7993B606D818;
	Sat,  7 Nov 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6G2fnQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271B71F0089F;
	Sat,  7 Nov 2026 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063252;
	bh=yFrERnuEbzvHZSEEYkL+xHJ5wqCs8WS1fVaOEE3PY2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6G2fnQBqkOMBrjgfEijwdVyeXWZb8I53GY5b7igAFVTIyWRj5Tx24CXYyrzD2G3o
	 Wa9GEcegzC8XO2w/B7StieQgq7RxShANWFU/EBFczNFZ4uOO+O34RVa96w9fuVDrE9
	 DSCcXuiwlpassGKkvgtvlKA5ElvhuGIoYZ3g6ZzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 454/869] cxl/port: Convert PCIe link latency to nanoseconds
Date: Sat,  7 Nov 2026 08:52:16 -0500
Message-ID: <20261107134909.100470097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 16440d6e4bf1175cda83438d9f9a8ae84bfcf0ee ]

Commit 51293c565cf4 ("cxl: Fix incorrect region perf data calculation")
converted CDAT latencies to nanoseconds and removed the conversion in
cxl_region_perf_data_calculate(), but left PCIe link latencies in
picoseconds.

This inflates the FlitLatency contribution to region and node latencies
by a factor of 1000, exposing incorrect values in sysfs. The resulting
abstract distances can incorrectly reverse the memory tier ordering of
nodes.

Convert the FlitLatency contribution to nanoseconds before adding it to
the access coordinates, rounding up as cdat_normalize() does.

Fixes: 51293c565cf4 ("cxl: Fix incorrect region perf data calculation")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261009045452.1107921-2-den@valinux.co.jp
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 8d2dc4b741781..599aa9d9eddca 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2286,6 +2286,9 @@ EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, "CXL");
 
 static void add_latency(struct access_coordinate *c, long latency)
 {
+	/* Convert link latency from picoseconds to nanoseconds. */
+	latency = DIV_ROUND_UP(latency, 1000);
+
 	for (int i = 0; i < ACCESS_COORDINATE_MAX; i++) {
 		c[i].write_latency += latency;
 		c[i].read_latency += latency;
-- 
2.53.0



