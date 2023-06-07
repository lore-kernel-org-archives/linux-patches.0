Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C2234CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C18C433EF;
	Wed,  7 Jun 2023 20:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170695;
	bh=D+fisbQ+ue9yAD0G5uKUaWIOwX31AyO0LjSAjb5DpZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTzHzYMIo52bCScu011xhqawdKPOs7M0pdmN9hN5chPWuuRukmDzb0E+ot2SOEpqE
	 kZ8j8twTqxqvpSKIzKRecNECGTJbcomhFL0oOq74++RdD2ZYHmsutgbBmousvpKsIQ
	 KdtR3IkT9Svv8TE/rXyNlme9DgEPX8aYIrNT/rxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 154/225] iio: dac: build ad5758 driver when AD5758 is selected
Date: Wed,  7 Jun 2023 22:15:47 +0200
Message-ID: <20230607200919.445671237@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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
@@ -17,7 +17,7 @@ obj-$(CONFIG_AD5592R_BASE) += ad5592r-ba
 obj-$(CONFIG_AD5592R) += ad5592r.o
 obj-$(CONFIG_AD5593R) += ad5593r.o
 obj-$(CONFIG_AD5755) += ad5755.o
-obj-$(CONFIG_AD5755) += ad5758.o
+obj-$(CONFIG_AD5758) += ad5758.o
 obj-$(CONFIG_AD5761) += ad5761.o
 obj-$(CONFIG_AD5764) += ad5764.o
 obj-$(CONFIG_AD5766) += ad5766.o


