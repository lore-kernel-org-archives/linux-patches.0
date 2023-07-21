Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB9200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FA3C433C8;
	Fri, 21 Jul 2023 19:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966233;
	bh=3Jkdv2zZwOvjXdUADsMIVF9Op7AXx6iXuV1brvJ1xV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPPsex6V2X+nEYezLndZS8DhxXKTZoeiSztYAyxHdRerDxllLKnVeQa98R0/LA73t
	 joiQAAmUdShhP3zkbeeui7++6Nm/qlXMPWdNtoP8YbASWekgrROJg8hkz2bEGMnkCo
	 p+MlpMWZQXhqkvA1MOLyNS3zePiSRSqw+ivgC34s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Lamarque <fl.scratchpad@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 254/532] iio: adc: ad7192: Fix internal/external clock selection
Date: Fri, 21 Jul 2023 18:02:38 +0200
Message-ID: <20230721160628.125372553@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrizio Lamarque <fl.scratchpad@gmail.com>

commit f7d9e21dd274b97dc0a8dbc136a2ea8506063a96 upstream.

Fix wrong selection of internal clock when mclk is defined.

Resolve a logical inversion introduced in c9ec2cb328e3.

Fixes: c9ec2cb328e3 ("iio: adc: ad7192: use devm_clk_get_optional() for mclk")
Signed-off-by: Fabrizio Lamarque <fl.scratchpad@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230530075311.400686-3-fl.scratchpad@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -327,7 +327,7 @@ static int ad7192_of_clock_select(struct
 	clock_sel = AD7192_CLK_INT;
 
 	/* use internal clock */
-	if (st->mclk) {
+	if (!st->mclk) {
 		if (of_property_read_bool(np, "adi,int-clock-output-enable"))
 			clock_sel = AD7192_CLK_INT_CO;
 	} else {


