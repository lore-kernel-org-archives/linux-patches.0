Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055171;
	b=vfLAvWTmkBR8W0ZWON2AkbZmr1MbxGXaaVsWr1L0R2mADwdkhx+l3cTYCyWhfnzcEm19
	 bSuZH4PQy3xkt5DNgE0kdJEq65QsClJaYJsGkahd4qUkN+AffQTW2SeDa3H4Z2+0cxbbz
	 FpaxdVeb5WXMGS8oqC4Eazw54uISKrORacjELLNbsc1e5k0oGAb991QWoIQhKyw9zwHfV
	 /FtiuDnbi7vADpihD1vEGLd37+O/c74zTAMiK2NqaIoYa30w1Dfdswvmo6IEp6cFX2fdE
	 EJVSP4tDLscZUeLdCKw9SX6klblPRI5qSkQkbA47U4wy3DDOEt0NkCCoO12Y7nQdytw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K3pmlky2a+dNua1B5NWyfyJorP1pip/+vKpUTKCJoe0=;
	b=u3Q5NO4IGO4j9JP9WaK3e+6FnAx6e1dYFevm2YzmeOq+nPIHWoLyd72swXhGElHqdAZg
	 kFilUWnTO6sunSjwsjgEw4chyLEWcZj/0afffe4aNdSXbRWm85XA636jKq3jZrtuHrNIW
	 rQ13zbFIJ0PshE+J6lmrvnwO+H8qp9C4jiR9euQismb2rT/PwJm1MbIbB/KMr1Er8IVi9
	 Md1/UzckIJbJIzIfSL6kI7aPaolK0e2osVf85cQXda4F6qeekSvyh80VQuQNDn1SfwzVN
	 xCLr13eCKYkIZea3oDfQLYOPBfJBukmQ2FCU4gm99axY/o++/uAWO4jmlNRTMu7fgIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iggBGFbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FB4606A325;
	Thu, 19 Nov 2026 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iggBGFbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CB71F000C4;
	Thu, 19 Nov 2026 02:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055171;
	bh=K3pmlky2a+dNua1B5NWyfyJorP1pip/+vKpUTKCJoe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iggBGFbc//cUImGMfZYwNCiojGCuZBaraZo+MeI5uztLsGcfFZS02MU1CdBnQF/bu
	 FYVSNKcIFISiwhlmZIplds6p2tURK25wznpjBHnhwnmGiVXT1gxUgswbR2lNhoNefS
	 G+/gr19ZL8LpVZfAHk/XB+G0dvLF2dEyZ4E36MTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1535/2214] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150113.574070293@linuxfoundation.org>
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

From: Triet Hoang <triet.hoang.dev@gmail.com>

[ Upstream commit e98e3d712023859af7cd78bb7fdb87ea3a9ffb83 ]

Check the return value of platform_device_register_data() when
registering the raspberrypi-cpufreq device and propagate the error
if registration fails.

This prevents the clock driver from reporting a successful probe
when the cpufreq device could not be registered.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: e2bb18347c8e5 ("clk: raspberrypi: register platform device for raspberrypi-cpufreq")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 280fd7a5ac75d..7d4476372e324 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -351,6 +351,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



