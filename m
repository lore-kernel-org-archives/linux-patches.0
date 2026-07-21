Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036213E49FD;
	Tue, 21 Jul 2026 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671634; cv=none; b=qDKPe+Kb3lgOxTLtKQyIGdbpfn1yZv+todlgDZwMrtM8w3hoSvrZhxlBHMLIJN6eYDym3eYUMuqn0+xflbVLZJAyugmCmq12ooCh6lcO1bmI3aPgR0CnhBZpxABD3wwzbB3yca2sQ5RCNbYdw4P4Zhz/t/LiFOLCVhyBhupXBpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671634; c=relaxed/simple;
	bh=QprOaWTWHKjEiTraAm+YwX1Uww2DBe5FlQOMxy2IWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD4v0AIkW9QfCcS8AV1ZnH1gBZoaM7znhI9+2y1+GuSUJZKFCQzf3dhgV09GIgOGp82RIK3+nz7sScBO8rYRAokJs0jvzSO6D8nhWXR07VqZXtzg6sCIYAPAUNfn5rMC73a5FyQhrwQMFzyDYcWrIETUXJhkpDm3ucoT3bc7Dfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n42R+jQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n42R+jQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6504C1F00A3A;
	Tue, 21 Jul 2026 22:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671632;
	bh=1cUng3fzFgbh+LiJQ1z/u4nakU1OQM2qPiu89uKf69Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n42R+jQ/VPhfze7MjgQGNeh6cmOs+0Le0tAgaDDF9sX/uFUXJ2uMHU4KSyc3h2kcb
	 Vz3jf9I58iBDg6woXKlqeK5Xwss179LdTtDiKR5g3EORiSKsMk5OnZp25ZGAgFKSWh
	 lPSFS38MHTOsCljiYWqHEa+n/xM7ApmLq4mdqx8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/843] pinctrl: mediatek: mt8167: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:19:16 +0200
Message-ID: <20260721152413.241354755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 439bc91d20188901dac698bed4921caac76d9074 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00. Value
was verified with SoC data sheet.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 82d70627e94a ("pinctrl: mediatek: Add MT8167 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8167.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8167.c b/drivers/pinctrl/mediatek/pinctrl-mt8167.c
index ba12ef795e5292..41c07c658bdef4 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8167.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8167.c
@@ -252,7 +252,7 @@ static const struct mtk_pin_ies_smt_set mt8167_smt_set[] = {
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



