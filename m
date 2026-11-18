Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038127;
	b=B8hCgxt3l96aYV5LM/wRLH+AIB7/3jfPI4FwitMqlP6hoxZK7cL9FdXA4/GqozZycEHK
	 8OOUFWx5IrSKYsLvfO+wnyyvP/ZF58nLP0w2uHL6/oCHTSWZp5tRYOLIMFY40OVzOFzUd
	 1aJ1/kOz0hBnonvJUiLL2SXROjfTF2aYLWzxXSJT7ci0SzZazIEXfveTRExO8PXwp0WIw
	 UKkHCdtEQzlmxiGKTKwdfS5s3nhDywO30Xe8uW6PteehDMjjW6j+nGzJCcG8HBAi8lheJ
	 fH7+VNYbsxHhng4EAT/Bi6RSOdsHQdBgNF787OZ3oOHsWJAJZsTZshL3xuQt0klEFdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjRHDiHuamRumpFukZ2hA1qy0Ryj3UxIuVvNOw4JyvI=;
	b=ajJ2jNJxwVF9rKmXoetUfQIJCMpgKZrhATYVihnh5Cvp61m90DAmwiZgoQMornCXpYrD
	 Rblk5QSFQtemXXkHj4AKJFkTuGUKOI2fK0jTo9O1dazsEYVmtWDtF2lDcmgxOV/w0JIcg
	 YBg3jNRzIAmrs7DrlLvwYw6hdeYmto6mLixVLwmaNdgHCDD6qb9qd8922bSxBu9rH3kRj
	 S6QmOsdOYjJ9EMkV1KkJ6Ss9Xgnjvd+hOBC4il2kZs0zGQ2uXK/IR4jr3PX0c8DohLHSg
	 lFpuQoCt5ejCUrsSOCbwgZKruXd4rwlvG1el1kCGDvEW0/yYCYBRGpjMG7nVaYBl4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMGNRZqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11914606A325;
	Wed, 18 Nov 2026 21:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMGNRZqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4531F000C4;
	Wed, 18 Nov 2026 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038126;
	bh=JjRHDiHuamRumpFukZ2hA1qy0Ryj3UxIuVvNOw4JyvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMGNRZqqm968I/1bDsd2oJciZUdp9GIXyzAxT9hl6VgXzYlACp4nMtJnuCnsra3SJ
	 ZnmUTqxCteRdsbGyWBj3PXyMTWRF7wzbrjv0edYm2a9ZRTn781oEX/wA8LYMrshzF3
	 imCpsDgiMdJssTejqd7dfLDkhJDRpONUJbb6A8Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1634/3318] iio: light: ltr501: Power down chip if request irq fails
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150410.772090982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 8a9bcd587d7d768e6c8e9fff88bb89645e412731 ]

In case devm_request_threaded_irq() failed, we were leaving the chip
powered instead of powering it down again. Power down the chip switching
ALS and PS modes to standby.

Fixes: 7ac702b3144b ("iio: ltr501: Add interrupt support")
Cc: stable@vger.kernel.org
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: adjusted context to preserve existing IRQ request failure logging ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 498cff9327132..deaa18d88e47a 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1557,7 +1557,7 @@ static int ltr501_probe(struct i2c_client *client)
 		if (ret) {
 			dev_err(&client->dev, "request irq (%d) failed\n",
 				client->irq);
-			return ret;
+			goto powerdown_on_error;
 		}
 	} else {
 		indio_dev->info = data->chip_info->info_no_irq;
-- 
2.53.0



