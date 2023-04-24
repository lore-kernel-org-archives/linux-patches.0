Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A427C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DACC433D2;
	Mon, 24 Apr 2023 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343048;
	bh=zZGXykFC65S68cdngIsxyzHu2u7OF5koxtcAp0i79+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToLsEj5IN7d6JDWTxpSxTiV8nnnHp9Pwc8Y9PAmHF1DnQOs6P8SwhLpzj5/ycq8/Z
	 JecTZwYvtc3z5xN6r6yxxXFR0dEh8ug+6UBAihjNe5BGVKORFEDqAmZTK/sFPPArn8
	 s6NsRVI0MR2tr70cVp/hw6eNrKin8EMH00octMuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 057/110] iio: dac: ad5755: Add missing fwnode_handle_put()
Date: Mon, 24 Apr 2023 15:17:19 +0200
Message-Id: <20230424131138.433051854@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

commit ffef73791574b8da872cfbf881d8e3e9955fc130 upstream.

In ad5755_parse_fw(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 3ac27afefd5d ("iio:dac:ad5755: Switch to generic firmware properties and drop pdata")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20230322035627.1856421-1-windhl@126.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5755.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -802,6 +802,7 @@ static struct ad5755_platform_data *ad57
 	return pdata;
 
  error_out:
+	fwnode_handle_put(pp);
 	devm_kfree(dev, pdata);
 	return NULL;
 }


