Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF91E140E38;
	Tue, 17 Dec 2024 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456360; cv=none; b=iYTWAE3GtJZWS6jlsaAxWzXKlzzb0WPGaRBVF+ErmZ6eEMdbdkREgsfPolilQz9SmEoSSCtEfeRLzNOnOOT9JxdY56h4qrlRkUCWISEKxslzvk2aoRBtfW+Jg3+3fJrewpu4P2GksiUxnkf29G7DWShgBWXGo5aMtgoKG4QB2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456360; c=relaxed/simple;
	bh=kue0l2nIgBvwhCjT2HgpXxtz8jWB9YWWXr1Af+uGniQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYA5hosm1f3dCA+1nDF5TRmCUPzN4ARydle5PRaMMqxBsYSMP0UiSjzxX3rN60ch4P4OcPb95xgSplNP01p9zKPC6FR7Xtb8uDwbK4ce9MXhN7MP1vawkhmI9U6yWMkRuN6upEHxxHIG/ho24vg6Ei7mF/AxtHy31g7v7jsvVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbDEf8uf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbDEf8uf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0671EC4CED3;
	Tue, 17 Dec 2024 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456360;
	bh=kue0l2nIgBvwhCjT2HgpXxtz8jWB9YWWXr1Af+uGniQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbDEf8uf41no/c5ZAiYRx33N4N7nLmXNKdXea7mpvoWQ2NmztsRxI49AjPYmuGts/
	 PzNN8LZ3/8WvRrn+Gn2++ZTTcEghQ3UdVs3MU7UE3FQfkJipXwBAfr0q6i0/riW718
	 zB4pciFrUnlWQbgJnNM9GNvRCJ7y+mvjb5yKqUis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankar Bandal <shankar.bandal@intel.com>,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 034/172] gpio: graniterapids: Fix invalid GPI_IS register offset
Date: Tue, 17 Dec 2024 18:06:30 +0100
Message-ID: <20241217170547.676884107@linuxfoundation.org>
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

commit 0fe329b55231cca489f9bed1db0e778d077fdaf9 upstream.

Update GPI Interrupt Status register offset to correct value.

Cc: stable@vger.kernel.org
Signed-off-by: Shankar Bandal <shankar.bandal@intel.com>
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-4-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-graniterapids.c b/drivers/gpio/gpio-graniterapids.c
index d2b542b536b6..be907784ccdb 100644
--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -34,7 +34,7 @@
 
 #define GNR_CFG_PADBAR		0x00
 #define GNR_CFG_LOCK_OFFSET	0x04
-#define GNR_GPI_STATUS_OFFSET	0x20
+#define GNR_GPI_STATUS_OFFSET	0x14
 #define GNR_GPI_ENABLE_OFFSET	0x24
 
 #define GNR_CFG_DW_RX_MASK	GENMASK(25, 22)
-- 
2.47.1



