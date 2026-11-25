Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622838;
	b=dzrHEtLqMjFiDBMmW+v/TfVRNH2gxbUSaxtRsCeJczxZNZy3/xhCGwHd6azY26cqCG8b
	 2179HIJ/V57anTdF8DPAhMv9e/j+SVNxyI3sDzbiFrdIuEbXTfOWxcfYYcDDc5mV+24gO
	 sqsSe+qO9wj+y8hsI/gzvOCbPWG3XxQLpTvgUIH0vvRl7JPuRVh6glIXAiVRN4UC+q1iV
	 JfMIPY89AFwuEBPbT+tcxYa19BHPOweCHiA40/oh5pipX0IhcqLx81cNGtjGJinZjSf6s
	 OjgEK+9vChS1kOtqSb3IqIxKvicjLMM6hRuercmP2wI9DB52okLxeaUMkRzzOG76OGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QA32p2NaByUFGQWXxz5C6ODINKOZpt/CooFP4naTdLA=;
	b=wOpLESosyUsBqjkuUR/8W8rcTTPD+n//d8o4qL3L/aSTXAbKxommzrOFseQm7kmmVA4u
	 5Hf0x6U7pd4zKzoISXQDm3zgrRrZFWJN2FXjaoa1ZoS8EhSiGeJhjiQqU5aR+q9nyisGt
	 pIW7ha1lkFTJCl+afxoYSPfPplrj+iGXPNatWGv1FBoj69CgBRqH7H3vQhMPWBBXSP5NQ
	 wIC++KrF5Fr1oPUBS9QQxCRCCNUdtf6DIkmD+70jRs2w8zqJjuTRLMLX0o6kxQmrkzRw3
	 geHQk78S60+wLQXAt2zJKuAPNCyyyBCYtUGLo1F60SGH8lHs7KgLy+C5xZUiIfPEVRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JB6cRSCR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D96606A32C;
	Wed, 25 Nov 2026 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JB6cRSCR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66FC1F000D3;
	Wed, 25 Nov 2026 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622837;
	bh=QA32p2NaByUFGQWXxz5C6ODINKOZpt/CooFP4naTdLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JB6cRSCRNttshtvin0NlVR72ziKLXTlV5zwPlLuqma+atDXBEbqAsfO39ZCByXYhn
	 f2MvU41iEFL6avbyKyP+3ovdZ86NwMQugLk7oWfpErnpzEhOzFHWI2ZLN8AsHl4WLO
	 bPI5YYfZSPeMm5Aly5/94WSK8tFdN5MQJ9CXF7aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 665/990] mmc: meson-gx: report busy from DAT0 alone
Date: Wed, 25 Nov 2026 15:33:52 +0100
Message-ID: <20261125143837.666577607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 318fdb75f4dc9d18ae621b9fb25eb11160c95649 upstream.

meson_mmc_card_busy() reports busy only while DAT0..3 are all low. A
busy card drives DAT0 low and leaves DAT1..3 to the pull-ups, and the
callback is defined as "Check if the card is pulling dat[0] low". So a
busy card is reported free, and the core, which prefers card_busy over
CMD13 in mmc_busy_cb(), stops polling after CMD6 and erase at once. The
controller hides this on R1b commands, where it waits for busy itself.
Once max_busy_timeout is reported, the core sends the longer waits, the
120 s BKOPS and 240 s sanitize switches among them, as R1 and has only
the polling left.

Look at DAT0 only, as sdhci_card_busy() does. The checks around the
voltage switch in mmc_set_uhs_voltage() still hold: the card drives
DAT0..3 low together after CMD11 and keeps them low together on
failure.

Fixes: 186cd8b7f586 ("mmc: meson-gx: implement card_busy callback")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1079,8 +1079,8 @@ static int meson_mmc_card_busy(struct mm
 
 	regval = readl(host->regs + SD_EMMC_STATUS);
 
-	/* We are only interrested in lines 0 to 3, so mask the other ones */
-	return !(FIELD_GET(STATUS_DATI, regval) & 0xf);
+	/* The card signals busy on DAT0 alone. */
+	return !(FIELD_GET(STATUS_DATI, regval) & BIT(0));
 }
 
 static int meson_mmc_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)


