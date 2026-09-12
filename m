Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD25331209;
	Sat, 12 Sep 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197847; cv=none; b=AhL4hpIkJOTdnJhPGb0AUvqnGRfCfh/raqKArCjsNOewYY7msGCzLDs6K6NvsfraeMugwb7LztG+ctSueu93Wa0+po2KGfjSmtJtwCODKVJfMKtOH9msRMNZriOtvTZSWycQGXwAQxH6VB/bhbPUWl8UMPm2PnsmQPsDQ7YJ6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197847; c=relaxed/simple;
	bh=8Ca25Cok3+lidPzxa1M9hoBlNGDnxCpqyCyHbetEz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA5QCUYkCEFpE+qTO3yCkB83QDO7Y+3mA3gKA3PxRS5DwAfzicedpiUj0CRPoHraaOiVmBZk7HxfNNDRsPhzSRpOThqKytBn7urpaK7lKd4nVMmVIz51m3Sz4yUACBT5NcfM9UqgZmuSVLdSn5ZYq48LVijlLsM7DOT2WSjTqRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9LPdS8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9LPdS8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85341F000FF;
	Sat, 12 Sep 2026 07:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197846;
	bh=B2pJbN3cF7f++PtiiJs0+u3lrHYTZQ4p/jglDxL566A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9LPdS8scm5Faz3ltZzXPCym4y4JwAeGuFC42PyHZaYZa2Ja6AgLU1YT2fY7Tfts2
	 6zimtY6KFAMdDlFsZNaRQ1+9PFbLyim6VH0iMg2KpTc+W3I9n056E0rsO8zHqB6cC8
	 6S58sxB2QCY43XWWegkZYnn1H3W+2Ptu4x/gPZk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedaya Katsman <yedaya.ka@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0258/1815] arm64: dts: qcom: sm6125-xiaomi-laurel-sprout: Fixup panel compatible
Date: Sat, 12 Sep 2026 08:33:28 +0200
Message-ID: <20260912065655.035861973@linuxfoundation.org>
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

From: Yedaya Katsman <yedaya.ka@gmail.com>

[ Upstream commit f135fd1bc76d052f1bf4b1cc987cd47fe0a71d8a ]

The change to the panel compatible was missed, fix it. This compatible is
already in the driver.

Fixes: 493cb869874c ("arm64: dts: qcom: sm6125-xiaomi-laurel-sprout: Enable MDSS and add panel")
Signed-off-by: Yedaya Katsman <yedaya.ka@gmail.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260608-b4-compatible-s6e8fc0-fixup-v2-1-d23f373603a3@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts
index b9d9439e230b4..139f2b401af50 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts
@@ -198,7 +198,7 @@ &mdss_dsi0 {
 	status = "okay";
 
 	panel@0 {
-		compatible = "samsung,s6e8fco-m1906f9";
+		compatible = "samsung,s6e8fc0-m1906f9";
 		reg = <0>;
 
 		reset-gpios = <&tlmm 90 GPIO_ACTIVE_LOW>;
-- 
2.53.0



