Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6CD17332C;
	Tue, 26 Aug 2025 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208522; cv=none; b=tbUqod07wtrqJGjIz9cHavxX/A0ksr6S1/RzFWbP8eDy0jQPKbAFvPo8v7K2B3Q5d2ifaDu1j6f5HhOg8zHPtr5PxEIjY6Mgu9eutgWiymPS+9frZ638p8DyeLj9dkCn7Y8AEvJCWrciCGwIKUt94QWfs6meOLND0MXfbmAAEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208522; c=relaxed/simple;
	bh=3b9EFpXRh9bvo4gnOOfIQznvwBUsOxbYxz+YtO8QURM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOEkwQP0yUFDk6rzYVAHnAoCxY5dCvY/vBESVCaPm2CxWJQhchAhPTKp26PD6qwP5E8zgzS69fURftsZK16U8pneL34Ur5suMWulmeeG4VvKm6F4kBJJlJmcBorLd1VKFmFLZbLYXC5ufkd3/v8O7Pd6WEsbQpavDdJjpOq+8EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0HWmokF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0HWmokF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94F4C4CEF1;
	Tue, 26 Aug 2025 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208522;
	bh=3b9EFpXRh9bvo4gnOOfIQznvwBUsOxbYxz+YtO8QURM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0HWmokFl8gy0xD0eDfH/ngy5ZIB5hfzLAYynoESpN4UEV3O6Ani1TBT9+kIalVol
	 qZuBdAI2pvYJKGLB6O77qv2qMifVxRsX62Cwj+HmhHy+RoIvUgupIdNBvZWA/UjsPj
	 vqdez72hx8xnuroCfeafYS8bjjS3h3nEOgMOKkHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 113/322] media: venus: Fix MSM8998 frequency table
Date: Tue, 26 Aug 2025 13:08:48 +0200
Message-ID: <20250826110918.577711584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit ee3b94f22638e0f7a1893d95d87b08698b680052 upstream.

Fill in the correct data for the production SKU.

Fixes: 193b3dac29a4 ("media: venus: add msm8998 support")
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -593,11 +593,11 @@ static const struct venus_resources msm8
 };
 
 static const struct freq_tbl msm8998_freq_table[] = {
-	{ 1944000, 465000000 },	/* 4k UHD @ 60 (decode only) */
-	{  972000, 465000000 },	/* 4k UHD @ 30 */
-	{  489600, 360000000 },	/* 1080p @ 60 */
-	{  244800, 186000000 },	/* 1080p @ 30 */
-	{  108000, 100000000 },	/* 720p @ 30 */
+	{ 1728000, 533000000 },	/* 4k UHD @ 60 (decode only) */
+	{ 1036800, 444000000 },	/* 2k @ 120 */
+	{  829440, 355200000 },	/* 4k @ 44 */
+	{  489600, 269330000 },/* 4k @ 30 */
+	{  108000, 200000000 },	/* 1080p @ 60 */
 };
 
 static const struct reg_val msm8998_reg_preset[] = {


