Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041419;
	b=mDftxrz+PnwvLu45IM8aPurWrfioRyPdZkO7+QjMi/vRfiyvOimZquSsSSmnpOp+QkpH
	 Nna1+twXBDFsw8TrnQvfJWveOCzxixdyv7lYfy34cKHatnodLHtTq3dig52PMJk/X2adr
	 5re5M6CjwEK2lbFPHaM7CGDJqaiDX2MNoxVpW3L8TiSvzHBlD65/0lKku/U/eyc+90Gw5
	 etvX9NN8QFpjvW2I/0xpuKfX8KLOw1W8dvlT6i6qRMA/uD+cr8ljTtnRQEfgoVDG5li5f
	 E+T6yIOwqQdS8GlUgVDhpsftQZQRQKGfATu432I/RYuQ4qRi2FMued/F/57T2x0+BCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uBCaEj1UeZa9ZzWPAr5bmQJiCL6jlYxus6AJCyp8ZoQ=;
	b=pvB2Nq+KUhkcyLBlKRWy18CgmycFNEE4yVlrA0jP0tSGqaXure/JD6hH3JwlAg3TcOU0
	 xSIa1rG3VRrstgm75T0KUtC6/o/ZneF/NApGG8Wkd/LPcR2d/8URVEGNP9JNQl4YCJo5i
	 nNaRu+6sozstkJFJfjqcLrL3oVewsb3kLfatbiL+I+vO3KvZQueAYY5ji4LIp2+80kcVI
	 OqW4c+1PMBoAIbAEO+G5lcStR0qOjBIvEJGVI9NGXucKVxx/bXLiNJGg8TRTfblEPYDEA
	 l5b35M/ntTkAJXxUJhMA7XYcXtu0Q5d9pauxI0sreLVTS+tJ9GK3nN9o31Ew1ZOHHyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRO3jPME;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B696606A325;
	Wed, 18 Nov 2026 22:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRO3jPME
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4B51F000C4;
	Wed, 18 Nov 2026 22:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041419;
	bh=uBCaEj1UeZa9ZzWPAr5bmQJiCL6jlYxus6AJCyp8ZoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRO3jPME59zVtxQ5F6IkWbOJh6Ltsndh59qDIVpOgBw16tCVokeZ6Hu/s72/MNJN3
	 7hzUYZ4GI5VHyFgF+w3jbDhHxVEKM8V94tWhLukkVVj5P5mS6AjzoQoShxoBhAukcw
	 F7QWmlBC/715l+KZKhEH71utc8JBpZFidutehxNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daasaradhi Mannava <daasaradhimannava@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2766/3318] platform/x86: msi-ec: Report valid charge thresholds when unset
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150443.707606565@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daasaradhi Mannava <daasaradhimannava@gmail.com>

[ Upstream commit a102207eaf4a18c60c2ffbdc421ad3d30bfed591 ]

The charge thresholds are computed by subtracting a fixed offset from
the raw EC value. When no charge limit has been set, the EC can hold a
value below range_min (0x80 on an MSI GL65 Leopard 9SCXK), and reading
the sysfs attributes returns nonsense:

  charge_control_start_threshold: -10
  charge_control_end_threshold:   0

Both attributes are documented to be within 0 - 100, and an end
threshold of 0 wrongly suggests that charging is disabled.

The store path already rejects values outside range_min..range_max.
Apply the same range to the show path and report the maximum threshold
for any value outside of it.

Tested on an MSI GL65 Leopard 9SCXK (EC firmware 16U8EMS2.100) with
the EC holding 0x80: the attributes now read 90 and 100.

Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Assisted-by: LLM
Signed-off-by: Daasaradhi Mannava <daasaradhimannava@gmail.com>
Link: https://patch.msgid.link/20260916174812.11496-1-daasaradhimannava@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 492eb383ee7a9..c09e0e882c66d 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -728,6 +728,15 @@ static ssize_t charge_control_threshold_show(u8 offset,
 	if (result < 0)
 		return result;
 
+	/*
+	 * The EC may hold an out-of-range value (e.g. 0x80) when no charge
+	 * limit has been set. Report the maximum threshold instead of a
+	 * meaningless (possibly negative) percentage.
+	 */
+	if (rdata < conf.charge_control.range_min ||
+	    rdata > conf.charge_control.range_max)
+		rdata = conf.charge_control.range_max;
+
 	return sysfs_emit(buf, "%i\n", rdata - offset);
 }
 
-- 
2.53.0



