Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208787;
	b=asDInSygb6FHjqD9u04SiiggqYlwrazzNmEiSbhXxGJRsB5gKskuTSsgSDxeLxZj7TQm
	 jcETdivP2fhbcemkhwvUOXbKGGEyhXswylZlwr0JQSJyBISabJbXiaK6qeZbSBZFDgjnk
	 9Sa84LvWBy1RsO6jXxDevGmVRj4+VVrSpUpkyGgXI+3hp8ncPDov0+YGzTPx8UHjR+gW+
	 PmMFIcWw5yUC8NyKgkDP127QH36tZGcq/LJa+xEOMSgK1zEmU9E9tRtNIohbskVprFwGo
	 SRBMUhvdvvPNiybZQDrjjjQu2ihc4eYKqapbmO7MEdt06nh2B/C9ZYjCXLQWt0UYzPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4sbK9GS0rUNUsNwW3fwx8MEyZcVXkXby2DUKV0ff/Y=;
	b=OhyxhoeQoLWiUGrZnu/ZQ0rJIRRYL2NUe7BdHjOq/nIsJnqhFdcatyz5ApsAF/ZTEByw
	 eFQlACrYLXfXdq27x+f/XwUp4EY6ERv+eV94SpfMToAm/Y5KZ5LWnowYQj0K0GivRhp0m
	 HT0MZEycfgYoRKwg3ceIXPXd6sBXbzcwgBnl+jJby4WMpQqa8wdiGVrdBVBHx5OMDRnLS
	 bwt7FoRN9oXSCWh1YTmArij4aES9VjquKIhi0kQeKFpjlYbg5ablU1quGFweBgFLNdheQ
	 PZe4oBmnOGP0Zzmj3qt+ENSK7m7ypphhCjSCIISXBOL7nxZ+0sW81Z//N3xQci0oRwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJVsrDcj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59204606A31C;
	Wed, 28 Oct 2026 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJVsrDcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE441F01825;
	Wed, 28 Oct 2026 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208787;
	bh=P4sbK9GS0rUNUsNwW3fwx8MEyZcVXkXby2DUKV0ff/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJVsrDcja5NU5Hdg/z1p+jmJRFdEbQXzycxf9D++bkxb4TpDSppeloW3JW79k4T4v
	 89GMXGzv8/hSVFPoqo/w8+o82ZRK+1g2SQib2PN8eUsGgFw2ODxiUd/IbZYNteVDUf
	 uy1CrjwJvvjvrt5qa7WuVxWxyULzy7DbxXQKkxsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 235/516] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Wed, 28 Oct 2026 17:56:27 +0100
Message-ID: <20261028170009.071752875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
 


