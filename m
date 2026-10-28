Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212298;
	b=ln+3B7PcgPvkm2UjPrchTzLprOxNnQwyrKCI0LqDSSBs58JeQJv2B+Av4JQeZrqWRNwm
	 cOmGR6QuFlrbXBm3K4tJOMtBFc1vc/S4QEsZCAN8UOOAyckdHafcEAHg5tGQLPLUKdLhO
	 pSkrnVMSitYmhC174AM3rbH0vqblccE14GOWw6dkHpH/adWdMhWc1ynuke/qRumnxNiCj
	 tdxp587o2Mi+r9Cqf1mWuUlBEvbO1G6DLg33llgq7HidPIfXQcyNlb1ewCa5HLlGGWwah
	 eGjJipo+PFzz8rxJkvmNQi8PA/hCbFyzKFPwfs1QjwW6QruDu52LFR+M4bnoY1qGVKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCnuTV0U1i8md6dz2DY2KNqUuZOnMLG1LlBGCpiX2EE=;
	b=o1xeUzW+RT4S47hhCPTcNIHy5AsX01hzfzzvC0pWKbdb2cWShkJY0DCDIghDMAuVKVTr
	 ksDAAZdH5DcSkFil3+R+EFA+QVYJfOybouhBIpVPIwrmKfbLCcNSnvSrzsgM3sd/1LEzK
	 eWLIW42lPdz6lgGfi1id5zZxJ76uyy2zRO0KiaxrXbi2Jyu2/wnnz36H45ZwSs1Fhq8N/
	 Rn9QGbD6dIw1Qbo66/aWhSIsga1XyIr+ypGdiKjiRVDQuksip4JQ9KlqBE6hr5KMLFa3n
	 0njC04Q7G1SIZ77LYtWX4BzeX38e+vb6JtuEnqZoZtKqq48oJdGhnDEDZ6pSdcAKcQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9Z8Hbfy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393BC606A31D;
	Wed, 28 Oct 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9Z8Hbfy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A8C1F01828;
	Wed, 28 Oct 2026 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212298;
	bh=bCnuTV0U1i8md6dz2DY2KNqUuZOnMLG1LlBGCpiX2EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9Z8HbfyTEAACrZc9lVAGVXGXa6Fi7NCIT/CYNkGAmlfBqBmqpBxBNTLFyOFPzAdf
	 v0JzjeIEBrsLtq9EEAcHtmfiFJVC4796l9JO6/jcybcTZCX7iehu0UrcLXboWrWUQe
	 E/LNoQBTgSufJIMp3m2pslT0Nq+o1n5ODPpDReAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0104/1887] iio: pressure: dps310: fix NULL pointer dereference on ACPI probe
Date: Wed, 28 Oct 2026 17:36:40 +0100
Message-ID: <20261028170501.601002788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

[ Upstream commit 26e9213898fc949923188ef0aeea31fc87708836 ]

When the device is enumerated through its ACPI HID (IFX3100),
i2c_client_get_device_id() returns NULL: the ACPI-derived client name
does not match the driver's i2c_device_id table. dps310_probe() then
dereferences that NULL pointer in "iio->name = id->name" and crashes the
kernel during probe.

The IIO device name is always "dps310", so set it directly and drop the
now-unused device-id lookup.

Fixes: 72ff282819d0 ("iio: pressure: dps310: Add ACPI HID table")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/dps310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 519fcd425b6a3..0057e14a45ddc 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -843,7 +843,7 @@ static int dps310_probe(struct i2c_client *client,
 	data->client = client;
 	mutex_init(&data->lock);
 
-	iio->name = id->name;
+	iio->name = DPS310_DEV_NAME;
 	iio->channels = dps310_channels;
 	iio->num_channels = ARRAY_SIZE(dps310_channels);
 	iio->info = &dps310_info;
-- 
2.53.0



