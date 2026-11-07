Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064603;
	b=EvK+u8738ZNQd9BUmo5V79YU9DsV1u3Vm3e5gnJFJ4JyE5w9YZTjiWPJo3ioBn4orpsL
	 QU20CuFpmo+ZT3cP0rDWNM1cX2SOOY90Czx/mqp+ZmJ3U+oSI0QSrkgq4kgFiFP0fQn+V
	 XM3/IM3O8ZtHSjV9pvxWvJxN5G2EnvrkoCajXrIZePCk0uPkzIfYHox6Hs2vm4CNZIj34
	 wd8sCL5FOfdrpojpZrRnC6zWK/EWqDsB/alcCPDhiTqfzBitAMXHvUytfQP6MwQjSn72c
	 +mmyT8K+uI42R73KcTebwVXsfd7+wjCMZQ/ioduoVuF820Soiqa+jt8pGxxsVhw1vCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W05Ez3Vsko8m8WJxqUiLVSaMtq7MTwR+SGR6LZAOObg=;
	b=qJcPwor5vQxY5DR+ku0F9/e538CF77kSNPzEhpjzEJN0ucrFVTOAsf994yqZBqp0kO+z
	 3x/qWXtQMNiApFtglTDln0Ev05DFikQ6peF0PuBToZfj8lulsVb3c5LkQzXJQSSqsMNfg
	 Mb5lv+vaUrAcNqlHIuzDxHHnuwWppuShsnUdt6idekWlDn7Ze3VuBKaMH0uL89vhRwFdC
	 p9ER09F4gjrHGjUV5UHm9oK2k18KadRBvQbSm428EqBUD3wu0+RvAMPs8lTLdkUsxhSet
	 05i3N2CvdRJ7hnXCnF8PbUBc3CfUpZ7Qittc57D8EDcQHbpwNERVkNJ3FUXbhN9EoDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLp15Qv6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22914606E8EF;
	Sat,  7 Nov 2026 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLp15Qv6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44D51F0089F;
	Sat,  7 Nov 2026 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064603;
	bh=W05Ez3Vsko8m8WJxqUiLVSaMtq7MTwR+SGR6LZAOObg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLp15Qv6iMFNxMVd5+7ZwCLBAhVicOo+QmkMI519jBBWhyMV53NyL8iEQB/5WIz3T
	 x//idTj8kh8BMe6gLhjV9xcVKucMwqilq7HjnbS9/2Y7RyL28LVthIWYTSR2+aVnjf
	 dbjDT870l6gOdqbSOgs2e/oaq4Wx5MvfM5RMkSsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0615/1257] cxl/port: Convert PCIe link latency to nanoseconds
Date: Sat,  7 Nov 2026 08:48:31 -0500
Message-ID: <20261107134956.288888962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 6ff3353865e39..cd9e58d8144f1 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2349,6 +2349,9 @@ EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, "CXL");
 
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



