Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622CC296BDF;
	Tue, 26 Aug 2025 11:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207363; cv=none; b=r0J4qqK9mvz0c5HVgh+HubqcKToYBPKmURn8yifRaFeYywcOVo5gYfb+X5DNWuGAQ1cnkvi+02PoAl7CwdRi6kyK+ygUQITJCr/4++XCnlhaf34oFqdO0VBQA1+TXCKqgkMo1Pk6rKFmRPdIlUS+Q6Qh9NIcVyPDAgishJrC+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207363; c=relaxed/simple;
	bh=WVRIm7jKECDqrr+f+Mb0L2zuYX2YQGfjxM1EVPLL614=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcHM8k+CcQK2IzRiT+vN6w8xFAxUqFvGBzqz23HHViasf5aD/98g2z4HTOaxgggADDClENYM9RB4oOC537ewmvaNpWAM4wSPn0RUfsJsRKWGHAlkEl4vKY4zdzy53kljiPKNS6JpTOaAC7Jav8lT+Z2eCEfNpo2Yw8RZ4ZGSrOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6mxGvvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6mxGvvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C6C4CEF1;
	Tue, 26 Aug 2025 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207361;
	bh=WVRIm7jKECDqrr+f+Mb0L2zuYX2YQGfjxM1EVPLL614=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6mxGvvtc2+pRQHYG8T85IC17avEdLcLWzW/NPjpQ/s87j85flrjpRw6fZ+OmiTqJ
	 wfrB2eXTtTAsi0cAvYbGlNI974pz/SY58xgfNXOCA/35xyCAIljzr7/XHuvc+3IRs1
	 7OsH9qHVXtNss8RAKaPicK+6WBFU4lLT5SqczClY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 112/457] i2c: qcom-geni: fix I2C frequency table to achieve accurate bus rates
Date: Tue, 26 Aug 2025 13:06:36 +0200
Message-ID: <20250826110940.138895817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit 85c34532849dae0fdcf880900ac9d7718a73fd1b upstream.

Update the I2C frequency table to match the recommended values
specified in the I2C hardware programming guide. In the current IPQ5424
configuration where 32MHz is the source clock, the I2C bus frequencies do
not meet expectations—for instance, 363KHz is achieved instead of the
expected 400KHz.

Fixes: 506bb2ab0075 ("i2c: qcom-geni: Support systems with 32MHz serial engine clock")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250513-i2c-bus-freq-v1-1-9a333ad5757f@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -155,9 +155,9 @@ static const struct geni_i2c_clk_fld gen
 
 /* source_clock = 32 MHz */
 static const struct geni_i2c_clk_fld geni_i2c_clk_map_32mhz[] = {
-	{ I2C_MAX_STANDARD_MODE_FREQ, 8, 14, 18, 40 },
-	{ I2C_MAX_FAST_MODE_FREQ, 4,  3, 11, 20 },
-	{ I2C_MAX_FAST_MODE_PLUS_FREQ, 2, 3,  6, 15 },
+	{ I2C_MAX_STANDARD_MODE_FREQ, 8, 14, 18, 38 },
+	{ I2C_MAX_FAST_MODE_FREQ, 4,  3, 9, 19 },
+	{ I2C_MAX_FAST_MODE_PLUS_FREQ, 2, 3, 5, 15 },
 	{}
 };
 


