Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9574A3AC0D2;
	Mon, 23 Mar 2026 13:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273899; cv=none; b=Gd/sErNh6oCBn1cpJ9nHq7PFQqDpiFUCJzRY+9wz2uJdQ2xwOut9cn9J31qyrX8CE6AnQtCh9NoYocP3AELDA8QRHWIdSAMFW1jKp5DBnCb9DDR1DcV2J/mlVpJUvtXfpoRATxWLhtScpYq6tRMTqAiXpZg+pON1G0l4LX7CQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273899; c=relaxed/simple;
	bh=1brawcWDg0A1Jz7IgCRBXlNtyRtASP5PFzCm4e7oGJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5VAAqDBMfqbdo2l4pvbB8r6MHQF9bGv0I94hz9FJIA4NB/mV8eNQEdjIdh6yGcqb2XkFT2TeQGsMddNBHOeGu6XMaIjqNl8SfCXI87bTaGfddbzawRe3jXBUJgFgSN++iVm8SimOFTalwjFJN9TxixN7r1eN1hOZkzY1BQUnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4JIID1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4JIID1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004EBC4CEF7;
	Mon, 23 Mar 2026 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273899;
	bh=1brawcWDg0A1Jz7IgCRBXlNtyRtASP5PFzCm4e7oGJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4JIID1+cXR2aQD9Btxg+6M4TQnRnaNkPOzST+KF3QbrB+x8t4juZ8yQadch3PIjm
	 jnuYD5Uz+tySMfuQnzd2Ce5q2J3tqhp+oIbwA/Cgts84yLPqtauoXYNCBr0j8EkPFI
	 wIiLU4NBNqkm1TKXTr+U1FlWcpYkKfL3qGCg0b1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 045/220] pmdomain: mediatek: Fix power domain count
Date: Mon, 23 Mar 2026 14:43:42 +0100
Message-ID: <20260323134506.011228379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

commit b22c526569e6af84008b674e66378e771bfbdd94 upstream.

The wrong value of the number of domains is wrong which leads to
failures when trying to enumerate nested power domains.

 PM: genpd_xlate_onecell: invalid domain index 0
 PM: genpd_xlate_onecell: invalid domain index 1
 PM: genpd_xlate_onecell: invalid domain index 3
 PM: genpd_xlate_onecell: invalid domain index 4
 PM: genpd_xlate_onecell: invalid domain index 5
 PM: genpd_xlate_onecell: invalid domain index 13
 PM: genpd_xlate_onecell: invalid domain index 14

Attempts to use these power domains fail, so fix this by
using the correct value of calculated power domains.

Signed-off-by: Adam Ford <aford173@gmail.com>
Fixes: 88914db077b6 ("pmdomain: mediatek: Add support for Hardware Voter power domains")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/mediatek/mtk-pm-domains.c b/drivers/pmdomain/mediatek/mtk-pm-domains.c
index f64f24d520dd..e2800aa1bc59 100644
--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -1203,7 +1203,7 @@ static int scpsys_probe(struct platform_device *pdev)
 	scpsys->soc_data = soc;
 
 	scpsys->pd_data.domains = scpsys->domains;
-	scpsys->pd_data.num_domains = soc->num_domains;
+	scpsys->pd_data.num_domains = num_domains;
 
 	parent = dev->parent;
 	if (!parent) {
-- 
2.53.0



