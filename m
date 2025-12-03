Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE6350D50;
	Wed,  3 Dec 2025 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781215; cv=none; b=IqpR/ae/Daux6VY0yty32+TSjYb1NjX1D0t/lgb3koO9h2iq27XgFMFwS90xZ+gNM6j7ZyA2mJ7EwQWZzh2bI4CIvf5lW2tD4ItrE7+ltthp6kgCwOszKroN2TSgQPnINxcl3JMSh5AJZWG/z58Swi06NJsih1Vg/38/rjSkuo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781215; c=relaxed/simple;
	bh=A/DAyMrDYktE2lw3G2HY44m+8b/B7aBs1na18Sh6F0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLYSYxuDxegMl+o/KLphkt1SUAXAUPgP8Z/DDZkQrqsjLEACO5uAm9ws/7Ua6p7mAFEaW+bUdlYNyp+9/ZhlpsNh+TYeffQnmPTGflsz8WEVH5sqZPVebuT/MXqYIDehaYK4DxnCE/lxKD7K7jpQIey+QZGO0T/QRBOUcAulFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARJPYm0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARJPYm0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0925C4CEF5;
	Wed,  3 Dec 2025 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781215;
	bh=A/DAyMrDYktE2lw3G2HY44m+8b/B7aBs1na18Sh6F0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARJPYm0PnPStQZrDDW/IJu6LcDqbP8FXik4+Frq783y4KAqAsfYrr1U6CgW1/pv3+
	 /oEEmstUSMvbyTa6BsLu/VgLicLSMqzJ/2PKLe4eV1O/DLaCELcfTkMMFnUL0VISgE
	 LNp8ayKiS69lUpl65904yGHi0NB24GWYIaP4Psp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Hsu <andy_ya_hsu@wiwynn.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 85/93] iio: adc: rtq6056: Correct the sign bit index
Date: Wed,  3 Dec 2025 16:30:18 +0100
Message-ID: <20251203152339.665958892@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 9b45744bf09fc2a3287e05287141d6e123c125a7 ]

The vshunt/current reported register is a signed 16bit integer. The
sign bit index should be '15', not '16'.

Fixes: 4396f45d211b ("iio: adc: Add rtq6056 support")
Reported-by: Andy Hsu <andy_ya_hsu@wiwynn.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adapted switch statement to existing if-else structure for sign_extend32() fix ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rtq6056.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -171,7 +171,7 @@ static int rtq6056_adc_read_channel(stru
 	if (addr == RTQ6056_REG_BUSVOLT || addr == RTQ6056_REG_POWER)
 		*val = regval;
 	else
-		*val = sign_extend32(regval, 16);
+		*val = sign_extend32(regval, 15);
 
 	return IIO_VAL_INT;
 }


