Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054954;
	b=kX7Ph0pX2zDXyLOsL2RttXE2RyJ9FM2Ez2kron3bXxD40mVSQmf2p9kdfKgPYwSs8eAh
	 Gwnl7DxewJeDhjksBELtQ4lA2noThlgoLt2ngoARCmqeVuU6aQKdF8xuSCItLU/BicAUH
	 xDTcnBqa/ztqpUsg8Eo1qaXwHbtkE6FU7Ux2J1GKfKnCoCNUzim8HVXjwCnC/RZlMEoeu
	 qrgsu99zWgLFqOVhe+7niIoLxlJh/+p0lHi10kgT4MOBdUD7+Bos9q7mBBmuvoZPMR88j
	 /Oz795c+8rHE7oOcyHL4faGdE2hqIJOC2aTX1P4DkUv+O55HTiwHvwn6LuXwvO9AfyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7mKcV5ecf25BIABh646JUhVICPdwVMU7lMeIavHIyU=;
	b=wHcXSTPQIGpPL3c7xArioN5Yjs2i+GG5R7QPQPl2ysedFYh0iqZgpugnK5DQvjYrEc3E
	 yEjDtrze9CQTmHRRSVpIUIeVlOQkO3fy0Gm5mbbZoNGaHq9ZbtOKCEDX+EFjiVKAdTAfZ
	 A/YzPLWaZY9f2LzEqEAVKX94LJ2oaE5jspaXqWUgRp/BIIePQUSXbaZaXx5fA/NzJ1O4w
	 o2aQmaj+48pjNl2UCn7/ePF/MwL82s0D0m8b5kP43rHS0H2uee1dOioF/+joPJtB9WCos
	 8hGiRtnq5CsGdzOLGOcZcVm/8U+GfUZezNwQIIAtWLccjl0+84j2Uqcesv5l3CNqD1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdwCBLlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4C6606A31C;
	Thu, 19 Nov 2026 02:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdwCBLlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA41F000C4;
	Thu, 19 Nov 2026 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054954;
	bh=+7mKcV5ecf25BIABh646JUhVICPdwVMU7lMeIavHIyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdwCBLlbQ9cs5iCplSRU+x3BcBjV65aAd5Hxo1rDmFPRAg7X/VONZwHJGmpn55s5T
	 5l/kReEaEDwSXD8xu7J3VsODyCKPo4D+sHnikMMnR/GrldVv8o7gS3Uj9xxVbAfsk3
	 5askHPqAH0ZRO3r8BM3gJSYDfBJbfuPaLjAA2vrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1422/2214] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150108.095231831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 1101833121a447999309a01f03d5b35bc1652e09 ]

drivers/power/supply/mp2629_charger.c creates the attribute with
DEVICE_ATTR_RW(batt_impedance_compensation). The ABI file documents it
under the truncated name batt_impedance_compen, which does not exist in
sysfs.

Use the full name.

Fixes: fe27f04e0cdc ("power: supply: mp2629: Add impedance compensation config")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905101849.42830-1-kmehltretter@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-power-mp2629 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documentation/ABI/testing/sysfs-class-power-mp2629
index 914d67caac0d7..a85f926ce9c26 100644
--- a/Documentation/ABI/testing/sysfs-class-power-mp2629
+++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
@@ -1,4 +1,4 @@
-What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compen
+What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compensation
 Date:		April 2020
 KernelVersion:	5.7
 Description:
-- 
2.53.0



