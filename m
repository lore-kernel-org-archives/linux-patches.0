Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024781;
	b=kDdlPvD8xJYRLG5Bu0SPKU/V49b8zjiwUKtrDVbnYWr7o28OGvDFzaO7pf5h9qB9UDCL
	 h5HvE4EoiEojxis52uzmYwBuZk8BJZQUC4BrM0joq+77SJ9i056ydUqSNf87jnNqBWzuo
	 ANP6XlkvtUqoe0YxYX81JnyLzzHyhMLHFvIKwYipPtkkDTYFsm5lRhAlac/RqGwI/Lm2s
	 0lGcdGrbqHhrwEjLXZTOfHUMg7O33+r+S0xAisc5A1G7dFpmYdeqwjcHImNsm43X1L94+
	 t0OmOWsjic857fuIkFfmYlEZ+H93R3FhjLFShbArHzmYDLsj1I0Ef1Rza6OBOg91FXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wm+Yc+w5DB2AjPXJkPU7ROwWEIqXF9HPJY8I57Jen0U=;
	b=AeN7fFBlgi45/qaASHYorcis7h7eRsT6MvxZHuPRKL6XxhOzVFy/5X7Fr5iUJP+otVdB
	 CvE9x6F0Qa3cBq13FSrRZnCrrmm4u33cMN/lYJVP/fz/x+GoWPFPsVXIkBwXDnzGS3vss
	 8YxJQ0GnoWFDQhyjW6ADP9oEj+yqJpbtHjaQXqPWSQ1iwNaASirAaWcUDNTCiAcF9cDlj
	 P3/cSaHexEKWEuGjaMRoasV+lcuE+ZsJOJ8OyCNEFJEYNHj63W3rrxzJE2IAddAhHUHeO
	 67OmoPYwSK0h2wPPOI7gA1lvYx8ZT0Ea3XD0pGExS2rpa0LfZuzfybE0KJaC0TgSoOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K2jH1t2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEE1606A338;
	Wed, 18 Nov 2026 17:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2jH1t2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE9B1F000CA;
	Wed, 18 Nov 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024781;
	bh=Wm+Yc+w5DB2AjPXJkPU7ROwWEIqXF9HPJY8I57Jen0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2jH1t2/BMIdO8B0fjzQSusWxuD9Qz4lxVbO5hzWfwPvRMBxEfwVqci9lkVBtQ1Yv
	 CR7vkxR54fcb8Gcb7ey7qUx3I3jXmvHgrzPuQuDiqfplcF0GbPPKdDk9vUupbmk9LA
	 uf+bID2ckpImFpDaomnoHpj96bo/z+5HQ7jDgLL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0847/2151] arm64: dts: imx8qm-mek: fix dsp reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:02 +0100
Message-ID: <20261118150153.103448208@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 2cd565bde7e872409fa468fb9410e539fb5969e4 ]

The imx_dsp_rproc driver checks for the name "vdev0buffer" to skip
mapping the vdev buffer region, as it is handled by
rproc_add_virtio_dev. With the node named "memory", the check fails
and the region gets unnecessarily mapped.

Rename the DSP reserved memory nodes to use proper names for
consistency with other remoteproc reserved memory regions and to
ensure the vdev0buffer check works correctly.

Rename the DSP reserved memory nodes to use the expected names so
the driver can correctly identify and handle each region.

Fixes: d0ee7ae8ce26 ("arm64: dts: imx8qm-mek: enable dsp node for rproc usage")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index cea9156049b2c..16ed4bdd1d10e 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -105,17 +105,17 @@ dsp_reserved: memory@92400000 {
 			no-map;
 		};
 
-		dsp_vdev0vring0: memory@942f0000 {
+		dsp_vdev0vring0: vdev0vring0@942f0000 {
 			reg = <0 0x942f0000 0 0x8000>;
 			no-map;
 		};
 
-		dsp_vdev0vring1: memory@942f8000 {
+		dsp_vdev0vring1: vdev0vring1@942f8000 {
 			reg = <0 0x942f8000 0 0x8000>;
 			no-map;
 		};
 
-		dsp_vdev0buffer: memory@94300000 {
+		dsp_vdev0buffer: vdev0buffer@94300000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x94300000 0 0x100000>;
 			no-map;
-- 
2.53.0



