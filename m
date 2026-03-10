Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7993803CD;
	Tue, 10 Mar 2026 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142121; cv=none; b=andKApszneij+qvDsBBVm4U2ZTW4zzGI50wJGqAxh5rzF9QR/ILJGXpH/kAE0zZHxLkX3aWWIThQYyPsyN7z69PgBvEyQykQsj9u/wITkOUWQ+GnB7p44DNhL8K3B5B0sWKPRSuxcCv3af1zOndNPyqHoYUEOewHBp+PCbWmC4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142121; c=relaxed/simple;
	bh=kGfe69y9XNALAN3qt3ZmPh3zKRto5YLgrxCRNuw4RAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gyc/oPg23l0P114i/YgepkwSVFbBdr6X84wr9VyoKQQf5yabdv+lxSO1JKKouUT/1YFUbtCsBmWP1NbmjwgoVKTOwgfGl0YrHYEgN1CgKLyFnLjAtq8vYkYstkOfom1oEzZ0wzxyt7cW2e3MLLhkS3sNyne+UcenySDBadVpgOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHZcqHkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHZcqHkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0D9C2BCB0;
	Tue, 10 Mar 2026 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142121;
	bh=kGfe69y9XNALAN3qt3ZmPh3zKRto5YLgrxCRNuw4RAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHZcqHkZBv0Vt91Fx5xQt0f+mB71jRXk8wbpaYKi5kTZoKBwH4QmniKjd3ifczL08
	 jbBUHVK2FN1Mtbjn47yguMAbtHAypmmVcNWRJ2x5dzinTNgWU+/wK0B5bKI+Sbf2eP
	 B0dmf4u4lfDU9x/Jzgg++JkzfdNRrEOdpymEeenIz2GldXFcpPllYR6d8DlToE9OsJ
	 xECqp6cX/JTnTbQRBqlZ9mpfXJDpIhZOGVOlIqXwCihlOFzQcvRh5YC0aAcOMiDsKs
	 mwqz9pi0BSG6MjuOJtENNjSTurQ0W/9mdGQi+BuBDOYI0GU39CTlCKiB9D6QneSPo0
	 oWHySrvcE12LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/314] pinctrl: qcom: qcs615: Add missing dual edge GPIO IRQ errata flag
Date: Tue, 10 Mar 2026 07:17:49 -0400
Message-ID: <c742c2dbabd3aebff1e64e2064015108da5a91e4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 09a30b7a035f9f4ac918c8a9af89d70e43462152 ]

Wakeup capable GPIOs uses PDC as parent IRQ chip and PDC on qcs615 do not
support dual edge IRQs. Add missing wakeirq_dual_edge_errata configuration
to enable workaround for dual edge GPIO IRQs.

Fixes: b698f36a9d40 ("pinctrl: qcom: add the tlmm driver for QCS615 platform")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs615.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs615.c b/drivers/pinctrl/qcom/pinctrl-qcs615.c
index 4dfa820d4e77c..f1c827ddbfbfa 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs615.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs615.c
@@ -1067,6 +1067,7 @@ static const struct msm_pinctrl_soc_data qcs615_tlmm = {
 	.ntiles = ARRAY_SIZE(qcs615_tiles),
 	.wakeirq_map = qcs615_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(qcs615_pdc_map),
+	.wakeirq_dual_edge_errata = true,
 };
 
 static const struct of_device_id qcs615_tlmm_of_match[] = {
-- 
2.51.0

