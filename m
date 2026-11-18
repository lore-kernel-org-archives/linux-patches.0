Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057262;
	b=C7zDuqWuGz+0PAr3l/onMJUV2E6LeplyvVKBggdHzxzc1ngPW8D7mYJkWxkzNKwz1iAy
	 XidNJw/qLUJxk+/taxWYJtNrJPSGXA2Ph1YHu5/Y3ijQJIGNocHu0JRoOCw4xz9T1bg7r
	 x4E31bMyqom9kTYgpTrGgTzqsfrYcSDQAxV4DdxUGPfyxYixqbMO0BUda0JR/Lz22Psv9
	 UUAz/d3J1faGb70sWDzNfok126nJyOTs6A8wGe7ePUw0C9im5dfhwMt2cnMjTzHbLBgyH
	 fmUtSdvYtiwQRuQxN3ftxIj2j5jFNIkZGU/py6E/VfgjGgTBz/ChfCL7aabcq+0gn3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IBRHR6xKsRu2ZzL6hpnjcztPFf8atbKaxrWYt0X2bWM=;
	b=IDBvxFwhJ60zeKZTPaAHWl4g63y8bTBKqStuZjRWsEucOLKNQL4uhOZjt9Oa0mEjlT2v
	 dn9SLQxurwbJzUDMSZP99uRoO3QQlYVfwAckPf0cM50+NRX6ZvAdSqs6HLMa1CbbYWdeH
	 kXcQv6FbtxM76AXO+P74kdf5s79+kP1Eg3Y4cZ2azh/4Zndr1X2TWWiooVh/B7SivhKhu
	 CBykiQZnLpoBe0W2IoV1to5RdpZDFGJw60nOsUBJ/npbIxGSyeG+EwinpRvk6nhsseBHV
	 ogot2zXVRCX2V2xYj16q6++DSvqiwmXfIS5NCbZzp4OaF48KpqU7Lo56H16OqxjeCTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu1ImDYU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060CA60A2626;
	Thu, 19 Nov 2026 03:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu1ImDYU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFC71F000C6;
	Thu, 19 Nov 2026 03:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057261;
	bh=IBRHR6xKsRu2ZzL6hpnjcztPFf8atbKaxrWYt0X2bWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu1ImDYUYJSCZHU8VkIRJ8SxAZnZ5yKMzDZuf49DBh61CkSnW5ythyR7mru5rdFgn
	 5PEn8g7plgJrUVU6VnnaATzW1rJmAeXVO68NMPRzM/Ip6ym5XuumVwE3r5DBBjDSsD
	 bJpgygJj4DSFQNuq4yBphZXgjh2y2Dil2Y3c9Jus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0051/1848] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118145913.243076487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 790a2080e0c9eabefea3561dec301172043de236 ]

The driver has a match table for the spi bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1241.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index 0cbbb3c56d08a..0ba0a2c7400da 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -204,6 +204,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{}
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0



