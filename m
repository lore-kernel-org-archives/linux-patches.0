Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03A018C333;
	Tue,  8 Oct 2024 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393659; cv=none; b=K0YULH+9ZzHldjngXa6WDW5EctpemW3jeDoUmjeABRZZvqP4diYy6rycdTmahiGslr7UeOY8HZYDVuAALO8CLjhcz7sp50pGp049r9HB6OIrPmXr+Gs3dQOacEGBjYFO8MnYShlGyyhvQSIvdhYFAXWlDvkHN94ib77DWCKZihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393659; c=relaxed/simple;
	bh=P5LxcdMvkfupc1U6XrACLxm+nGBg5q3DecDlYKZ5xFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fhtj9YVB1YsU52baQUSYabo2LL5Jx3sczWRhfekRjjBHhWjJIct+5+tsCAQ3weMc8A8kcWpRgAOkVvkKpKVrCIO5Dzp1sLHT0t1hrV9hhZLazpqqepCJ+zk/e0a1D8w0eba9I8LUsBxVRUzQjOhISHvx0+u3ssVoL50uEWyBUac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2hkiaot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2hkiaot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC56C4CECC;
	Tue,  8 Oct 2024 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393659;
	bh=P5LxcdMvkfupc1U6XrACLxm+nGBg5q3DecDlYKZ5xFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2hkiaotyS0GhjAfydrHQwt0TBajfgHcB5iino7hap4dNYc8W41EULpnI8Ed1gpZk
	 TBxEFWaxsRX6APwI2tucWtolCyahNmF7j8+q3SasQf3MLr08eDgbEoZuf0eCEKlhci
	 vr+jeZjwopC9aRrWZ7jfjSsg0N35Ed56qJC5HPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 217/386] spi: bcm63xx: Fix module autoloading
Date: Tue,  8 Oct 2024 14:07:42 +0200
Message-ID: <20241008115637.946532575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 909f34f2462a99bf876f64c5c61c653213e32fce upstream.

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from platform_device_id table.

Fixes: 44d8fb30941d ("spi/bcm63xx: move register definitions into the driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -466,6 +466,7 @@ static const struct platform_device_id b
 	{
 	},
 };
+MODULE_DEVICE_TABLE(platform, bcm63xx_spi_dev_match);
 
 static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6348-spi", .data = &bcm6348_spi_reg_offsets },


