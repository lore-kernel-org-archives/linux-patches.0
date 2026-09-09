Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694E057F74A;
	Wed,  9 Sep 2026 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963495; cv=none; b=GpivyQUkqyNc6ia0CpXoz44mLT+QXV6fCaJWr739kCrVRWdFp/la1tAozr1X9blS6Ia+QtVYE4BIqj7LW78MHsSYFfGFDQPSQ8DVs8+qyu4mBZbIRuWC/WzPZf5mB2EDhqF8p1HGXOK4hXRofCkzRnP4r8A8PM3s+7g3Ng/q8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963495; c=relaxed/simple;
	bh=DxFAlVXPNK/RBb0bVknyhSKAb0a3uOLwo8NusN85SpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZJjdovd4BVGjApOXqLt16dtr//am67U5SzLsQGFP6t9O2QRp/k9QSEQ3GaeTnnNj/sp44moxgFMfbhI8D335MtFCwa5HfOVsrp8TWCaoKaBHR2Xn+vNQ4Ns/ndVSjlfSzhlPD/yb8P8kxv1WZnnabMTRHiJh7VINxPL7QJZWxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUYw7jis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUYw7jis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C053D1F00A3A;
	Wed,  9 Sep 2026 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963494;
	bh=eTnGNvOrVhYt+vmDr1lAHtR8EZKplPbH5UsvJN0pVRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUYw7jisOMCsPifG0jT0mlMnq6Vdm1qRnt9K206UDVMWKAJHLHIaYwWCxIlGUtcho
	 a5oa6R2S3nQu3+Cvp1Ku+fvXKCvdIfoBXIVjQQvFzmVFjMRdUG73Dh7AWU93SNbK5q
	 hPL/DdTHRbhpSRbna8zI5WrYxkxihY/qE0RVYN8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 098/583] i2c: qcom-geni: update frequency table to fix timing parameters
Date: Wed,  9 Sep 2026 15:36:23 +0200
Message-ID: <20260909134241.522901685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit a4f3fbccb65de757569686baaf2b72e329096aba upstream.

In IPQ5424, to meet the setup and hold timing requirements in the
standard mode, update the frequency table with the values recommended by
HW design team.

Also remove the stray space in the I2C_MAX_FAST_MODE_FREQ entry.

Fixes: 85c34532849d ("i2c: qcom-geni: fix I2C frequency table to achieve accurate bus rates")
Fixes: 506bb2ab0075 ("i2c: qcom-geni: Support systems with 32MHz serial engine clock")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260812-ipq5424_i2c_scl_updates-v2-1-e09cd39d01d7@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -156,8 +156,8 @@ static const struct geni_i2c_clk_fld gen
 
 /* source_clock = 32 MHz */
 static const struct geni_i2c_clk_fld geni_i2c_clk_map_32mhz[] = {
-	{ I2C_MAX_STANDARD_MODE_FREQ, 8, 14, 18, 38 },
-	{ I2C_MAX_FAST_MODE_FREQ, 4,  3, 9, 19 },
+	{ I2C_MAX_STANDARD_MODE_FREQ, 12, 9, 10, 26 },
+	{ I2C_MAX_FAST_MODE_FREQ, 4, 3, 9, 19 },
 	{ I2C_MAX_FAST_MODE_PLUS_FREQ, 2, 3, 5, 15 },
 	{}
 };


