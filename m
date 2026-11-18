Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018620;
	b=Unn6/uNYTo7bDL07TeVnj7jhJA76TbcdsqG00YEgU50Lp0nORTXJ4VaSbPnf4Xb8Ze8i
	 Zn15q9Yy5IEW4RrToeSX3TZ8fg8g7RWtG3SY4oV+jk76giYjUrkjLCJtT4Z/+MflZUNjj
	 6t0khXHbqRM9g+qAhPwCRp6R/g9MRfe72fI8fKrVXrOlvgF4IxBy+0KT10z8psoNoFdfs
	 S1uBrJVihZgAEPSNbrUom1R07bf/mdsmadnmtIywgUB59Muk2K0ke11kbGjSGeI3ms7bn
	 1LJDFvsjBkwGHG2rri+f757ZNbHZaA7Zrt0ATEgJyzdDWtKkhwir/IsTpNHuytnYdmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RhKMaS0+zOy75ArRR2vRtymLwsZrQ8vE4mROodAwUzQ=;
	b=IP1B9ldzEKXIEpDFRzJ8k4wToEWHx4+8AU2ivty+MRteRe8bki/sHTOLcZtavyFC55SU
	 QsXbPi0gLiHa2+rugF7rnLMu6r5xCOr1YWkeeFXvYD8y3s8OK6w58Prdx+DXEXMoVIvOY
	 whosglxzEXaUosyLDHaFt4juTGnuyImj4vmA4F7Dfyxg+XQ9gO7oy2EazJ4xvnP1aGJIr
	 ufIBPIbHBqgeMCkHgmU6+rmYDySzkO4mYOrrHrC5NMqC0A1lPFNoyM+dUAzEyjH9dpBkL
	 hFYhMpvUkA7i7geE0IYnLqhVgf4zEeuSgDwsef7RonaA2m8uesx2oKBV3MdgpYAGyMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4O1G1pd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBC8606A335;
	Wed, 18 Nov 2026 16:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4O1G1pd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C21F000D2;
	Wed, 18 Nov 2026 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018619;
	bh=RhKMaS0+zOy75ArRR2vRtymLwsZrQ8vE4mROodAwUzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4O1G1pdCJme2A2LYJIDglAVh3EWx15A3SJbOXrQKYoNaYRqeqiTrsrT+3/E5NiMN
	 21rSkKokywvrmtWjaboTrabvI42QhB2pOeouZowQc3VVfTGJG/J8Ua/W5f9iqlogBq
	 7f9v7XtqeJeDFUGFV39MKjqFpRZPwjHASCaWrACc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1303/2651] firmware: qcom_scm: align PAS resource table retry
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150334.876561884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 57e43df2e426ac5561ee3832d425e1071772e963 ]

The initial PAS resource-table buffer can be too small. TrustZone
returns the required size and the wrapper retries the SCM call.
Although qcom_tzmem_alloc() aligns the allocated buffer,
the size passed to TrustZone remained unaligned.

Align the retry size to a page boundary so that both the buffer
and its advertised size satisfy the PAS/TrustZone contract.

Fixes: 8b9d2050cfa0 ("firmware: qcom_scm: Add qcom_scm_pas_get_rsc_table() to get resource table")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921195636.1925869-3-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 5fbd828f887fb..db23e88155e8b 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -854,12 +854,14 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 	output_rt_tzm = __qcom_scm_pas_get_rsc_table(dev, ctx->pas_id,
 						     input_rt_tzm,
 						     input_rt_size, &size);
-	if (PTR_ERR(output_rt_tzm) == -EOVERFLOW)
-		/* Try again with the size requested by the TZ */
+	if (PTR_ERR(output_rt_tzm) == -EOVERFLOW) {
+		/* Try again with a page-aligned size requested by the TZ. */
+		size = PAGE_ALIGN(size);
 		output_rt_tzm = __qcom_scm_pas_get_rsc_table(dev, ctx->pas_id,
 							     input_rt_tzm,
 							     input_rt_size,
 							     &size);
+	}
 	if (IS_ERR(output_rt_tzm)) {
 		ret = PTR_ERR(output_rt_tzm);
 		goto free_input_rt;
-- 
2.53.0



