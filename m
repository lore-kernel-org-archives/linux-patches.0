Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A63FE2D;
	Mon,  1 Apr 2024 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986726; cv=none; b=Td7CTbXv8xE1TkXBRntxZVHIrzpOU7pbQHmH0efeL94Ut9AaLpy7G9uxdDbxc06aT7wuISIeyxSbByhTE5ikUaZ+yG6ciu8dd2AicpU65Qipxtn93o0DK//HsebIy5IRvTWuMazYBSH6pMzF0ymSrjJWLeyHhYOzjy6SIEHawDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986726; c=relaxed/simple;
	bh=5jIMsmwHqJlAzVs188bkpoPzvdDPqD2O11o1TFRwLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riL8anmrEtKKXpnOMsZbFF0j2YfsicziAnnJ+u0qDDivJ8ipgW9Q6ywH2IjB8JhDN2KC096vwxLhy+blYBxnapVaRqUU2bqe7MwgrE/9wHkOh9nkV8cy9imHKQY/qw4QlKrFRHpn3/hERZ115+2zksMb6V+O3CoRlH+7l0AE+U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqLISEHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqLISEHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC9EC43390;
	Mon,  1 Apr 2024 15:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986726;
	bh=5jIMsmwHqJlAzVs188bkpoPzvdDPqD2O11o1TFRwLF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqLISEHQ7tm79xcBWclNXa7nQ00VFlraK2lfjTrPtcbZSWmm/1o3nqN1BFkOC2e3V
	 3OtBk1AxGR5hcTNsMIVknlpEUjmR0dQPsk17ecMkpSb5jfTDNFPTxJl1n9MpfIUoJ6
	 OlGnC2/gZhnYIvOeTv9AbptI/PKV+zaAv4wW0Soo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 064/399] iio: adc: rockchip_saradc: fix bitmask for channels on SARADCv2
Date: Mon,  1 Apr 2024 17:40:30 +0200
Message-ID: <20240401152551.096775728@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit b0a4546df24a4f8c59b2d05ae141bd70ceccc386 ]

The SARADCv2 on RK3588 (the only SoC currently supported that has an
SARADCv2) selects the channel through the channel_sel bitfield which is
the 4 lowest bits, therefore the mask should be GENMASK(3, 0) and not
GENMASK(15, 0).

Fixes: 757953f8ec69 ("iio: adc: rockchip_saradc: Add support for RK3588")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20240223-saradcv2-chan-mask-v1-1-84b06a0f623a@theobroma-systems.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/rockchip_saradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
index dd94667a623bd..2da8d6f3241a1 100644
--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -52,7 +52,7 @@
 #define SARADC2_START			BIT(4)
 #define SARADC2_SINGLE_MODE		BIT(5)
 
-#define SARADC2_CONV_CHANNELS GENMASK(15, 0)
+#define SARADC2_CONV_CHANNELS GENMASK(3, 0)
 
 struct rockchip_saradc;
 
-- 
2.43.0



