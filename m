Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211087;
	b=ydcM947gfWNJD64MrD+DMDrXC56eDEZLHSUh1zAiUbYevjQL1QRf/+BOgagqNyvVdgZ3
	 Uw91RNiYSNMhejcsZ5JFoX0rkAhAac1kI0jYqFpxIgUuSjTvtcSAguynCwuej2loijrtF
	 Fuj4THqNKLl/ObkO/+xE3PJUek0warmmcFa8iJzNWbtahnPv95atfA7+o1ei8NXvxlR5Y
	 KJdjQWjKaJZ2bDyv2PzUpiBkPb6fdCo2Nv/Eu6PPljlmfSCMP22i02zL0tOEh0st5FSp0
	 uFaHF0c2Hi48PmeTvcN84ZP8j4WiOt6DjezbXsJ/i0fBkTK8ZfEUHMaBC+6tjan05zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GM+nnM1UuRNc6hswR7lWr4QwNm6e+ilExR8CSiUWpjY=;
	b=cu/LSWsAgLUirUbW57LDEU2fORZ4jv+/s6D5A8o1rp6WK3AyRJQ+i+w3vqlrF1dAGcCb
	 1qFeerw/fgKPSjHrNqG6Ose5GQsRMdMwOEIrh7fIEgNK2qSntoAzIbXTrG6gQPleSNX/h
	 qh2gRYTSPi6E3qfqpTevUfDQGMdEfIKRaqHhOytvRj9zQYuwBNIXtSUTuFxG+hEgz8WTE
	 bwo/Q5om2bDSBa/rUXr4X5N0XrhpKDYOAqDneXLT1fb3UOiWv17OJEJoB18w5yu5uBYZL
	 XbYIJm1DpZIDQ+mcCiPk1Mv/NL3m7hwrtdxY/AZi/DJAezmCGwxPixjBSyU04fIVmyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UONJSNSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B9606A33F;
	Wed, 28 Oct 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UONJSNSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29041F01825;
	Wed, 28 Oct 2026 18:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211086;
	bh=GM+nnM1UuRNc6hswR7lWr4QwNm6e+ilExR8CSiUWpjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UONJSNSaYrdD23x5fXYdVFhz2BNpVXwPwZPDsrNxx9M+GHA2IGKc+KvP4EO592IxV
	 uDh7XuBT1XC5hclPqVvNnXSm+PP0Ydljxm7GI6cSOV/Ahu2/rzzrjp/Mw3eKthrvzP
	 sZmC88ITf8KFKs5niaM1JD0yK36U75AzQwRXMtdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 253/571] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Wed, 28 Oct 2026 17:56:40 +0100
Message-ID: <20261028170014.007434594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 2cdc7ef31827db4fbc6283750420639569e1f0e9 upstream.

If devm_thermal_of_zone_register() fails, probe returns without
unregistering the IIO map array or disabling runtime PM.

Jump to err_map to release them.

Fixes: b0a242894f11 ("iio: adc: sun4i-gpadc-iio: register in the thermal after registering in pm")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -645,10 +645,10 @@ static int sun4i_gpadc_probe(struct plat
 		 * thermal because no thermal DT node is found.
 		 */
 		if (IS_ERR(info->tzd) && PTR_ERR(info->tzd) != -ENODEV) {
-			dev_err(&pdev->dev,
-				"could not register thermal sensor: %ld\n",
-				PTR_ERR(info->tzd));
-			return PTR_ERR(info->tzd);
+			ret = dev_err_probe(&pdev->dev,
+					    PTR_ERR(info->tzd),
+					    "could not register thermal sensor\n");
+			goto err_map;
 		}
 	}
 


