Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591150;
	b=XT62d48WyARF6LR7kY12JpNvnxrF+a6x+A6yL96psKDYKt3ot2ju0lbNO7CiYEvQCZjZ
	 Oiak8SZ6v8CuI6gH1Yx+H0am5NZW3quBHtx8SIARNrZDxEQr0z9CjbmfEg6XatjkTEH+P
	 JXIAXCy6p3besi+GSFNk3+tOXUmGJvxiKfG4IVfItsK9VLBB16DXW2qWHD0s5oQO2PT4J
	 OpiHyDh5RjETzm5dA2a18+yjWFHQESFaMk4IIZ09nX+RXzR+a4j2HYLF6haDlm8tw1xYn
	 AmmUljppVzIRsp/FD2vNSjY2aptTgFiBXq6ectqJaMEiCy5xB93Wu+RORqCwTNVeC7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpJagE+STtNkFRtRTmRdfCD5586akGsqrakz+JJV7Sg=;
	b=pzQETkl+YBfUGiEkVHjm1WzMp9dTWD3cCYIuWTVE2gC3BWk36rnvjB3lDSZCr5aPCvTn
	 ni2f+NfUvls3+GIstcMp1K4j8pr733Q6u0gbRNzwUA1MblD+Nn1W4d8q7zF6HdZQnoM4r
	 CpNjgl/lhwisKu/DPgmL2GvGRQlgYD+nQRZNxp7n5NmN3i0/cs3hIoRberchrrICFB+eK
	 PxVQFJwlNwveoo/cuFn7wBs0pi5lrLsgQHRptR/A2A62Ca9vgeGmYyrCXjx46ldj6z0lQ
	 wvwbq/nXpSbtxAGb2SkzKyp+8Q9j2jBwq6Jz5G34oEOyKrr8g4CGas7SeX1XEouxU7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EquBrK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ADE6073FCE;
	Fri, 13 Nov 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EquBrK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89F41F000C4;
	Fri, 13 Nov 2026 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591149;
	bh=lpJagE+STtNkFRtRTmRdfCD5586akGsqrakz+JJV7Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EquBrK1hq70LTJhrS0/JPP1X2tgbpf8g3pan6AIud0sGbvOjxH5KDdHDJmxgECHG
	 FHu7DohqqK7/8PzgFqk1mMwVMFk3i/7CjuiauZqCA5IcNPvkLm/HAGw8LxiFMNU1Xf
	 g+QUywh5Je6y+vUY39nYckXI/sUOa/OOrJZPPSrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/670] hwmon: chipcap2: do not discard pending alarms on disable
Date: Fri, 13 Nov 2026 10:46:56 -0500
Message-ID: <20261113153820.371492370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 22aecf164e1c0c849808c342c65322d14f45176f ]

cc2_disable() stops processing interrupts before the device is powered
down to ignore the alarms caused by voltage toggling. The handler of an
alarm raised by the last measurement might not have run at that point,
and the alarm is discarded when it finally does.

The sysfs read that triggered the measurement can then report no alarm
although the device raised one.

Wait for the alarm handlers that have already been raised before the
interrupt processing is stopped. This covers the case where the handler
thread has not been scheduled yet; an alarm that has not reached the
interrupt core at that point is discarded.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-9-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index aecd320e93d1a..46a3e22f43ade 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -143,6 +143,13 @@ static void cc2_disable(struct cc2_data *data)
 {
 	int err;
 
+	/* let the alarms already raised by the last measurement be processed */
+	if (data->irq_low > 0)
+		synchronize_irq(data->irq_low);
+
+	if (data->irq_high > 0)
+		synchronize_irq(data->irq_high);
+
 	/* ignore alarms triggered by voltage toggling when powering up */
 	data->process_irqs = false;
 
-- 
2.53.0



