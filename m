Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623751;
	b=WWK1woqDwOv4CREZECsdi2O6FnYVtukWv2ukIpPWchNieOW2SHrJAHtWXEpSDjUeDyGl
	 pu3wkl2o7dHgvE1tScilVF9keXbxkLeOcBgOtaooGt9CteUVRCy858tCGUhupFDuts6gT
	 uarjF2NjhzMDQYmoN4+MW0MiJzqC/WuBiGk1zqoctHwxguwKX0ut827qktnydmBfwNQHg
	 Gvhqu8LwLvFO/c5RatriOs2JdlCVUhD8VrlBZhTxxstMeQMJ0A2BEvZSNbGQL9NS9LkoW
	 WcESsd5XgviOhYew5kMwxvPkn9IB7Zh/0dQY9xoziF/qGgmb8WRGMAw1Sz1bAm3Gl/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OJGAiHLeU03ZQiP8i4yqv2HPhNLGnu/PCvadPRY02RU=;
	b=ZUNfzH/SAiPmcAWS/UIrjicgruer9sggGzYO+5UG9geDRVGOJ7/p5//B+trZC9yE/lsi
	 HBmDaNBgO9FMcEn7HExBT39hu7E7OLY3h8ZmJmlLWvKjzlGjsFTgtsAR7VksV+nLhmXeG
	 j3otoTVbGSVdeGI3arO/86vspm0I1zLzhNHH/qK718TCu8IUzABkct3nmPPn5zPEaEc2D
	 L2HNuXevk67wAUHwX0r0j36BNkWiMPCyS8YJB35Ust73uPOpWKAF6nCDKtCdzag8dpd25
	 fMbEI1sqVCtiNNBV7+UUmwzkxe3I0o7OxG5476Vb1XVkT2tRjh4txrScSvLtW7gjVKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypoQToyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEA9606A326;
	Wed, 25 Nov 2026 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypoQToyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFD1F000C0;
	Wed, 25 Nov 2026 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623751;
	bh=OJGAiHLeU03ZQiP8i4yqv2HPhNLGnu/PCvadPRY02RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypoQToyNl1MwrMzoM4vzqftiV1gdbaz5OHuVYSIBjDdZ6K3dgwGuXCkzUe+Va6dIz
	 ScIOqt5/3UJ+0rjJl8tNidk58jQWyc02C6IMdIKdFjwhg/RdiYHeTT1B5sF7KlbIgM
	 HxDWqq6ZRc5i1VdUcvKyKXe4VrSeveziEx9Lwh9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 958/990] iio: imu: kmx61: reject duplicate event disable
Date: Wed, 25 Nov 2026 15:38:45 +0100
Message-ID: <20261125143844.428375761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 9a60b35fe45801d45454e1efe90569c9cc6ea736 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kmx61_write_event_config() already ignores repeated enable
requests, but a repeated disable request still calls
kmx61_set_power_state(data, false, KMX61_ACC), dropping a runtime PM
reference that was not acquired for this request. This can underflow the
runtime PM usage count and trigger a "Runtime PM usage count underflow"
warning.

Return early when the requested state already matches ev_enable_state.

Fixes: fd3ae7a9f21c ("iio: imu: kmx61: Add support for any motion trigger")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -942,7 +942,7 @@ static int kmx61_write_event_config(stru
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int ret = 0;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->lock);


