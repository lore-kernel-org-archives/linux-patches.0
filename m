Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053641;
	b=UsI/4uD2Pvb8hUZEZskA1oHvfKDmm8CUacrCV9181BmDNBXG3WFz0lpXnLvUtPwGhv/S
	 EM6yzhTiI0VDUOMmiv1ZL7cs+n7dGtLssqNRmg+Ft8FsyXj/ZMzSXFaKNHxTvFC4ZG6Mh
	 GTrUWmsnkP6kdKP9FGEL0qQiAvJui8y07I14lDwXBLE9GdfIgrs9ACJoEFWCIMrsJFDS+
	 0MZoCODU2QwTuuv988YpdX1KKOWZp6088Ob2UZVWZzCKZuc6en3mwhx8xl9NiOnBW1kET
	 DhMyIq3GMNpoE1QlsSXCLyV3FRBhdXdQeu8oAZJbRFgBSgQ+r9NtjYIpBXrkuNF/HJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ojNXWTd09BZ4uLT2HaZsAUSPkof/88SiF0iKWaPLvwI=;
	b=Mks1ezde0DCCr2BQG970H2EaVTkBnU84LOnQLk/PaHa8eU9JrPUF30C/SGrRQvxOgjDK
	 QDoyDUUZOfp8RMso/DWNEVluTHvxk0+8xV9bokd7CkRYP5/8reXR+NsANgjtvFz/z+q4I
	 zV03tCHEnTVlB26B42hSK6nxz9wzEHkzgZqhMa2C0hHdpKBdXaOUHnzjEEWMV2IRsbZaT
	 FA3z42aC7RV/voKYTapSas6xRHxlnV74DLJVTVKM33XdhB1cqN1PyD0Zxks7/xiV4iO6G
	 4XW/ssfq8SD2ehhc54SKdEOH8HnszHftzYSZinsX4qMWVIsfAz3pa7vmUmQZLbfRysg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VF0rDwkQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6235606A31C;
	Thu, 19 Nov 2026 02:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VF0rDwkQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E92F1F000C4;
	Thu, 19 Nov 2026 02:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053640;
	bh=ojNXWTd09BZ4uLT2HaZsAUSPkof/88SiF0iKWaPLvwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VF0rDwkQhvfnPBaXMdPvCPkvUt1NV4Ndvym9dXYXNDc/7SeN+Ul+FYNf+RnKMLi5s
	 RIVAaIfkVRvPPMnjBhb2gmbVOytFWRr2S6kra/Y1tKm2QBjlYp2Q6SBSL4Qd/bJiEs
	 Mo+56Jw3ZayvRBMNWkffKHvjtAiYzOWY5AsRAFXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0992/2214] iio: light: ltr501: Power down chip if request irq fails
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150052.054616920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 8a9bcd587d7d768e6c8e9fff88bb89645e412731 ]

In case devm_request_threaded_irq() failed, we were leaving the chip
powered instead of powering it down again. Power down the chip switching
ALS and PS modes to standby.

Fixes: 7ac702b3144b ("iio: ltr501: Add interrupt support")
Cc: stable@vger.kernel.org
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: adjusted context for the existing IRQ request failure logging block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index f0bd0ad34f222..a5275165d7fe2 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1510,7 +1510,7 @@ static int ltr501_probe(struct i2c_client *client,
 		if (ret) {
 			dev_err(&client->dev, "request irq (%d) failed\n",
 				client->irq);
-			return ret;
+			goto powerdown_on_error;
 		}
 	} else {
 		indio_dev->info = data->chip_info->info_no_irq;
-- 
2.53.0



