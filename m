Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063861;
	b=TFZ+U9EjFJj7jf4oGtkvgo26qKRo2bj/nqcsVjnqrspWVmkABtM2/LXAP0WaBYnTqyfp
	 IK9puu+dQ8t1nszm8CjRg/tMV0PLHXvpgYq2E1Mia+T/oLTtHifq8ioXZukVrajrBMJ3W
	 aEVgGC44P8bmAaNuuYrIXgRlTnNhnLIZI2yOqqdFjLUE7oQqPX32Iwgg2uZchhJrFS4K/
	 M8TpjmOmvocErVZKLCNOeku6s47n8iNmCCZimL+LdSjSiAYAfx5vQP2g83pkUj66pX+vh
	 /HB50NOWiJLKC3VBuvfGeVOM5T0BLmfReprQAOPMpCsAkTZ9eyJYlqieWMh/QDqfqWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWo4YV1LWp1wq6Kdz2GN/6JOmPqB0Znkm+uaRXtd5FQ=;
	b=RhkaAPf7L13zRWgRMMObSI/QVInMVjHsimdP/KuxW9XNdz4TL8BchCxRwXFGV5Y6nRen
	 IeSGuxVIuDY4b3C7h5LeEA5XLr1jEueafUNtUeCu74C0IX6EJtG1yPdZmOi7TgDBRswk6
	 uGujvfTMjjctuI08a3gXGoi0YZm9iwx6yBE6St8eI/zTQc7c7KSpLYl6WU25VnF5s/d6Q
	 sFppd28cuN2aj/C5P1zdYPuRwgL2BYXCSQhwsbf+l3B8nSOVWgCPz9Iaunp9U4GRCPmGm
	 djbAHi8l7MGHtRmBwr/gTkZC4Fwvi4kCZP3wmFU+Kx/+RW7xLp9ImC9ukYIaYgXiJ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jag2cmCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460E606A9FB;
	Sat,  7 Nov 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jag2cmCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27811F0089F;
	Sat,  7 Nov 2026 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063861;
	bh=cWo4YV1LWp1wq6Kdz2GN/6JOmPqB0Znkm+uaRXtd5FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jag2cmCtbCaGCUIsTQsMiGoVe6dO5ntAtV2zk5848ISFowNc+PRjuOrBo5R9/xFUx
	 QSS1wSvQfmu92mIHSW8UkY/jVfVrgz3sEYVvWu0sayebMVr+QDKV1sx/O6/B3wFz/5
	 YlC0fccN76UDI4pgxyxi2NNgYxqx5/2K+l085knY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0068/1257] clk: mediatek: Add missing depend for COMMON_CLK_MT8173
Date: Sat,  7 Nov 2026 08:39:24 -0500
Message-ID: <20261107134941.271019015@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 84964d0ce3faed815e1b8e048ce5ce1c93badb18 ]

PM_GENERIC_DOMAINS_OF depends on OF, by adding a select to it without
adding a depend on OF, the following warning is triggered:

WARNING: unmet direct dependencies detected for PM_GENERIC_DOMAINS_OF
  Depends on [n]: PM_GENERIC_DOMAINS [=y] && OF [=n]
  Selected by [y]:
  - COMMON_CLK_MT8173_MFGTOP [=y] && COMMON_CLK [=y] && (ARCH_MEDIATEK || COMPILE_TEST [=y]) && COMMON_CLK_MT8173 [=y] && PM [=y]

This patch explicitly adds a dependency on OF to solve this issue.

Cc: stable@vger.kernel.org
Fixes: ebd0b73d2137 ("clk: mediatek: Add mt8173-mfgtop driver")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
index b059d44577f1e..ba1ca9c90dbf1 100644
--- a/drivers/clk/mediatek/Kconfig
+++ b/drivers/clk/mediatek/Kconfig
@@ -541,6 +541,7 @@ config COMMON_CLK_MT8173_MFGTOP
 	tristate "Clock and power driver for MediaTek MT8173 mfgtop"
 	depends on COMMON_CLK_MT8173
 	depends on PM
+	depends on OF
 	default COMMON_CLK_MT8173
 	select PM_GENERIC_DOMAINS
 	select PM_GENERIC_DOMAINS_OF
-- 
2.53.0



