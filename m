Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062282;
	b=IXkGn/Tn93Q5+CVI/N0lOo5+8IiPHiT5GyfbDbLYF0Y3uWHTNU1Y379Zmrws+29PZeF/
	 v5lrmLu/XOVYZgvwLdanTutf5a5cQMPyRAFlRNH+1/4+gIV+9l4advjXAspuLLsx3oawB
	 nm71rcl4+GegvLdt8bVFTqGuL0ZwmK9fvjRtwfarueTkbJlkNJ1k4auHNomdah9Ur8bim
	 BSQjghqQfLGLSVY1Iq0Y8oHazoNBYz9qtwfNbLsOfVxF5ku1W+sdHwbj1kOFllwUfSVBN
	 kcfkPHKVr0f/iJI2JXLSBFJtFqF/26xmd8+D6Atju0Yfrxz85B+P+XMba3EpkBvUGrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FI6T0qltBp4nClZXxI6lEvGSPBbE66hKvcEtQHhvTtE=;
	b=5a/GGdlpnWOenAOqPOV3AsmtAAv7GRxVrWazCO2znjnBO1/iQjXbtSN6fk/haHJRcrIc
	 JrOkM5WefBH63Fc80kXRHWK3vhQ2NjtaLfuF2vSaF7AeC6FF+hfWwa5TheFY09lV8ZgtV
	 Hj7WiiKm6X102HfvJutfhhQXgqFMn/atf5JKHd4bMcqi4k3wVP2AUxBL38eKyowNsfQB2
	 2epGbIuVkrZIjWhatVJ4Omo4dv++hliFsiIo8QeYcY8Y8IpJ1CzeFVD7oX9CVBikRU4sr
	 6ITnZjEeHHewT2NN+dj1+jA179UWmRpsPxUc8t3D1tAwz30lvlBk3fCtb8baQt7zMIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djYg7Ciq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33B8606D804;
	Sat,  7 Nov 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djYg7Ciq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12261F0089F;
	Sat,  7 Nov 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062281;
	bh=FI6T0qltBp4nClZXxI6lEvGSPBbE66hKvcEtQHhvTtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djYg7CiqhnxThqUwcrt2kyjkPeLsoGB22r4F4zgOQXYe3+0QFGtIUg4janPaVbiuw
	 eOvz+PE5ccMOqCbqQKtBADQ6WX/86+Lrw5PUrgC6bV/JhTFoO3egTUkPM420pk7ISL
	 o6+2zUtOGKUt56qmGk5wPqBNp77kguNPKBeepmmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1221/1536] cxl/port: Convert PCIe link latency to nanoseconds
Date: Sat,  7 Nov 2026 08:53:57 -0500
Message-ID: <20261107135032.049024127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 35aceb7b38040..9c5835eaa22d7 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2129,6 +2129,9 @@ EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
 
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



