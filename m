Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C187515B0FE;
	Tue,  2 Jul 2024 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940390; cv=none; b=cvNb2qGTBvrSDvrJrPnGOiz4XhyApwmOKQR6diLmfh/zedlJ6Sy5nku9nDHB9lbXaqbPw0b6SyLAPdTgcPkGdHgScSPQ1OWjJtjxJRfPArDaCLXKgLtzVzglj6q7j7/lm2QEDiYbT+lJw8+eDMYuGmPK37X0jWoLCf7kUMmCXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940390; c=relaxed/simple;
	bh=FepIDkRPtvEVuGHjenS3Q5VX1N87jyOmQnBLU7UztOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzY/MsggcdLrziYRT3+YavQ9hqTAAhq1kA3US8s+NnAiN1UjlIBnEp9U4EZY1tJCHgowxN2Qvm7JxJZKXnQYZr55L14scgAVBKdBJORqbxmDoxwbyA6Yup0dxIPCi87CmhSdC4QKudTgj5Ef1eUCH8qQR6yvUhiMlvIsohxlikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK21O3zW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK21O3zW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C6C116B1;
	Tue,  2 Jul 2024 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940390;
	bh=FepIDkRPtvEVuGHjenS3Q5VX1N87jyOmQnBLU7UztOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK21O3zWnmJOPrZNz/2cOLmUAScNe+wlb/q8Gq2jAqoHSOPIKevrHdZSX7bCojCmi
	 j5ULKk0uBkUGMiLXAlp4cUSdiQGGx7sV27T820h5WvamgRuBJNMc6ANePqFhAu8wHh
	 VgaccACCMuS9Dx7KuCZ8eYzyOjD28Qil04UQFnjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 140/222] iio: chemical: bme680: Fix calibration data variable
Date: Tue,  2 Jul 2024 19:02:58 +0200
Message-ID: <20240702170249.322440058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit b47c0fee73a810c4503c4a94ea34858a1d865bba upstream.

According to the BME68x Sensor API [1], the h6 calibration
data variable should be an unsigned integer of size 8.

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x_defs.h#L789

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -38,7 +38,7 @@ struct bme680_calib {
 	s8  par_h3;
 	s8  par_h4;
 	s8  par_h5;
-	s8  par_h6;
+	u8  par_h6;
 	s8  par_h7;
 	s8  par_gh1;
 	s16 par_gh2;


