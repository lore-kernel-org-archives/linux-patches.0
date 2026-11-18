Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017839;
	b=b4isw5S1mn85rY4pxWxa8Tj5Zq1qzvddz/6F4XSm3y68ct73uUiZ3FP5U44gwSlwtNPj
	 sdvsGRFOVWAym6Yj9+brUBehyslMH1A9mIvDo6v00bEgSf4HeuGD1d7fhT5KmWuWV9b8e
	 QU1DNGBYmGMl8sboOa1bKfrwo7byilNodHFiO25UHZwiNgTilTBW2nWCEBQdH0R1sCADI
	 370MXlmagp8b9hwfFSexCO63YmCgNEzp0ZYNa1SMTa8nZ/fshIkvxgilIIgluYLX5/KAJ
	 8VheAWEGYm5tlHCIzPzZM0rb2W6UtXmXWr/lSMJbI+zSmvnmXGPh3VQ+2zCZdvUpthg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uNgdIYO87hZRjyLNLc88uIsAVsXAua8WEuw20gke+pM=;
	b=qL8mFtBh17gFRfCmTPkDi84qoBFpepKde1mdu6wfL9QZuFuoTX+m9Qvr2uFr2n+/0ien
	 qBynrMaBWcQvsQarRHLekSihUPK7RWGs0q/4PP4WtTEeuolWbytHbQajvmw1nbLZ6tlcq
	 rmyOkUUYdv7RypO0ogCud8OjMlnakFUvSs3GetRaHaGm/bDYaFn6FiG9eQGDlT5a0I4fv
	 RCWC84V/VVsqn64spWLfWrjSoiNKimp6PQtpo8jtbGM31fodneHaMGgYZEmaAXKRdEE8p
	 7XveunmTtwoN2m/dp4s83plnLqQfY5ZmBzHOKQU9KdUMcnQ+ohvmoUJVMk9s34t6WWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oa8fpY9k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69628606A31C;
	Wed, 18 Nov 2026 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oa8fpY9k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73E41F000C4;
	Wed, 18 Nov 2026 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017839;
	bh=uNgdIYO87hZRjyLNLc88uIsAVsXAua8WEuw20gke+pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oa8fpY9kqHx9SpNA2/OR7kPQ/CsoqVzn5jacudrEmOEuGuk+TCK07zAfdXSUa1izW
	 Wh5AFPMlhN+N0iEYUaCS+4lFyNj/CHh/v1ewmEGYgxKC9Xvsv9z9uA/FUT3dWc3jop
	 RlRajPqPPlePgZWX1k/0Ey4Nll7qRK7DeWVglYe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1000/2651] arm64: dts: imx93-9x9-qsb: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:20 +0100
Message-ID: <20261118150323.912868644@linuxfoundation.org>
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

[ Upstream commit 475a58b82921cc89805b31e0bc1df91681124a3d ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 0565d20cd8c2 ("arm64: dts: freescale: Support i.MX93 9x9 Quick Start Board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
index 01c11c517986a..f07e93653e4e6 100644
--- a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
@@ -76,7 +76,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -212,7 +212,7 @@ &cm33 {
 	mboxes = <&mu1 0 1>,
 		 <&mu1 1 1>,
 		 <&mu1 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



