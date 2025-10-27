Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC0D3233E8;
	Mon, 27 Oct 2025 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590675; cv=none; b=XJJNlwZRG3aZ2Yk6RxvYErO2HpyWXMLXgaTPe0UaR9Hs8eFgK0gYSSIgHCvkHiLVWc44pSgqMlMKzfseG48O2J0qoiw8o1OuORuX7exOXj0LT27AnJ64OzHOIo/GyT2JV5DmKMpst/JNttkLSaRyH6HKhxyoR/Wk0h1kCmIXBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590675; c=relaxed/simple;
	bh=KPBZtEarJ467bIbckJiwkHDZvGHMjgsOimJFgxL5E0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kukzeJKR8ciw70bzXsGADliz2AaEP56QDdp4tba/RGPX+5YLvfVuYD3y23GktQPWlMjh2tf0FrUd9J5MgHF9opWHVwcWx6FtUdsPQjvdQ1QEdSLcu3nuSjAYMK0pY6W1XNdgXa7EVS27ec1VqnwffK/WDpDFI2+uaTAWHn88wP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBMzMnxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBMzMnxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBACC113D0;
	Mon, 27 Oct 2025 18:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590674;
	bh=KPBZtEarJ467bIbckJiwkHDZvGHMjgsOimJFgxL5E0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBMzMnxs3tYDjT18l8DZk8ThY2kH9gEfEByKlSkxofmcNvwnpwhwQydbOnQ21r9LU
	 K6hLVgGOL10zDRKJEMEchLJwLiBZllXFx7Jxj35jmI7AhIySDgyOJzV8u8TaTECHRF
	 OfFjFWLotnWkv/yFU/Wc5Axqbpf6zikSykzx5dtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.4 105/224] media: i2c: mt9v111: fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:34:11 +0100
Message-ID: <20251027183511.806690711@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit bacd713145443dce7764bb2967d30832a95e5ec8 upstream.

Change "ret" from unsigned int to int type in mt9v111_calc_frame_rate()
to store negative error codes or zero returned by __mt9v111_hw_reset()
and other functions.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9v111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -534,8 +534,8 @@ static int mt9v111_calc_frame_rate(struc
 static int mt9v111_hw_config(struct mt9v111_dev *mt9v111)
 {
 	struct i2c_client *c = mt9v111->client;
-	unsigned int ret;
 	u16 outfmtctrl2;
+	int ret;
 
 	/* Force device reset. */
 	ret = __mt9v111_hw_reset(mt9v111);


