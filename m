Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731582D839C;
	Tue, 21 Jul 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649687; cv=none; b=G1oOtMas9//nWoYnGJocOw0D68pKpBNqxwbOWRp9kd0uaViqmq0RULu6KdPRgZHxSL/rdrdP6hvXfu8jx3YgroVJqVRG9YqMh9vcWYtxyVj3f8fVZYQGxPwTaWmdVm/VuZUASS8m+Mfn2bg2HF3K67pwRsCa/3aUM1u6QUWpOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649687; c=relaxed/simple;
	bh=1UxSU2GOc17XlJ7m0dfK2GJIuc/9krkw1gHrDB2CFBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtfjH/eNZiZ/0lVSMhRHxLIQ+n1dPB2BRmiCHX4qZFe2UyJNGlMhFuL3eFGDPoHg8rPbH7gdEWbHPkvH4zy9HV5ilgDSDcH1zI637/6Sqr9cyMfAG+nx0qR5nqhcFDzJAF1eN2hB6mbQwjec5WGgyxK09jM4GGto7I5Z/P6GMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOVCCgg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOVCCgg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EB41F000E9;
	Tue, 21 Jul 2026 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649686;
	bh=MCNod6hH51txa7YM4mHCjNIY1+9zNpWZlQ79zOrVrmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOVCCgg8GnKOVYE/kEyu7kZl8z6SZ3DqTlxNvLlGN08W2U9ZOwXC7pBUG+hZiMxpA
	 IBMCb6+FAhBwstva2parmWLlEQk3r9iHrjy4hjbIEn7YteByqc1uDps5kX29vDTmD8
	 OS3Tov+rZKmfhBtrtGuokDj9gYCeqss8nekmCnwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0670/2077] pinctrl: airoha: an7583: fix gpio21 pin group
Date: Tue, 21 Jul 2026 17:05:43 +0200
Message-ID: <20260721152608.605705146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit abf92c45cc82e9a01aa581f9fbc790e78250a4d4 ]

gpio21 pin group refers to gpio22 pin, this is wrong.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 15a54172434945..9dce3ed6de174e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -748,7 +748,7 @@ static const int an7583_gpio17_pins[] = { 19 };
 static const int an7583_gpio18_pins[] = { 20 };
 static const int an7583_gpio19_pins[] = { 21 };
 static const int an7583_gpio20_pins[] = { 22 };
-static const int an7583_gpio21_pins[] = { 24 };
+static const int an7583_gpio21_pins[] = { 23 };
 static const int an7583_gpio23_pins[] = { 25 };
 static const int an7583_gpio24_pins[] = { 26 };
 static const int an7583_gpio25_pins[] = { 27 };
-- 
2.53.0



