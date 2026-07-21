Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFA935C68A;
	Tue, 21 Jul 2026 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669040; cv=none; b=eNMDh+/F+lA9ISyyq9MNj3CvR0DLG4bToZ/+QTbFZjQ4yB1ZudCFUiSRQc6TMr8n2DmYULcnbVgEsaQrw2dhK8S1MQVurZnH24TaNeyByO5MDXkQesyukPlOe6GGmO3Y4BqZdowLa2nRpDLRf1SJ93E6OTbIhtS8qJfWQsy++0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669040; c=relaxed/simple;
	bh=qqztC59JnCp8XFS3wfOS4GFGq94tOwx4DuHdXka7EEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u14I4ThS8p7hnLo8PrKLRDhmXM/hnkjaP93lD40OewFowweOzXTo8TPvpPyLgC1/+atb2M2ynEjErShQISeYaeGAtQ6HPor3kLFRCMhL5HiiBNsLUm+DiZRFGnW/4BJfF4CD59dZkcydNvePqZBvPHwtlRlzMUDaga55kS/Fsbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8p9OT6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8p9OT6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A661F000E9;
	Tue, 21 Jul 2026 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669039;
	bh=O0pI/Q2vnpCGOvNHo29zudco6FhqCtA89OUESxEMGVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8p9OT6IF2uOL94dsWET0S9BVolfoBCjDdCZHubdtrGeLeQz/Eae1e+wa4oJiZBsZ
	 Wette/z+zNFKUM0Qe/Gj7OOnvKxB21j3SSFJ472QXIAe9WBoCLEMc1egcS1bL9cb9d
	 XMhA22ngy1k7PV5XzF/VMs0VPMwkWyjbX7JKtu7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0404/1067] pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152433.670533141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 1c3044cab23a056ea28da47da1cdd667a39df0b8 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 264667112ef0 ("pinctrl: mediatek: Add MT8516 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8516.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8516.c b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
index e929339dd2cb3d..46686b61002dae 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8516.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
@@ -245,7 +245,7 @@ static const struct mtk_pin_ies_smt_set mt8516_smt_set[] = {
 	MTK_PIN_IES_SMT_SPEC(24, 25, 0xA00, 12),
 	MTK_PIN_IES_SMT_SPEC(26, 30, 0xA00, 0),
 	MTK_PIN_IES_SMT_SPEC(31, 33, 0xA00, 1),
-	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA900, 2),
+	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA00, 2),
 	MTK_PIN_IES_SMT_SPEC(40, 40, 0xA10, 11),
 	MTK_PIN_IES_SMT_SPEC(41, 43, 0xA00, 10),
 	MTK_PIN_IES_SMT_SPEC(44, 47, 0xA00, 11),
-- 
2.53.0



