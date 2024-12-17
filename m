Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C51F76CE;
	Tue, 17 Dec 2024 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456363; cv=none; b=ifUgDPUaV4gwcJY+2H8PjuJT8EjXHSFj0gfw9leEq4Ck+Etlf8peP7d6wFHfolrOH0keGcJyLiY3GxZYrNq7EGmSnb7+p8iGdQdv8OWMkbLIwoN8KTEgNxsrDOkIuLmHEqdi7Ir/jaw4OQ6zC7r9srBxjTaaiFRpAbLupY7a0+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456363; c=relaxed/simple;
	bh=FuHYmZ75+uDF5yQcbDOJLuIq89cS5K0tjneQdPgYCYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa5ir+NhOSEGXeT3ey5Qr+q/4co86Kvb0WwtgGAECIuKg2tBoGXqdvpHTaL3uCU3+aJQ4C8Vv9NxyNW2natmG7bKnxLkzvIkSwiDimtpkCSrKxbEC9j0AUwXe3af8BuWiNbLxSQOoi0Urwsrg5rJ9kT40iLddf+tEj7r0FSgE4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMnSKl/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMnSKl/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3512C4CED3;
	Tue, 17 Dec 2024 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456363;
	bh=FuHYmZ75+uDF5yQcbDOJLuIq89cS5K0tjneQdPgYCYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMnSKl/Bsnn1ZMJiVJK38auo7xXpXnXGOmcCDJdL4s1PQR8YYslr0TOjoz1zXQd23
	 fetNVFxefDaznWWoWucxKwfmdUE4JViMDaUcXAvng7HEF+VGBaO5mfQ5vtvml80OvM
	 ywgpRSEPkpGN6/w8BNbYqYvezg1qAsXnsmtM81cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankar Bandal <shankar.bandal@intel.com>,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 035/172] gpio: graniterapids: Fix invalid RXEVCFG register bitmask
Date: Tue, 17 Dec 2024 18:06:31 +0100
Message-ID: <20241217170547.717785747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shankar Bandal <shankar.bandal@intel.com>

commit 15636b00a055474033426b94b6372728b2163a1e upstream.

Correct RX Level/Edge Configuration register (RXEVCFG) bitmask.

Cc: stable@vger.kernel.org
Signed-off-by: Shankar Bandal <shankar.bandal@intel.com>
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-5-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-graniterapids.c b/drivers/gpio/gpio-graniterapids.c
index be907784ccdb..ec2931a65723 100644
--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -37,7 +37,7 @@
 #define GNR_GPI_STATUS_OFFSET	0x14
 #define GNR_GPI_ENABLE_OFFSET	0x24
 
-#define GNR_CFG_DW_RX_MASK	GENMASK(25, 22)
+#define GNR_CFG_DW_RX_MASK	GENMASK(23, 22)
 #define GNR_CFG_DW_RX_DISABLE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 2)
 #define GNR_CFG_DW_RX_EDGE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 1)
 #define GNR_CFG_DW_RX_LEVEL	FIELD_PREP(GNR_CFG_DW_RX_MASK, 0)
-- 
2.47.1



