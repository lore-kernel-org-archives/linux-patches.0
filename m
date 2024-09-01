Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65291E87B;
	Sun,  1 Sep 2024 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208563; cv=none; b=Kr2dzPgY98C+O+8VtKU35r//eqLBllgodwrjCJPbACdTRTdCRX8yPAzhNRAIFDlQF7TUr5vBSRwJT/txiu773sp2zkjBzJqpnHau1DKK4RpnfkS+KKZZng6ce1Sm+iHaiGxbHjwpitZOKThXzD0XivbPefF9XRlfzKkwQcBidx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208563; c=relaxed/simple;
	bh=7XF2+g29Y4CQvNXzFMyxIvmC3i14rWTKdOAjZrFKbek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkkPBDmsc8Qwqf5bGoZzCMKR7sZOD9FMTW8OK0Rr+S+GYs2VTJJ/Qq0zLJUFrrJdenTD3tEsbq0pWLJKvbem/C8GA1eSFTw8+xurBTpysEAcDIeiajI/4RJ2cD4nL8OYCYH0HZh5eXG5Yss2ylFkXUcQIreSz4ueDrV+a3Oeees=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGy64yfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGy64yfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F41C4CEC3;
	Sun,  1 Sep 2024 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208563;
	bh=7XF2+g29Y4CQvNXzFMyxIvmC3i14rWTKdOAjZrFKbek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGy64yfbowN28+yYiKAunFrI/tW0JiNDtM1xDb0Xw7jISLr7fbHf+ZAoab6Xzenwl
	 lc6vh6TEuxKaBSgS+zSR4z56nthYRASbJXBMVVrW+tzO89Y4Y/PB4EhJZHZgDC4fzo
	 N3pxO2lHT6DdPoaCq9mYyDbroIuQfAqMslOds9BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.10 119/149] usb: typec: fsa4480: Relax CHIP_ID check
Date: Sun,  1 Sep 2024 18:17:10 +0200
Message-ID: <20240901160821.930413434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit 4f83cae0edb2b13aabb82e8a4852092844d320aa upstream.

Some FSA4480-compatible chips like the OCP96011 used on Fairphone 5
return 0x00 from the CHIP_ID register. Handle that gracefully and only
fail probe when the I2C read has failed.

With this the dev_dbg will print 0 but otherwise continue working.

  [    0.251581] fsa4480 1-0042: Found FSA4480 v0.0 (Vendor ID = 0)

Cc: stable@vger.kernel.org
Fixes: e885f5f1f2b4 ("usb: typec: fsa4480: Check if the chip is really there")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240818-fsa4480-chipid-fix-v1-1-17c239435cf7@fairphone.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/fsa4480.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/fsa4480.c b/drivers/usb/typec/mux/fsa4480.c
index cd235339834b..f71dba8bf07c 100644
--- a/drivers/usb/typec/mux/fsa4480.c
+++ b/drivers/usb/typec/mux/fsa4480.c
@@ -274,7 +274,7 @@ static int fsa4480_probe(struct i2c_client *client)
 		return dev_err_probe(dev, PTR_ERR(fsa->regmap), "failed to initialize regmap\n");
 
 	ret = regmap_read(fsa->regmap, FSA4480_DEVICE_ID, &val);
-	if (ret || !val)
+	if (ret)
 		return dev_err_probe(dev, -ENODEV, "FSA4480 not found\n");
 
 	dev_dbg(dev, "Found FSA4480 v%lu.%lu (Vendor ID = %lu)\n",
-- 
2.46.0



