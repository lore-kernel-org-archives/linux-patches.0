Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942865172E3;
	Wed, 30 Sep 2026 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784846; cv=none; b=LqkgbozDOLdM2UMAHcedyWwNVz+h/zLbUdlnWYXBKOmQlYxK6cpUM4J/CWjC1kSihGxvnHR8Ho1BEHAgwCyJiG0mkoa9HQ4b7q9VKJEojEnqmsCFAPPT8YlNa9JBYh+6cTh/vX7fyxCE6BwloZ0aekX4WWaS+TXJmMZPTHF3fLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784846; c=relaxed/simple;
	bh=Yp+FseEHpvvQmgCSK0O0JikXj5531af8YYLeHumGglQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUvBy0mthiA/OTcjUDoWnpCDMTqaTRhf3axAOGAIc1uCyeUB+s87+Sav+8muqTX0TBBZ71JEnIceFkQxpCs3dA0xoDiBMSB5hEo7QSQI8I131T8wqDues3qPSGfBw4u1mwEX2uNWbbc92Tk1JLm1xY6ySBaahvWUQ8m05B7N9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPaAt2RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPaAt2RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB16B1F000FF;
	Wed, 30 Sep 2026 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784844;
	bh=C5o6oS9RWFeFo8dMENUP7miIdILEEGKS3YyiVpwUJtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPaAt2RXk4HOYx9m8kY4HFzuzDFkjVJ2SSj/neXMp1/1CjT56z01aK451Qnah5AmV
	 x0E27ycc2eJS35KJ4a916C41Tdb1FXFDEPq0Dx5cMn4lI0lsEs4Df6gCzc7V9lnkyr
	 8c6s7eDxcQCRnfBE+QrxS+pOPmyxkk65p1kvHxqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/982] clk: at91: pmc: #undef field_{get,prep}() before definition
Date: Wed, 30 Sep 2026 17:17:13 +0200
Message-ID: <20260930152423.185484262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dbfe51513aae6bace00cc390e11cb486a64a63d2 ]

Prepare for the advent of globally available common field_get() and
field_prep() macros by undefining the symbols before defining local
variants.  This prevents redefinition warnings from the C preprocessor
when introducing the common macros later.

Suggested-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index efe4975bddc3b..7509fd83b7bac 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -114,7 +114,9 @@ struct at91_clk_pms {
 	unsigned int parent;
 };
 
+#undef field_get
 #define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#undef field_prep
 #define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
 
 #define ndck(a, s) (a[s - 1].id + 1)
-- 
2.53.0



