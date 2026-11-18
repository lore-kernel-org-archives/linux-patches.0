Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018260;
	b=nLaL2PIm6GvKPIF5gcwgmgwipVnUgikhTNPQqNMwuDLvh/oc8Mie1nuuV/zAaC4S4yPC
	 J/fyYJxbJFwiuqjxWx91XGeIEFXLQ+gF5m2i/ORk/5yTMhaa5/JBPrS8NLAnP5W0M116K
	 uPf2G4BfyCTKYRD3Ur5EoxmR3pYCA21uVkCuZxo+QNvhP/m6bmmLknf9ridMGl/bL0JMY
	 G4iO/Aqz8SZBxp2LJeYBvld9bWmVP9ivcODxYU7iC85bqYuXxO7zOEUMZkOpU/vjEC1vl
	 tNaRL93gPXckBclXxqhNfBhVOp7U/7eO13m7rLLKVJdmUafZJvGTAwnVIAtY6FV1BjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBvGcNgIVG+XnVqY67gxq3hDzoZgUErr2bHko4y6nPE=;
	b=0c6U962kVoS6/V0T5AYfJW6G8w/V5IJNGrW40ACxDK01dVEo8iLTQSjTj2Hywjxhwy3B
	 VYZi4uBh8qemK7tx4R47TVYnbHnGITSMCK43NLXdmo7e4cIoeRhw24ESzRJk/wZP9JFZa
	 xgcnpA/QKEePMTn5sjiRDWN11qXuvbGcBVlxBGBkwlgvcvajVnVRqpB4Ps9zN/WH7wWgH
	 L45m1azJ4Q51T7/4P8dxRTsTyPi1J9l/DAbUqXzL5Yq8q1RCoTtTMIz/Je+YX/5T72ji9
	 Y03vl1Ah0e0/3Wj3BlEVeGmtWMYGlpWzKECmScNmIzT6ddXGEawSPh8pbC7Hug70q+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpTwF4Qx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7594606A320;
	Wed, 18 Nov 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpTwF4Qx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39C01F000C4;
	Wed, 18 Nov 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018260;
	bh=HBvGcNgIVG+XnVqY67gxq3hDzoZgUErr2bHko4y6nPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpTwF4QxtS0PXlv1xjeTUDBEbuNJtxPBR3k20lXriHiziK22ep0YBEBwL86vbv+Md
	 T/XeXfSOa4l8/LIo2Eh2JwbxyshUQ2psw47IPKNKCRgUMRFrbEvHUPpPgrUXP0LO4/
	 VpCxiFuzSY7SC6grJqoqzlFDXHjwKFkksA0YgfBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kate Hsuan <hpa@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1136/2651] media: i2c: imx471: Fix register size for IMX471_REG_DPGA_USE_GLOBAL_GAIN
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150328.902383814@linuxfoundation.org>
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

From: Kate Hsuan <hpa@redhat.com>

[ Upstream commit 3bfba69ee8f914c5c07bc64e18b66c21bbb05292 ]

The IMX471_REG_DPGA_USE_GLOBAL_GAIN register was incorrectly defined as a
16-bit register, preventing global gain from enabling correctly. As a
result, only the green channel gain was applied instead of the intended
global gain.

Change the register size to 8 bits to ensure global gain is properly
enabled.

Link: https://lore.kernel.org/linux-media/35240e45-c73b-4425-923a-c1026386ed3c@slotpi17m12/
Fixes: be1589e567ae ("media: i2c: imx471: Add Sony IMX471 image sensor driver")
Signed-off-by: Kate Hsuan <hpa@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx471.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx471.c b/drivers/media/i2c/imx471.c
index 4053aed843404..b442b083286d5 100644
--- a/drivers/media/i2c/imx471.c
+++ b/drivers/media/i2c/imx471.c
@@ -46,7 +46,7 @@
 #define IMX471_ANA_GAIN_DEFAULT			0
 
 /* Digital gain control */
-#define IMX471_REG_DPGA_USE_GLOBAL_GAIN		CCI_REG16(0x3ff9)
+#define IMX471_REG_DPGA_USE_GLOBAL_GAIN		CCI_REG8(0x3ff9)
 #define IMX471_REG_DIG_GAIN_GLOBAL		CCI_REG16(0x020e)
 #define IMX471_DGTL_GAIN_MIN			256
 #define IMX471_DGTL_GAIN_MAX			4095
-- 
2.53.0



