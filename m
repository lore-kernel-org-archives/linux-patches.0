Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CF3459AD2;
	Fri,  9 Oct 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557004; cv=none; b=jUR+GnL/SpJ/iZiFwvP4Po13cpysQa48T1obAyPuDzUB/f2IOaH12PxX2OVYpsGuzQfsQRMqiXUqUqhh8ta5rhqHujvkMi7HkzJncq1LmJ9ljS7ysKgaUBS2FPdADNJpRS8ptY4KYkcWuN6lEznlXYlBx6NdrM1McUTHjsyC9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557004; c=relaxed/simple;
	bh=RIxrC9Y4heBcDSzaWZb8jy+2vZI2jGqEH1WK1MPvxPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCIcTC85a8xEwxQB5THdkC41BJR/dTFwuBTr9YFdfJ6x/SHF4XJN2x5ZvfmieHMuokcwz+2MroFt6ALV5Haf1F0642DTN1m8yRLjsFVAjI3N0/ToKuWbfhnowOtD9y7vgZ3YFSDtBS1fFvyn00EO/6UfQ7cwAMN+wLPojX65s54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsry2VtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsry2VtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333591F00893;
	Fri,  9 Oct 2026 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557003;
	bh=iUTrnrpGu1tHOIcL1kc9C/wP/ZAA+oXKWvrxmWV6u3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsry2VtDsI9O0tgnUO47Je4+l8kqXnhd0N+HEK2BNdWcbqcNYtwaVr5AiOlTrCmpy
	 LxB3hOX0+72uu9sIl/vDUt0CL414wlbMPbh/Qp+QEz6CuJbdon3xbVhZc+saP/+LY9
	 V5Pa/pejYVZNhHNFn8X65ugFUv5Ah9+0iHUvPhVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 331/403] iio: pressure: rohm-bm1390: Return error when read fails
Date: Fri,  9 Oct 2026 16:11:32 +0200
Message-ID: <20261009140959.979958860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit b0e951ffc5a28141a106562997ca136ec6a0e1a3 upstream.

The data reading function ignores the cached error value, and
unconditionally returns 0. Return cached 'ret' -value after stopping
the measurement so user knows if read failed and data is garbage.

Fixes: 534674463a59 ("iio: bm1390: simplify using guard(mutex)")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/rohm-bm1390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/rohm-bm1390.c
+++ b/drivers/iio/pressure/rohm-bm1390.c
@@ -289,7 +289,7 @@ static int bm1390_read_data(struct bm139
 	if (warn)
 		dev_warn(data->dev, "Failed to stop measurement (%d)\n", warn);
 
-	return 0;
+	return ret;
 }
 
 static int bm1390_read_raw(struct iio_dev *idev,


