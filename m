Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73D6BB5B;
	Tue, 12 Aug 2025 18:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023423; cv=none; b=CnHpjUpboPvupq5XXONcq3PPoQJ+/789XwiST0ih/DKAA94ounYLQvKqh2XU+ag4l+8nNJR59Y9VtwyFJyl9CouIwjnWatX4TLi5+ES710mqtTpS6jtIazUddFLvoq8VoYIV9mU4AFnS5nMfKfyaFPspJ/lqLWEYFnGo/V8KfP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023423; c=relaxed/simple;
	bh=uJ/WCcCV56kabmSdPNJpGP3RM91O3aphHulCz8sr3aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auN7liB8XHKtzxBUMZ3WVR3EfRQ89FLwrSvKbj8ADvH0G7M8vuC7PNrkwmOc13EL4SkdScRGP6gTDn1pxeNUNW0cc5Jf8+dJMUSY2umKLmJhpqcz+7pEJcOH52EMDb0SLL1+yUZY3IESKVh/iO7+hhHB7l/MWM98j0BRNYqnNfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKmDk/eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKmDk/eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E25CC4CEF0;
	Tue, 12 Aug 2025 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023423;
	bh=uJ/WCcCV56kabmSdPNJpGP3RM91O3aphHulCz8sr3aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKmDk/euyIASbe/A+QqaXfZrC1cv1bt48hBeqa4TzJ6qr9kmODIvDsaxJW9tG5idg
	 1cx49PGL2Qg/EvSzgbzN+vkGDpiXxanY3kuI8a/0rmMOcB9aAmql9kUCz4OQnbl3FS
	 ZpYeyL35EBJ9mgbjagu7OsolIPf1ZU1j/fU4QIOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 076/627] power: sequencing: qcom-wcn: fix bluetooth-wifi copypasta for WCN6855
Date: Tue, 12 Aug 2025 19:26:11 +0200
Message-ID: <20250812173422.204359694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

[ Upstream commit 07d59dec6795428983a840de85aa02febaf7e01b ]

Prevent a name conflict (which is surprisingly not caught by the
framework).

Fixes: bd4c8bafcf50 ("power: sequencing: qcom-wcn: improve support for wcn6855")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250625-topic-wcn6855_pwrseq-v1-1-cfb96d599ff8@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index e8f5030f2639..7d8d6b340749 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -155,7 +155,7 @@ static const struct pwrseq_unit_data pwrseq_qcom_wcn_bt_unit_data = {
 };
 
 static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_bt_unit_data = {
-	.name = "wlan-enable",
+	.name = "bluetooth-enable",
 	.deps = pwrseq_qcom_wcn6855_unit_deps,
 	.enable = pwrseq_qcom_wcn_bt_enable,
 	.disable = pwrseq_qcom_wcn_bt_disable,
-- 
2.39.5



