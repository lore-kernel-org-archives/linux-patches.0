Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626349;
	b=RISj7TxBaXI2JNCxKMAoZ/SrLI++hNn+llW2o+m1QMZNJqnaSYhEHrta4dvKLiEmK+pB
	 2jJGBZaBynHsUWBsPR7hnGizW5DCkCu3FkWLI2Qzmaj1nk0h+Egao4K5+q1oo61BP5W7x
	 hQKl0nSz4/lKY86uXrt4NWD3yGscNm7ciIuP8ScR+UNqMHCn8HqGTYAmSE8s26lPvZ5yu
	 0zRP4540MeGDB6XZbCWP0nuqV5s2fXN6UMB1Ugq+32aME/7USrupqYQV8rUM8WbbCn58M
	 ge22Q7cJhQkWNxB99ndkd6wFlFehsEoucrpAEpoKo0ZyAQYdCtDsPETe2hUG+eLUUfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rhr5sAp1LrHR0FcUDA7fFxw13JLuxoYAMsCUoph6CCc=;
	b=z0DW84t/qtpJqAnLIVgs/z27qfj3oiODTtaN0n6uCLtLB4zybavMW9zK52W8hBSNfpVU
	 54qV4bjkqOd8q8E42RBTYhR+XSLKcfrvHWQBsS+6j5QbaiOUWDn4HnYB5P8cmaOxSLbF/
	 leM1kbyxkzyFzsKAcWEbSvqV7HjCKxJHLBt3JayJzjpZiTAEX2zV1TLKhmoXsLeQLMRVq
	 96GCXx87A+q38bu6C5cw66QkGkvA3JJT9DAPHJD7x2sVwl2P7NrYIrtE3+4dY84QASx5M
	 HOj99biOQHvsWDOj/VwORWoK7aIKkp5ysYF3Df5IyQiK2rRFIeCmJaVGsxNwvnPGHkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXNMYJQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC222606A323;
	Wed, 25 Nov 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXNMYJQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE61F000C6;
	Wed, 25 Nov 2026 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626349;
	bh=Rhr5sAp1LrHR0FcUDA7fFxw13JLuxoYAMsCUoph6CCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXNMYJQVkWgfR4Eorgu628jO55irNDY0lOxKC1snsYbFlrtLJI3LP4OlxS6lxgz6q
	 yAp3KXlWAXmGK2RZepnzELTEgTozzRkfUGQHQSiCa1wxnpF6hQHEw1jlFycccM4Tz0
	 /9LPrGybzrgIp/lKT3iRwcHo4Qm8iPnHu3zP2dQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 815/816] power: sequencing: qcom-wcn: fix bluetooth-wifi copypasta for WCN6855
Date: Wed, 25 Nov 2026 15:39:23 +0100
Message-ID: <20261125143908.035447937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit 07d59dec6795428983a840de85aa02febaf7e01b upstream.

Prevent a name conflict (which is surprisingly not caught by the
framework).

Fixes: bd4c8bafcf50 ("power: sequencing: qcom-wcn: improve support for wcn6855")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250625-topic-wcn6855_pwrseq-v1-1-cfb96d599ff8@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -155,7 +155,7 @@ static const struct pwrseq_unit_data pwr
 };
 
 static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_bt_unit_data = {
-	.name = "wlan-enable",
+	.name = "bluetooth-enable",
 	.deps = pwrseq_qcom_wcn6855_unit_deps,
 	.enable = pwrseq_qcom_wcn_bt_enable,
 	.disable = pwrseq_qcom_wcn_bt_disable,


