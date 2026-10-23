Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774467;
	b=ehFdOkpA5aGZSKp/mtaXOEMnXlv2H2LKQEJit/YV4L7bBZR3OO+k/bAwp2ftPpQBbSHt
	 EWJSV26bv+duWb9q/qohWgBRxwfuJExxZS4bqA/7OnSgNFO7MZDct+63sezQm/C8Fn88Z
	 UHOGUy/T5UEhf4duZ4TmhSNeOe4CEFF8l8MjR20VfAkE7cQ8L9Vgu5hwWqoFVY9Tpf8dI
	 PJUh8lfQt59MbwW/YkQMF5CK5Hd5cwDnQSm6KyeppeJIuk2+UpyNgwZ2KO8Y0md/QzJNk
	 IGfWV50KMzcrXc6b4/NR/qZklQzzW3+F+v1fUcJENPGITc/zZa+3/fsgfSDOPuRm1YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJPM5/9Efk8n2xrI7TtQ9Wesrt8S8hSL+OfefIreFio=;
	b=NV6a6We30cBqIKtjsHJ2kFUiHaXbymntWevnKYvz1J1X5z8Nzt8loxIqbYfJYKDPEcB4
	 LL2fdaH5sWgO78s5a5YXBT8VMz+CHywVdCbUs1rRCPIHB6HDAVyIWtQhtZQySpN17tGWR
	 AoHAZ7dvQMO1UTd3RmUYB+Sbhi+3Q38+cQ5jBPyA3Nr82kpJe44rYdYi+gu9zneZcH+q2
	 Bih6wQv+44VOsDOnNz8qzsTFA61O9yh0H/aTN15TbHJUaMg2d7ozKjZojw3EYSDjnH+D/
	 N1XUJErFJJQTeZ8mIuUI7zsFiwmMIIgv12r2Z/Si/D4AkHsrIbG8eHK2fnwmBNvA8Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3E2t9uA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2159F606A31D;
	Fri, 23 Oct 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3E2t9uA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716E51F031E2;
	Fri, 23 Oct 2026 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774467;
	bh=vJPM5/9Efk8n2xrI7TtQ9Wesrt8S8hSL+OfefIreFio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3E2t9uApXBRkid8UT21pjebG/BVP7JhoBvC3pvs0kkl2W539hhDcX8S2ZGHH06RR
	 bByDaJO9x6NonkfhGGbXLWKazmOrl3tkWG1J/DjhLNaCmwDdZjF2A1PLUUnSXRB7DM
	 o4B0Nsla3xp9CYNsUmPg8I3g2bc2zKmOJNuYcWKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 012/242] pinctrl: qcom: hawi: Fix intr_target_width
Date: Fri, 23 Oct 2026 18:37:34 +0200
Message-ID: <20261023163714.085234265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 9d4c3e0c6a53eb390d58b8d7aaf08885e46f93fd ]

The default width of the interrupt target field doesn't match the actual
register layout. Fix it.

Fixes: 90700e10d2ad ("pinctrl: qcom: Add Hawi pinctrl driver")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-tlmm_intr_width_fixes-v1-1-3bc1d056aa6b@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-hawi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-hawi.c b/drivers/pinctrl/qcom/pinctrl-hawi.c
index cdde69e954a76..3486a6d63d10e 100644
--- a/drivers/pinctrl/qcom/pinctrl-hawi.c
+++ b/drivers/pinctrl/qcom/pinctrl-hawi.c
@@ -47,6 +47,7 @@
 		.intr_wakeup_present_bit = 6,	\
 		.intr_wakeup_enable_bit = 7,	\
 		.intr_target_bit = 8,			\
+		.intr_target_width = 4,		\
 		.intr_target_kpss_val = 3,		\
 		.intr_raw_status_bit = 4,		\
 		.intr_polarity_bit = 1,			\
-- 
2.53.0



