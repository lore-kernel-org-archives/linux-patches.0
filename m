Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D65285047;
	Tue, 17 Jun 2025 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177402; cv=none; b=jLrCMigqAnhGG/xS9GCAEyAmfJgxdMZUfJyoycUORG8YZai5UOx7cMghxIBvrl9szCnfPRrUonIgMRrUr846W0vg4ULgW5zCqakVLFfw/k1mEHnWYyZomBXZjjrpROdS/9BvBk0tpZ9N1p14NNPbbrjAPTML6Ff0rqerZlPqnUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177402; c=relaxed/simple;
	bh=dxoM5M+E1vtvF65dAcOAf/SFyTqGpbmfGQqAXaW7JF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+ChZf9TEPUkNmlmOQ88x6E2yd+hg7hu4I3ruF0R1Us9Zohn3GOulMTVWKX6Ck/PbxP81mg1FcHyLajVM6v392KdDziN23X0DqIcY21oqakiOvjUE89jM1z9D7VjqWllgAAKutmWZ+C1UX6R2IjHq2yoQVeuzqYzxs2n1Ib6ieY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVtDYl/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVtDYl/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91F4C4CEF0;
	Tue, 17 Jun 2025 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177402;
	bh=dxoM5M+E1vtvF65dAcOAf/SFyTqGpbmfGQqAXaW7JF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVtDYl/WhTD294V3goFVKpwZx8hLvKDo10hIt9snKbqr/T53MSkOYWOPIR/y4Pt0x
	 P0L0m+rUGouyq46S3wFQLNJS0BrjZiY+zFwCatxW4jBQTxJ5226ZJ4K3wQbIWH0fGC
	 ZzwM+7EXdjRhTFwuJxT562vhzT7wOom0qlCjsRAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Marius Cristea <marius.cristea@microchip.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/512] iio: adc: PAC1934: fix typo in documentation link
Date: Tue, 17 Jun 2025 17:25:04 +0200
Message-ID: <20250617152433.304012910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marius Cristea <marius.cristea@microchip.com>

[ Upstream commit 52c43d80fa8370eb877fc63b1fc1eec67e1b1410 ]

Fix a typo,(PAC1934 -> PAC193X), into the link from an application note
related to the ACPI device definition.

Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Reported-by: Matteo Martelli <matteomartelli3@gmail.com>
Closes: https://patch.msgid.link/172794015844.2520.11909797050797595912@njaxe.localdomain
Signed-off-by: Marius Cristea <marius.cristea@microchip.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250424-pac1934-doc_link-v1-1-9832445cb270@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/pac1934.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/pac1934.c b/drivers/iio/adc/pac1934.c
index 7ef249d832866..c3f9fa307b84c 100644
--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -1081,7 +1081,7 @@ static int pac1934_chip_identify(struct pac1934_chip_info *info)
 
 /*
  * documentation related to the ACPI device definition
- * https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ApplicationNotes/ApplicationNotes/PAC1934-Integration-Notes-for-Microsoft-Windows-10-and-Windows-11-Driver-Support-DS00002534.pdf
+ * https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ApplicationNotes/ApplicationNotes/PAC193X-Integration-Notes-for-Microsoft-Windows-10-and-Windows-11-Driver-Support-DS00002534.pdf
  */
 static int pac1934_acpi_parse_channel_config(struct i2c_client *client,
 					     struct pac1934_chip_info *info)
-- 
2.39.5



