Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEF428B517;
	Sat, 12 Sep 2026 08:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200405; cv=none; b=iWPlrMHGeEqQo6D7fcwJ/AulZSkzv7kTUKncHvkpx6j/eaaV8XXVjaE838Kwt/yc40r8tY1BN4qJiNB5KJIE+HvCmE+eTymVLr/FZMXTnUduRpSNdB4stFcoe+0+RfOS5Mtu9RVTPxF6Fl3SrYEIZbOL7z/P9z2TUWzoW8JE/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200405; c=relaxed/simple;
	bh=d+JIVca+EfXYTC7XMyouMzwifUT27CHejJKP+ZuuOkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLX8vNJue0DwnQRKsomzPSnIRXnRPlyiOgWXMpqOiHTZoN31BgBs8nbadoRw4gbbprklQEw+kBYOyIRDKt8dcP8JqASOTvPxIwJtrTFTxrYFhqh4wGdARbt2uD8ZdnhqNaRXJsfNdPt7XJUqKTeZVQ/ynBC5fgcFHF4XtZKOqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl0GEs/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl0GEs/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D170B1F000FF;
	Sat, 12 Sep 2026 08:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200403;
	bh=iPmmwoymNMKdQHm+4FoRy1pvD7KSBnAvjIvuW2E/T1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl0GEs/7lXeEf2cVx8ZUCoSuMv/Zw5ax2FJoRcYiYgteHJwHS9wGeunTBSLQZRLkB
	 9L0OR48kW7Z08jNINSUUNxNaxh/jwsbAfYOV3yooK8IblJdXtZ7dzPUwFvdWJ7Y0K6
	 dRDH2rld8QehP6QSzt7yfHeyyWRf+H9ZtvCdqMNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0784/1815] soc: qcom: pmic_glink_altmode: Define the TBT extradata properly
Date: Sat, 12 Sep 2026 08:42:14 +0200
Message-ID: <20260912065707.314702726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b255c6f4e6b48e09227cd68777a5d2ec1d36dc31 ]

Before the fixes-referenced commit, there was a trailing 'u32 reserved'
after the payload array. That commit gobbled it up into the thunderbolt
extradata. Push it back where it belongs.

There's no functional change, since the outer struct size remains
identical - struct usbc_sc8280x_tbt_data and therefore the union it's a
part of made up for the difference and the res bytes were ignored
anyway.

Fixes: 0539c5a6fdef ("soc: qcom: pmic_glink_altmode: Consume TBT3/USB4 mode notifications")
Reported-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-tbt_extradata_fixup-v1-1-5caa18f1c8d3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pmic_glink_altmode.c b/drivers/soc/qcom/pmic_glink_altmode.c
index 619bad2c27eeb..13c434f8d03a6 100644
--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -53,7 +53,7 @@ struct usbc_sc8280x_tbt_data {
 	/* This field is NOP on USB4, all cables support rounded rates by spec */
 	u8 rounded_cable : 1;
 	u8 power_limited : 1;
-	u8 res[11];
+	u8 res[7];
 };
 
 struct usbc_notify {
@@ -74,6 +74,7 @@ struct usbc_notify {
 		struct usbc_sc8280x_dp_data dp;
 		struct usbc_sc8280x_tbt_data tbt;
 	} extended_data;
+	u32 reserved;
 };
 
 struct usbc_sc8180x_notify {
-- 
2.53.0



