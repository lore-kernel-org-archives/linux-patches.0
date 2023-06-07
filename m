Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD019E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D217C433EF;
	Wed,  7 Jun 2023 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170151;
	bh=mn6yOpLnmVB/8eVl4VbTg1sHCzJnF0mm0n/P58yMxF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8IEfzOR0oMBIAf60Avxc6Fc9tyugckQsD9M4unN+LS7aUWuNHZeO+o0cWd0aRjei
	 fqnOIECDMHtFfUrOD7woaICSx5CHmkWt9TJ85DTCUirBFQY+WTqvljMwn9DLKbE8/G
	 BJ+EEzT18B6yib4/UcwY0PyFQFvlozTcx6bP3834=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 65/88] iio: dac: build ad5758 driver when AD5758 is selected
Date: Wed,  7 Jun 2023 22:16:22 +0200
Message-ID: <20230607200901.268462912@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit a146eccb68be161ae9eab5f3f68bb0ed7c0fbaa8 upstream.

Commit 28d1a7ac2a0d ("iio: dac: Add AD5758 support") adds the config AD5758
and the corresponding driver ad5758.c. In the Makefile, the ad5758 driver
is however included when AD5755 is selected, not when AD5758 is selected.

Probably, this was simply a mistake that happened by copy-and-paste and
forgetting to adjust the actual line. Surprisingly, no one has ever noticed
that this driver is actually only included when AD5755 is selected and that
the config AD5758 has actually no effect on the build.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20230508040208.12033-1-lukas.bulwahn@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/Makefile
+++ b/drivers/iio/dac/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_AD5592R_BASE) += ad5592r-ba
 obj-$(CONFIG_AD5592R) += ad5592r.o
 obj-$(CONFIG_AD5593R) += ad5593r.o
 obj-$(CONFIG_AD5755) += ad5755.o
-obj-$(CONFIG_AD5755) += ad5758.o
+obj-$(CONFIG_AD5758) += ad5758.o
 obj-$(CONFIG_AD5761) += ad5761.o
 obj-$(CONFIG_AD5764) += ad5764.o
 obj-$(CONFIG_AD5791) += ad5791.o


