Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064715;
	b=bU+s5vuzHWRpXdd0gCzuLiMFu+le/98oAEuklxN+o6Yu9Muvp+wHM6EVmOKQXS3dl1f/
	 i8/QsA0obyxac/ePWCzk9qjjAHqBDrRuyfrB71m/m89A2ew4sSB2ZjOUW1p1uKNQ7DSL4
	 CBmhiCJtOjU+FTOfXz7mqnbBjj4t+QQVbLR4qwXelstiht+K+Ovuq7S4C/WHZcbbfYK3s
	 /rCVJ39FwsUNQa6R+B9ZmxGpGa78TZVFl5g46vzgbFI4ZtVqnVDiTxQdUkA74Qc9xS52V
	 PMXb6fs02vc+CaJN+1po6MguSTqni/LfgSVJnbAg5SCCd1BAyZMUreSSM0qiwfoyhMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eiIM2AAX+zzL7mq/1nXqr+XyYaXr7mGdM5NtLwmngH8=;
	b=4j8Ak0u4YRvT8C6MJV2/OB2m6BynWj44h9QHuLA9OIvnng9HZXJsAMFu6dSPQ9w7TG5j
	 N/qfmpJxOwa4Dz4nqZB8lvd7r9XFMIUzW5CDfmHLZarqVzDwwYS5s/dzmU18Yv9u8PhTo
	 sDgipzEBDp6G2WDJUGLKImYaZd4usXE/34qOIVHG92oRCADKn2CfU2GBzlSbbhZl6i1JB
	 oktSwekwFd5XT3Qk2A1X2RsFnjpjQaHOchch1X273oxpXZ1ZdPm5GULp3swTlaweR5hyI
	 doAW0AEXrPmr0m/DK1eFA1AsTMAPk+jCa5votgE/QsHFWQhCjE7IvoiZeWua4tHgLfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4cdJAJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B37606A333;
	Sat,  7 Nov 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4cdJAJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023F11F008A2;
	Sat,  7 Nov 2026 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064715;
	bh=eiIM2AAX+zzL7mq/1nXqr+XyYaXr7mGdM5NtLwmngH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4cdJAJieXkDuxPN8nPMf2pf6DZ4cUckX0xZBp0pXMVt2ulF4/KcGm+eaDcUsQRMX
	 QwxgzLNvPgi5VolBCEWBFtf5Oc1zGbdNt1DyL4eZYFPHaT0I4YVdO4puLtH7j9BNfd
	 Ib0t6IxgyElv2bBIje+3PTdhlFiB6pSmiImKPExI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Robinson <pbrobinson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0697/1257] misc: issei: Fix issei architecture deps
Date: Sat,  7 Nov 2026 08:49:53 -0500
Message-ID: <20261107134958.507767557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit a8af929e9d751a85e9f46e8515cbe266249465a2 ]

The issei driver is Intel specific and hence x86 only.

Fixes: 65f0ecb9ec85c ("issei: initial driver skeleton")
Cc: stable <stable@kernel.org>
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://patch.msgid.link/20261003150433.1369234-1-pbrobinson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/issei/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/issei/Kconfig b/drivers/misc/issei/Kconfig
index 12a3fd8099694..dfcfa2d30b9ee 100644
--- a/drivers/misc/issei/Kconfig
+++ b/drivers/misc/issei/Kconfig
@@ -2,6 +2,7 @@
 # Copyright (C) 2023-2026 Intel Corporation
 config INTEL_SSEI
 	tristate "Intel Silicon Security Engine Interface"
+	depends on X86
 	help
 	  The ISSEI (Intel Silicon Security Engine Interface)
 	  subsystem provides a communication channel between the host and the
-- 
2.53.0



