Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81328AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA641C433EF;
	Wed,  4 Jan 2023 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848979;
	bh=s0kT/Y1VsWxsKgOLbCakZ/h0VaCKTkR4AhzbQxJecp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2ECHetaYLxDrFKP8G0hI9rKQ0Gx7fE/EEpXm759PMx4/FLBYUIzKlQtOg8AtpRBz
	 jjk2FKnPj0fUF9xUEDO8HYhoRlRLy4PT34O6QZrx9N30ff4MN/7NE7XaWPKURfeVe2
	 jdrqQwk2AzLriQZugo2OtMLLefsu5jtuIcuGaL9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 115/207] wifi: wilc1000: sdio: fix module autoloading
Date: Wed,  4 Jan 2023 17:06:13 +0100
Message-Id: <20230104160515.548794722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

commit 57d545b5a3d6ce3a8fb6b093f02bfcbb908973f3 upstream.

There are no SDIO module aliases included in the driver, therefore,
module autoloading isn't working. Add the proper MODULE_DEVICE_TABLE().

Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221027171221.491937-1-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MICROCHIP_WILC, SDIO_DEVICE_ID_MICROCHIP_WILC1000) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 


