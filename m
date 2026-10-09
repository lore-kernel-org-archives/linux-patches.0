Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA00353A82;
	Fri,  9 Oct 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557493; cv=none; b=a2vuOuOVvIr7CJyM6GK97WJRdd8wvQ/lttXHdqvgIBJ2pIUi4qIhPErMn7ym2HVK4jKsTqf3T6SR2rHXnY9JqJv0NFJovJbwU0omtKPKVfI6ZL3r9vAbtyOHsonxADetdy3BLZwJjUpkA1TS3OuDT1F82s5Pgtenp13HPUVrV3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557493; c=relaxed/simple;
	bh=+blfnTh4wEesGcZutkbPqWi7K+QlU4e5jMOofzGvbaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1UH1pKi5CrzBIrnh/k1ZfyzMX5/Z4DKUFvah6Z2qNDu3LtzoNK3Dujc5pGpbISjN6R7WauKAlCbjS/qmOWFZ/ySMq6MWYnor7jPF/r5o2xVOE68GBzaTnV9GaWHaM9ITG0XaJPxRgag1S5KPyRXfv3of4WKevY1+O0uRxQyGcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un6ahHpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un6ahHpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73C01F000FF;
	Fri,  9 Oct 2026 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557492;
	bh=9idc6rEdOcX7hqvyJHGaFsnIyJSO+iJSaD6BJbU9htk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=un6ahHpeyBYCv5vL9f2eyOJWxsTkI37w9WgQhfETtLvpkiBPc0illOKH0w4zq7UlQ
	 PmCW7ivpsGdsujgD0hq4OJmfyIJv0pVSyuk1oYqAdaRZbmH4Pg7yQXr6BG5wU9aAM0
	 dXFKVgZL35r4n0b7D6zKqL+M8gepXExAkTACvLEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 378/428] iio: adc: ade9000: handle Phase C dip events in IRQ1 handler
Date: Fri,  9 Oct 2026 16:11:55 +0200
Message-ID: <20261009140954.494444157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit fafefa925ed7ec10383d9bf0378abf878b7f13cb upstream.

ADE9000_ST1_CROSSING_DEPTH is the exclusive upper bound for scanning the
STATUS1 event bits, so a value of 25 left out the highest event bit,
ADE9000_ST1_DIPC_BIT (bit 25). Phase C dip events were never reported.

Bump the value to 26 so bit 25 is scanned.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -219,7 +219,7 @@
 #define ADE9000_ST1_ERROR2_BIT		BIT(30)
 #define ADE9000_ST1_ERROR3_BIT		BIT(31)
 #define ADE9000_ST1_CROSSING_FIRST	6
-#define ADE9000_ST1_CROSSING_DEPTH	25
+#define ADE9000_ST1_CROSSING_DEPTH	26
 
 #define ADE9000_WFB_TRG_DIP_BIT		BIT(0)
 #define ADE9000_WFB_TRG_SWELL_BIT	BIT(1)


