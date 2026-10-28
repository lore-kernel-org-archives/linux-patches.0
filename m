Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212956;
	b=R/0nj1JUjq6XBMhZjbFpZT/+nTCrjcrONCh/vq/5eSsIFZ+ajT9wXzlZnBPlAO5VYtdt
	 D4+MHeoFJz2/aLmZLtOn8Nz9seiYSvibRqU6NBgjE6y+Yx0ZmOv5jlP5IpQUv0RdntOMb
	 KX0bj/SnL5qiQZtCEJAh2xpOPD0Yzkt3K6U1vAeK6n+TzxW9k2T2VYbZfZPTyP4uB5CJn
	 4QzPtx17mbJHVyEVnPGj11nC0w+YSjiuI2tsJTBDQGRt07veROqSxXGiD9e7hBxy7GcWb
	 OsSbO/WAl1giX9aaf+7OHi/TBk916xcC9PiOagku8yRMPAMzzv9fLOsD9fpsUkSWXkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WfH6ewfN9F8XAdZOcB+4T/ofigzlp4yO8hCZXv7M17E=;
	b=YvMafjhn99OzizBjR7MtDmI1USMOr1Ka2BDXgTA7JYnE77DWcKShR8FPeWydn61ucueE
	 XELV8LkOhU1pHBZQLOQAJWU6ZCw8UCM0404ScIwMD9IRHsi4RwwAs1pSwZOw62CQPI7Pw
	 6V3hQ/CMTMb2honm0tPFa5joxLX8T4AqmHir2TQpvnmpmfUoMtgPnes1CBP4Og6pZkqIF
	 8VE7x4GtRzBXW3DBr0dORznKUPyBvR2/XO2DgPiiBDIovZ/1wu5qGaVdrBOhvyi7wIc6N
	 kFSesUCq/d72T3GIShM4e2sEDIbq7oTApb0Zp5N1B4UEnZa7MnKGsYnKbdlkCsY+pxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNuFtH8B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F65606A31A;
	Wed, 28 Oct 2026 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNuFtH8B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F4B1F01825;
	Wed, 28 Oct 2026 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212956;
	bh=WfH6ewfN9F8XAdZOcB+4T/ofigzlp4yO8hCZXv7M17E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNuFtH8B9m6DqIm/ChJuRfAmVC6XWklT/MFiPdGymF0Mabp/UM8R+l2yrn/rED8+4
	 8HxCHNNyPn6ljX1/PS7KP/gVIWjnynHGjqjbchLLtW9oEmWuQq/wlglTPHpoR2eNt/
	 jCl4YHD67juITt0xfsmqppvwc3te9TG+tXE25N60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0334/1887] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Wed, 28 Oct 2026 17:40:30 +0100
Message-ID: <20261028170506.829041174@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 2cdc7ef31827db4fbc6283750420639569e1f0e9 upstream.

If devm_thermal_of_zone_register() fails, probe returns without
unregistering the IIO map array or disabling runtime PM.

Jump to err_map to release them.

Fixes: b0a242894f11 ("iio: adc: sun4i-gpadc-iio: register in the thermal after registering in pm")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -645,10 +645,10 @@ static int sun4i_gpadc_probe(struct plat
 		 * thermal because no thermal DT node is found.
 		 */
 		if (IS_ERR(info->tzd) && PTR_ERR(info->tzd) != -ENODEV) {
-			dev_err(&pdev->dev,
-				"could not register thermal sensor: %ld\n",
-				PTR_ERR(info->tzd));
-			return PTR_ERR(info->tzd);
+			ret = dev_err_probe(&pdev->dev,
+					    PTR_ERR(info->tzd),
+					    "could not register thermal sensor\n");
+			goto err_map;
 		}
 	}
 


