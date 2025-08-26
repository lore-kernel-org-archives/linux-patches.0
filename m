Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A141A256B;
	Tue, 26 Aug 2025 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207392; cv=none; b=G6F6jTC10qQy3zvv08KM3V5RXHmSpqUb+o/x9IOwNuxwlLn4mFSiBHC8ZNRw0LcbHU1L47v0mXIYn92mgR1k0qQuWOVitW48leOPANQ6XEo4lAP6MveURYm4VZgA5yhd7Iz4ZDmRo6cDsP1v4c4RHPbv00gmaxjUsS9XNzv95kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207392; c=relaxed/simple;
	bh=mi4JmRiTJIPbiM8UwGix+9WMyGi0vIkych91DyHBh3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+YkJ0VOF+BQl6XC2e1Yb4G+U0sQ3hXzqiR4zo45uXOf8Il7a0kl9XAWFMOuMBmIeUkqjrftJkt2ovghC7kN6sbhZ3jWgYukSbgdEXuv3BngYGrOLNA+NhVo2r1pRcrT5P0ea7KH0MpNMzZpWymwPXHxlDe7178x9ovaxbqZneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJAFrgq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJAFrgq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F2DC4CEF1;
	Tue, 26 Aug 2025 11:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207392;
	bh=mi4JmRiTJIPbiM8UwGix+9WMyGi0vIkych91DyHBh3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJAFrgq2+2UDsC93OKj6sNq+8kJ06zb92FWiKMbzlmruopm57Lc984QYszIyhasmz
	 mBfd0n9wW9CCHRPYh8ZQsEIbsKI4PG1L4RRsF8L8s2jT5QGFggxmM0RfQtNkB+c37B
	 Cm1j9rlhAwvdmBrdJL4S1Jyav1QN6K69r1duShS8=
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
Subject: [PATCH 6.16 147/457] media: venus: Fix MSM8998 frequency table
Date: Tue, 26 Aug 2025 13:07:11 +0200
Message-ID: <20250826110941.004330994@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,11 +709,11 @@ static const struct venus_resources msm8
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


