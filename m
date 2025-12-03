Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2932E13D;
	Wed,  3 Dec 2025 15:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777036; cv=none; b=UtSi4WF6NapK0R/J1UcR2ZXRES2wHEEKy3PtU6CjlzXEgerUM/xT3pKzCSa67r08Sa5x/fRu7wRxQvivcFdF/60fK1m/U2yDubDlvu6X/FYDmn23yvWpJAeBfoOX7J/E3RWMDT6GZP0uVivvcTz1AFIVVamRtnjbx3JSgSfW69M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777036; c=relaxed/simple;
	bh=RJ1Vtdq1wRQLbbth7r0mewb2wNGIkF0qA7yoJF8Xwdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frPJEtTJDJOCIB4Owpf8KqcL69QuG3CHbDaA1TImE9rucAXchd95hi4/aDm0UJOUDbVKAxxZPQ1FW56ZRhwakdNQ2b4+g3KiCMp1/hIBGVfU0rH+cAYez8Onwp3bJps2w2dyzu63NheEgqAaxw2FjnkcbIWeT6iGB3nKYJB0pwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXOTUszV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXOTUszV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3826C4CEF5;
	Wed,  3 Dec 2025 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777036;
	bh=RJ1Vtdq1wRQLbbth7r0mewb2wNGIkF0qA7yoJF8Xwdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXOTUszVwwciptIR9yN9GL0C8hVKkREH/cNuwECTtR6eDwZbKahlD6kwPQXstHaE2
	 cVXwexXyCKmazm4bfn96CW6EZq/R1G4/poTBJGDTRSN7omlDTdyltyNFZ7ULy4JGuX
	 p98FtTpezqstyR7UWtG/tki7KFUu7yNhbZ2nCH0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 062/146] iio: adc: stm32-dfsdm: fix st,adc-alt-channel property handling
Date: Wed,  3 Dec 2025 16:27:20 +0100
Message-ID: <20251203152348.736957192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

commit 8a6b7989ff0cd0a95c93be1927f2af7ad10f28de upstream.

Initially st,adc-alt-channel property was defined as an enum in the DFSDM
binding. The DFSDM binding has been changed to use the new IIO backend
framework, along with the adoption of IIO generic channels.
In this new binding st,adc-alt-channel is defined as a boolean property,
but it is still handled has an enum in DFSDM driver.
Fix st,adc-alt-channel property handling in DFSDM driver.

Fixes: 3208fa0cd919 ("iio: adc: stm32-dfsdm: adopt generic channels bindings")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -725,9 +725,8 @@ static int stm32_dfsdm_generic_channel_p
 	}
 	df_ch->src = val;
 
-	ret = fwnode_property_read_u32(node, "st,adc-alt-channel", &df_ch->alt_si);
-	if (ret != -EINVAL)
-		df_ch->alt_si = 0;
+	if (fwnode_property_present(node, "st,adc-alt-channel"))
+		df_ch->alt_si = 1;
 
 	if (adc->dev_data->type == DFSDM_IIO) {
 		backend = devm_iio_backend_fwnode_get(&indio_dev->dev, NULL, node);


