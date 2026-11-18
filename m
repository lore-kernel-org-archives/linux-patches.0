Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017887;
	b=5oaAgygursI8HeQTwoT47Cwi3TeCeOxvQ8UcsV11nUrModJpJtH6PTJ28OnOKVjP3+Ie
	 dG2HxAR9dOov6RB6nZ5wtWMp/JVWbDrv8uu02T6S3/sRWv5fPkuvgCE0+1KgFqYeTtQK2
	 wiSHNkwgZJGGcCZn6wSAyEGdkM5qN9GRtjF4hlFEPTncLQVK3x9PkAlHzozOoaYR88Wk/
	 DVpOJJ9EiFOdb6dy5JZ/LjdJ+Ubm84a0FtU4GkHlbR3jZ0GPkcTCZpRpa7rZ23Uan+Yr0
	 6QI4B2XlYsUG0SFO01jtUY7rJaj15hTStzvt2kHNXZ3Ogj2Z7UchHZ/t4uO5bFa7M4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PRjK5gXWbUz+CyVhd0eJDO1GTg3gxrE+WUhxrJaK37A=;
	b=KBJkbwXzWBfLnwlR2fRJ4cTxGRYsLj5O21FL5sR+S9VJG4YuhA6jLsW1wSAxisM2thhn
	 AsrdH9M8TE17q0H/9/djhCE134e8tjK0W/LuuSUqz41iQjIl8Ub0pxNSpzaXV1MD9DuQF
	 uxTupSEposMEp3MDgKq3P1Dxn7UL0Lf8DMZfxCeSohQ/80MCb0v28ahMA8B5mcclp+vPc
	 kzh+EBtGf6Nzw7P0shHgQjxM8qLl8L/1gQ7OmHP5Kt/hY9E9tCpStIBn8sYYXietzXgep
	 DG9mgVNibjyR9Qfoyc6b+6OmDgw1CLJhMj2d4RA8fPDoaRuhNCmjHmkY+2dKj4QD5WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hs2t0ngG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB3A606A31C;
	Wed, 18 Nov 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hs2t0ngG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCFC1F000C4;
	Wed, 18 Nov 2026 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017886;
	bh=PRjK5gXWbUz+CyVhd0eJDO1GTg3gxrE+WUhxrJaK37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hs2t0ngGYPphCmsCbI+dvqLz3PhcSzto6Wd+E1veWJ5MNZKGlV6XtHo3wskvzhWtO
	 iIFxhSvTWMTzbE8cO+yr4gaSmOj6Q+mXxoheVUpMK2bv7jwv3zD8uavqzmxPhPZtLy
	 iBLg8STPapNJREuu7S31L03ZsjqGQPyuNghVqnDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1003/2651] arm64: dts: imx95-15x15-frdm: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:23 +0100
Message-ID: <20261118150324.023700826@linuxfoundation.org>
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

[ Upstream commit 5cae743b988da033a709bfa10739b1d34fe57e71 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: 9bdfeed989b1 ("arm64: dts: freescale: imx95: Add support for i.MX95 15x15 FRDM board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts b/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
index 7ed9ff978432e..7ad1a4199ae48 100644
--- a/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
@@ -188,33 +188,33 @@ linux_cma: linux,cma {
 			linux,cma-default;
 		};
 
-		vdev0vring0: memory@88000000 {
+		vdev0vring0: vdev0vring0@88000000 {
 			reg = <0 0x88000000 0 0x8000>;
 			no-map;
 		};
 
-		vdev0vring1: memory@88008000 {
+		vdev0vring1: vdev0vring1@88008000 {
 			reg = <0 0x88008000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring0: memory@88010000 {
+		vdev1vring0: vdev1vring0@88010000 {
 			reg = <0 0x88010000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring1: memory@88018000 {
+		vdev1vring1: vdev1vring1@88018000 {
 			reg = <0 0x88018000 0 0x8000>;
 			no-map;
 		};
 
-		vdevbuffer: memory@88020000 {
+		vdev0buffer: vdev0buffer@88020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x88020000 0 0x100000>;
 			no-map;
 		};
 
-		rsc_table: memory@88220000 {
+		rsc_table: rsc-table@88220000 {
 			reg = <0 0x88220000 0 0x1000>;
 			no-map;
 		};
-- 
2.53.0



