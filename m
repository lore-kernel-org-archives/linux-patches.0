Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784C406269;
	Sat, 12 Sep 2026 08:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202177; cv=none; b=XlZeBkJLiWMVORIreQHC1HkI1pkqn5Lxc/LsglUXzuuuZ0scEfvdyiCASXqT7O+LzZczmXxf/nSGEITkMMT2l9bkrV8uzBX6YeGZDAqLt5M/owJYWT/UnIGECxoZZcYrkdTua6vi7heZB0zjkEueJ4lMI3CUZ0i7oW49q1sqf/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202177; c=relaxed/simple;
	bh=I7IuOK/GC1lVdMmg+gN2ckLFrzeJtwarVZcyjl9CgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7qF4wsHhUgKso8jJL34V2cOB9m5fi7q9LLVn+/JmwmCD+WLLEi+nzI8s75LVrV1RmrzAnEW1aTusV/uSIi7yZzlh0qppN4WGR9s1APxsHHgyYlO6z5TCc/eMZa3RtRfAimibWcZeZXCVWYRC/U22FYa1hDJ9gRsUtop2CFi+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDkjrUiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDkjrUiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC93E1F000FF;
	Sat, 12 Sep 2026 08:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202173;
	bh=mDLkhlpJjWta9MIOsDXiGSIxR908QuePaduFMKr/gqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDkjrUiB7vroWMFrCgncZF0kT12SENiSfeFvQmv7yUFdKSIueFR7uSBZQpQRR3kfb
	 qasPRQikYjt4/hiNL/RcoloYMeeDbX9ZvDV9kkzXkN990t19vpvXy6crgRphAhqi+U
	 asMlYvw8BHyMsONL8ZjP3U38iwFJTPFLeOQAbmjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1141/1815] soundwire: cadence_master: add BRA_NumBytes[8] support
Date: Sat, 12 Sep 2026 08:48:11 +0200
Message-ID: <20260912065715.804245297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit f74b58902532bf397cdb62049433b5b2a32ddcec ]

The header[0] bit definitions are:
Header[0] bits 7 – 6: BRA_HeaderType
Header[0] bits 5 – 2: BRA_DeviceAddress[3:0]
Header[0] bit 1 BRA_Opcode 1 => Write, 0 => Read
Header[0] bit 0 BRA_NumBytes[8]
And the header[1] indicates the BRA_NumBytes[7:0]. The existing code
doesn't handle BRA_NumBytes[8] therefore the maximum BRA number of a
frame is limited to 255.

Fixes: fe8a9cf75c1e ("soundwire: pass sdw_bpt_section to cdns BPT helpers")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260728124639.1484973-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index eb66345a6a42b..98ed337fb9b01 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -2358,7 +2358,9 @@ int sdw_cdns_prepare_write_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, i
 		p_data = sec[i].buf;
 
 		while (section_size >= data_per_frame) {
-			header[1] = data_per_frame;
+			header[0] &= ~BIT(0);
+			header[0] |= (data_per_frame >> 8) & BIT(0);
+			header[1] = data_per_frame & 0xFF;
 			header[2] = start_register >> 24 & 0xFF;
 			header[3] = start_register >> 16 & 0xFF;
 			header[4] = start_register >> 8 & 0xFF;
@@ -2384,7 +2386,9 @@ int sdw_cdns_prepare_write_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, i
 		}
 
 		if (section_size) {
-			header[1] = section_size;
+			header[0] &= ~BIT(0);
+			header[0] |= (section_size >> 8) & BIT(0);
+			header[1] = section_size & 0xFF;
 			header[2] = start_register >> 24 & 0xFF;
 			header[3] = start_register >> 16 & 0xFF;
 			header[4] = start_register >> 8 & 0xFF;
@@ -2435,7 +2439,9 @@ int sdw_cdns_prepare_read_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, in
 		start_register = sec[i].addr;
 		data_size = sec[i].len;
 		while (data_size >= data_per_frame) {
-			header[1] = data_per_frame;
+			header[0] &= ~BIT(0);
+			header[0] |= (data_per_frame >> 8) & BIT(0);
+			header[1] = data_per_frame & 0xFF;
 			header[2] = start_register >> 24 & 0xFF;
 			header[3] = start_register >> 16 & 0xFF;
 			header[4] = start_register >> 8 & 0xFF;
@@ -2459,7 +2465,9 @@ int sdw_cdns_prepare_read_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, in
 		}
 
 		if (data_size) {
-			header[1] = data_size;
+			header[0] &= ~BIT(0);
+			header[0] |= (data_size >> 8) & BIT(0);
+			header[1] = data_size & 0xFF;
 			header[2] = start_register >> 24 & 0xFF;
 			header[3] = start_register >> 16 & 0xFF;
 			header[4] = start_register >> 8 & 0xFF;
@@ -2482,7 +2490,9 @@ int sdw_cdns_prepare_read_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, in
 	/* Add fake frame */
 	header[0] &= ~GENMASK(7, 6);	/* Set inactive flag in BPT/BRA frame heade */
 	while (fake_size >= data_per_frame) {
-		header[1] = data_per_frame;
+		header[0] &= ~BIT(0);
+		header[0] |= (data_per_frame >> 8) & BIT(0);
+		header[1] = data_per_frame & 0xFF;
 		ret = sdw_cdns_prepare_read_pd0_buffer(header, SDW_CDNS_BRA_HDR, p_dma_buffer,
 						       dma_buffer_size, &dma_data_written,
 						       counter);
@@ -2498,7 +2508,9 @@ int sdw_cdns_prepare_read_dma_buffer(u8 dev_num, struct sdw_bpt_section *sec, in
 	}
 
 	if (fake_size) {
-		header[1] = fake_size;
+		header[0] &= ~BIT(0);
+		header[0] |= (fake_size >> 8) & BIT(0);
+		header[1] = fake_size & 0xFF;
 		ret = sdw_cdns_prepare_read_pd0_buffer(header, SDW_CDNS_BRA_HDR, p_dma_buffer,
 						       dma_buffer_size, &dma_data_written,
 						       counter);
-- 
2.53.0



