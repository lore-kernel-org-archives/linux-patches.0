Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE14C433D2;
	Mon, 16 Jan 2023 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885298;
	bh=DP1uIAwgeDtcH4k8qHratd8+CyFamSlMM50tHDM04zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD6wQ3fzIFcSTtxx2OON/7Bhj3/jhh6L6qCFRZSPb7VywgY/uuLFKTnDwNxIBVgvj
	 0UiBd5ja01upoVu3wFWnycdgR7YUb5sbz/Hcedfm9Ua4ug6HRqfJo1xstYJKo/LMZw
	 Zv12KOfoMA4Er2RH7LhHXT+8vpZ9IKQDMNnvkhaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.10 64/64] Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"
Date: Mon, 16 Jan 2023 16:52:11 +0100
Message-Id: <20230116154745.815305691@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ferry Toth <ftoth@exalondelft.nl>

commit b659b613cea2ae39746ca8bd2b69d1985dd9d770 upstream.

This reverts commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac.

This patch results in some qemu test failures, specifically xilinx-zynq-a9
machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
to boot from USB drive.

Link: https://lore.kernel.org/lkml/20221220194334.GA942039@roeck-us.net/
Fixes: 8a7b31d545d3 ("usb: ulpi: defer ulpi_register on ulpi_read_id timeout")
Cc: stable@vger.kernel.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221222205302.45761-1-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -208,7 +208,7 @@ static int ulpi_read_id(struct ulpi *ulp
 	/* Test the interface */
 	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	ret = ulpi_read(ulpi, ULPI_SCRATCH);
 	if (ret < 0)


