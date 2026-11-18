Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017747;
	b=Gy9U1BjauYr+CtwDio/pomlJitDE3C7lYA6MBiifIKFPhFkbWmDBhkye7otickyQv3yH
	 FsrXHHVZZGsZhJ+7qItKCrT0YuzQy71sdE2rro6X2Nlwkr78+Eku5OBeFiNcTDbpVkcR4
	 ui0DlYBZFWrv2zO5x7A0s2f6Sfu2dJpjdkxr5qQiSXBinM82DdiZRNfYIL9JQ8gTtc04m
	 PLkE5karXZvLoHMeXBeenCxjeSSD3IjJs508L0iSKFvd2nBWBDLEkNimWVKeT3qX4jrmL
	 xgl5n/EnCoJNBPmQy8h8+fkaN+RZ+1bl96kumv/hTSzIgMtpmejxXykg7s/nU449Z2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/fQ7d2AbRPvJghqLzlGUta3qfFB5kA8RnTJzdNGN1E=;
	b=nZDv7ISHGvqN4u9RHmXN1YyGFhpElPGB52fFB9kpBEDLYOpY3UNNUI0CbtEj9a8zaBha
	 L6J0QZGmVgzdHC9exIOOhrSG9MDvDCu0zR1fKBhTRhv8oZwSMoW0ifx6KkKvD6mT9Rv/3
	 nvzvMVa+MdXFOCknBpywUNGKYKUNci/rJ+NUyCfETMVekWv0eKW6o6s8eUfKJPkXIxBBi
	 iBh7PHKBlIuBDuuitfpkhgFp67THyayit5Z+Ky29/vT5fFVUOSeZbC/qnDdPtqtvVoWng
	 uPt9HEERujBYmrcw0K0KN0wWU+Tn9U06Q3brfsEQ9nlc1ETxO5cUDCkNIfAq/db/fyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLApX5UT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDAA606A32F;
	Wed, 18 Nov 2026 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLApX5UT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2E61F000C4;
	Wed, 18 Nov 2026 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017746;
	bh=x/fQ7d2AbRPvJghqLzlGUta3qfFB5kA8RnTJzdNGN1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLApX5UTvBy2I3pXA2IYq1aU5miSHrOgvHk9sXKuPlHyxSMaThXIzBeYSYtoiQ2yk
	 WHKV8WuUhi5SEc6Zh7QNVebUt1xGuk+/rhkKCQMPuCgiK1b+LgDoNaInRLGZSk8cbe
	 2BN+eyjVAzIzydTeq7svvzI9ZVw2mjEGPc8SNF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0993/2651] arm64: dts: imx8qm-mek: fix dsp reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150323.650637019@linuxfoundation.org>
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
index 8b67fb5d670da..1afa65bd955ec 100644
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



