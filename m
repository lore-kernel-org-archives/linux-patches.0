Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174AB2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7270AC433A7;
	Tue,  7 Feb 2023 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775097;
	bh=PkhAOa2M8QTSfj6y+sG5lPQsokaSFL6X1FEumSu0IeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8lSBBS5aiYgLWm86nMNiTeEpYggnKhwxNyW33hJQqaGux2Rcpp2zxc5J8ZUofeb7
	 i/ogVeQlRznzl3cvocqLEGnJ3A0VxPzUcThYdVUI58fszJQn/IWSyAaOXmDXhzqyB+
	 UXU2C5xyspRIR2AJLrzv37FczgeGEM7UFIKXOiPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 135/208] iio: adc: berlin2-adc: Add missing of_node_put() in error path
Date: Tue,  7 Feb 2023 13:56:29 +0100
Message-Id: <20230207125640.546636100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit cbd3a0153cd18a2cbef6bf3cf31bb406c3fc9f55 upstream.

of_get_parent() will return a device_node pointer with refcount
incremented. We need to use of_node_put() on it when done. Add the
missing of_node_put() in the error path of berlin2_adc_probe();

Fixes: 70f1937911ca ("iio: adc: add support for Berlin")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221129020316.191731-1-wangxiongfeng2@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/berlin2-adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/berlin2-adc.c
+++ b/drivers/iio/adc/berlin2-adc.c
@@ -298,8 +298,10 @@ static int berlin2_adc_probe(struct plat
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*priv));
-	if (!indio_dev)
+	if (!indio_dev) {
+		of_node_put(parent_np);
 		return -ENOMEM;
+	}
 
 	priv = iio_priv(indio_dev);
 


