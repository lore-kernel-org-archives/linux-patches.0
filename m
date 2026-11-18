Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017758;
	b=Mq/xPVf6OirYnAkWMlemmo417KCmcS4oaaZzvzFz7e4OpYhltlRReu95sSRCzU4ZjJqq
	 bUZypFoGl0+BMlcXgUtI6vQFiNm7pCN7/kPFsz4rtlnMlLkYfoE/zsegJ8+jNj3bDX/Fp
	 3yJVr9tmqlvsM1lXC35QtUQzAWYbaOlp58wRhc5uqn7wOvGNHJ/AwWgoX/Auz/+c0CApm
	 tfpsE+Sxvwe8nw8vGz25de9nxnuj7iQgTBMVyDAxyJCN1DND8kpUAaCsz+sNFad/m98qL
	 wzQHOD3+qevLElE5xV8sr8bnbagsjudDtkCJS5mxFZEx5EhVRwnGdWla+ErY5skvhvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jXa83hPrrXdpIDjFO6Phl+5ByA/oc3qdsuGzp8Krt4Q=;
	b=NCpkGZ6EsnYH/vxv1uS2W8S4LaSoxGCEysP1bmxbMGH75Gi8De6QnXumJn9srtgLM7dL
	 1PtMZZc7CLTbgCjFFDkhZNzQuB6YuokdDOxZ4HinYEmppDA0z9NfZ3StUOifKifISA6LU
	 sI/H2WO9EJolaIwBJCES+0eeI0hY72BszXRj2MYbP3k087/8Zj+Ok8lqHBvR3vPWI88p2
	 /5AO5VaCAL1UeshZvOutjw7YcBBdJAIYpe0cDG6RKI7b14smu/gHvj1o3vpJ+O30w7w8G
	 /s02vy/kw1zIYZX2jMs9HTXOje/kZxLOzsWmPc6NCHUz0v9od4iskH0aVbveezkQgsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+rV4QQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7E606A31C;
	Wed, 18 Nov 2026 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+rV4QQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E171F000D1;
	Wed, 18 Nov 2026 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017758;
	bh=jXa83hPrrXdpIDjFO6Phl+5ByA/oc3qdsuGzp8Krt4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+rV4QQkTWisn+Rz+671ZJZvTe/UY+vspMQEpZb9JB5ZafExVMhIWFkwcb8P6hc+t
	 L8VXyy+cYMvs19wikKlZjo/5FHqgyAMRYnnCTPz/9Bg6QZNVMji6yJ1zbcICOZUMEM
	 67ZhD2pb6FqifZ7pQhvyxhs8oPCHSFgAUoBSMM1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0996/2651] arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150323.760083244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f55e49b75c65c3e38e7bbe1d735f79128a50126e ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 014fbffa25a7 ("arm64: dts: imx8ulp-evk: enable CM33 node")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 4b925832bb662..4e19847f240af 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -80,7 +80,7 @@ vdev1vring1: vdev1vring1@aff18000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a8400000 {
+		vdev0buffer: vdev0buffer@a8400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa8400000 0 0x100000>;
 			no-map;
@@ -139,7 +139,7 @@ &cm33 {
 	mboxes = <&mu 0 1>,
 		 <&mu 1 1>,
 		 <&mu 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



