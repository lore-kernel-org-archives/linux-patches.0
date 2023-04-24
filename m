Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E6C7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F87C433D2;
	Mon, 24 Apr 2023 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342434;
	bh=5tFhIybJQJN0Hb94BP2kJXGPvNh37fAzfNZ0oKQzSOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brtoA0VkpU+a1DaabipzOWYv7nK5YRgeJ9LY6UQqVk708in+8Ha5y/mrje1Di6czZ
	 kywdrHWaOdSCJrZDiH0PmXVKtou+UcUnzy8k6qCphnhRYOYNDYhJq4YM5g7dg1aUov
	 Yy5kDhP7A2ZzKYQW4OQ7HnCsVRL6+PCk4Zuv1WDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Brian Masney <bmasney@redhat.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 37/73] iio: light: tsl2772: fix reading proximity-diodes from device tree
Date: Mon, 24 Apr 2023 15:16:51 +0200
Message-Id: <20230424131130.342041590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

commit b1cb00d51e361cf5af93649917d9790e1623647e upstream.

tsl2772_read_prox_diodes() will correctly parse the properties from
device tree to determine which proximity diode(s) to read from, however
it didn't actually set this value on the struct tsl2772_settings. Let's
go ahead and fix that.

Reported-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/lkml/20230327120823.1369700-1-trix@redhat.com/
Fixes: 94cd1113aaa0 ("iio: tsl2772: add support for reading proximity led settings from device tree")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20230404011455.339454-1-bmasney@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2772.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -606,6 +606,7 @@ static int tsl2772_read_prox_diodes(stru
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }


