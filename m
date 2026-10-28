Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217329;
	b=1IjdfXmiGsVin6KhndvoZv5olXNNXf73DaL4SVQO4WBEk1AvuMh5dmwyieY+kAXN1tU2
	 QSF2T6pDtkWYkOEgEbI0d27Eu8p51iDQXpwjYnI/WJVWM7+gtZP+uWhk8gZnKeLlFI+B+
	 h08yotYhSf5gyMdnuEKuxaznd83zWbWB6P1KHqycUNYN89JiAXRcvFrznx3gxRfNhJhSC
	 m9CR4HAykTrf2MbQZ/b0zbh3c6Pt2O/X+daxHeEb9PWlSFx7/EO5mA5fwcpUhLnc5Xrka
	 vjvFPPRiTunOFqY7Xo9OWWbUWAYkExRoJcPH1Hq9fyEw3wAKzAh9wom3M2K80epKn1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=drbuFsWrl100AN1mmjvgJ3GrvbfZ+2lF98lt/pDyYsM=;
	b=v8QTGDqsf/FCqVo+mLS7rOPXjNegDIQ6voQtz3rHuzsZzHUoEBRu6lQG5qPlcgIr89VA
	 jy4iMZ+YgFa5trrIqA/qr1aTQXwFv05Uu90jQ3+ToDazEPAhLyO/uI5nJk42JrKQeR+M6
	 TPitwgG1ePlHoTK/+mPesmeMT0Q8svZK/y1osXIiInWsVygSjEa9yNGeNTegjVH6vmxa6
	 UixOl2r6mgrCYrkvuYMika6G0a/t8DuyfOuxF87hK6r2cVi1k6ZUnj+/TBQcYw80+J5Oj
	 s7qeb9NA6x2ZSvv68cisA4Ga/ob4Kro0A+9DV+R08VthD/oQM0nL86QTeO3AuMPXPtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfr8l0Hk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD275606A31A;
	Wed, 28 Oct 2026 19:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfr8l0Hk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6761F01825;
	Wed, 28 Oct 2026 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217328;
	bh=drbuFsWrl100AN1mmjvgJ3GrvbfZ+2lF98lt/pDyYsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfr8l0HkTFAgl9ZcjkRPSXgX8HddSls7tKKQBl6oBHl6YIXvgZIGg2BafNOqW5B0O
	 5ZwzzLmJDP7B/Ire0Job918jLsec1V3iBgyqNeAe3AwHru8mz/ht2q5rw4cweCVU9j
	 jN/f7/5d4jGt9Wr4mnJYuEhpKc0EK2Vc3oRpkLik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	stable@kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1865/1887] media: verisilicon: Fix kernel panic due to __initconst misuse
Date: Wed, 28 Oct 2026 18:06:01 +0100
Message-ID: <20261028170541.894719840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit e8d97c270cb46a2a88739019d0f8547adc7d97da ]

Fix a kernel panic when probing the driver as a module:

  Unable to handle kernel paging request at virtual address
  ffffd9c18eb05000
  of_find_matching_node_and_match+0x5c/0x1a0
  hantro_probe+0x2f4/0x7d0 [hantro_vpu]

The imx8mq_vpu_shared_resources array is referenced by variant
structures through their shared_devices field. When built as a
module, __initconst causes this data to be freed after module
init, but it's later accessed during probe, causing a page fault.

The imx8mq_vpu_shared_resources is referenced from non-init code,
so keeping __initconst or __initconst_or_module here is wrong.

Drop the __initconst annotation and let it live in the normal .rodata
section.

A bug of __initconst called from regular non-init probe code
leading to bugs during probe deferrals or during unbind-bind cycles.

Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/all/68ef934f-baa0-4bf6-93d8-834bbc441e66@kernel.org/
Reported-by: Franz Schnyder <franz.schnyder@toradex.com>
Closes: https://lore.kernel.org/all/n3qmcb62tepxltoskpf7ws6yiirc2so62ia23b42rj3wlmpl67@rvkbuirx7kkp/
Fixes: e0203ddf9af7 ("media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC")
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Suggested-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: stable@kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
index 80539f7573c18..984a42db38824 100644
--- a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
@@ -359,7 +359,7 @@ const struct hantro_variant imx8mq_vpu_variant = {
 	.num_regs = ARRAY_SIZE(imx8mq_reg_names)
 };
 
-static const struct of_device_id imx8mq_vpu_shared_resources[] __initconst = {
+static const struct of_device_id imx8mq_vpu_shared_resources[] = {
 	{ .compatible = "nxp,imx8mq-vpu-g1", },
 	{ .compatible = "nxp,imx8mq-vpu-g2", },
 	{ /* sentinel */ }
-- 
2.53.0



