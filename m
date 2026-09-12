Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288554746AD;
	Sat, 12 Sep 2026 11:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212679; cv=none; b=EJKA0OrVaiq1oR3nvDNFKUShIbo/bwcIAQGdIfnbfUFpPl7+TbAWB38cUz7zVgC4K8J4Q4Qek3gDpoUjDiARFOzy/aNxRXU9cY43CvirbMFqtnKcxPJPEdwOu7BfgrTEYta4nxN6CqKXQSIR68UsTihfQvEC1Tvcgw4X/FxhwNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212679; c=relaxed/simple;
	bh=qLP5q00BDYgElJJS+VXmnCbr+7rLywnp1oH8OruJ+/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C44tdzyV9wKaaGsUNgSsuNHJM2Du1OXHamtgum9KCWRAJDPnmSYIDjnyWluZOLwzqtbtdbN1NnrAHfTEklDL+QXWfLAre1M8UXpm8Wv5qeLpsgG2jRdmpduDnx8YQtY48qJmUnpHyKs8qpdAnk1PMjE3pOXUyZdP+iivPGThjmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzRY8f3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzRY8f3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECEC1F000FF;
	Sat, 12 Sep 2026 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212677;
	bh=YuroJLBDkrJUm9E0S9F3ygRJICgO10wle3jiHSjJ9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzRY8f3toPrDM4NZzITC36dagNyEjuk9BpYtfwES9woi6zdZrNuSn74ulYcRC1iY7
	 hNHjEIy20TmvnoLzTRMZF5mP/gLt7BFJtLcR7g18JgStPDXXl+cCvZU8CzaA9EjQvZ
	 u0NC4pR2EKDFDHML4lgyPMNkDSA5tfEW2s8cGMro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1486/1518] pinctrl: airoha: an7583: fix gpio21 pin group
Date: Sat, 12 Sep 2026 09:00:55 +0200
Message-ID: <20260912065657.178537154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0f4626f582074..7bdebb4f7254a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -767,7 +767,7 @@ static const int an7583_gpio17_pins[] = { 19 };
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



