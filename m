Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704809;
	b=C6Z56MB9ty1DuuYRJ27W6W0wJ3dSt2T6Xes2b2dHmn03Cc01sVnvATo95Uhpcaq1BJNZ
	 vbJUODvN5UdL6eY8K9i2lG2jKsgPSpGws4BuDbVQNPOsDachLAWwSnPzvfAdSd0v3EoYL
	 FSeYsLWXrs6vuYkX7r3owlIj8tJH0VY1kw2t0Vhlhevg0fr7dHKGZhIA8RtOOHgFevo4q
	 +CNJjNh/hLz6eiduB9O14vpJ3iRBdSSDHlDcXWjNCY5Ijy4BmvFxqPQZicEXdwbWX9GZ5
	 lR1W3zIU1afqLReDFfMLT5oDfJPv7cuxF2lvonw8jkT7GQ5BZi/7Xindw2z9BJ4qxew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZRCMAvWN+g+DlK+VeR5A24LO1XANGF9injoZ6hmCC4A=;
	b=wrqNAlvVGFoted3pmMWOA90yq/u56h4sCzJ6wYmWTFJp2UjlOHwutzE14wcijvy8oU82
	 ftD8/TKOz1R/v9Oo/v5hIIs0HxteupGFyH7uJmAhxg5+AVsMDgcgP0N7JnRgKnW3bNuFD
	 cP0dHmkFd59nlFREMf4+gQVacpze0h6hv0X7k9Svcc6u6AGZ+3LnbFyl3GVQIUGtudTV3
	 FEMFbaKWB17FubAngSM8HkVYSXdpAVHJMugPj+kcVRwP0wAj8kiur+5zpPTeSzc4hBFsb
	 m924WSOFihizV12nCuJZ1pSs/BPBJ8tumUNMYzdq3XVeOGhQNkONiztpMseL8juLn5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7wdq4lg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20F606A334;
	Thu, 26 Nov 2026 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7wdq4lg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFFA1F000D1;
	Thu, 26 Nov 2026 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704809;
	bh=ZRCMAvWN+g+DlK+VeR5A24LO1XANGF9injoZ6hmCC4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7wdq4lggCelTbBVreGvhwq66cIYMJwHJnFprSBNCF5mR+eTrJLQkpuni5cNQljPq
	 SIm9dTrVmV3HldGOsaMT8jXG6eC0BM2F53h6Ti7E0pAh85qXn4ztByM+UOui1IQtG3
	 boaqGgh3kNeyu5HbpG4guYnUweQEPe8OdprL9dZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 251/265] iio: imu: kmx61: reject duplicate event disable
Date: Thu, 26 Nov 2026 15:39:41 +0100
Message-ID: <20261126143622.794990218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -948,7 +948,7 @@ static int kmx61_write_event_config(stru
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int ret = 0;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->lock);


