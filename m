Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704637;
	b=PoCcF4ibbLOrLNm3qsDpkapciRqvBeBIhp9Txl3K0L9sHfRCd4GCPspVfTQSaGH8pOa9
	 XDPOLS1ZjRizQa69kYx9/EKSjb0qvGc2iWQvYqqnoQScmPSzmGj1ieIU63xdh28aWtqIb
	 /F/eD138BCusjweYg327QRh8x10MC+luUdMz3BUWHdjnRBkS+thcgGJu4yQM5qXsTsM5x
	 qi84SqYjd1EyTg6dIHlSMa+vIt+P+dap4BikdC06VZ6z9ovUc4VGbdwVCFNZMHAwP1/YR
	 cha8s8UIb3mGBH0xcw+Cl1Xgkdbx4wBRTCY+RBmbv17Lx2ElJ2cNK8mLwdki3TnBjOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbok1n179ZSLNR8ISjMpU4jhhxeN56E6RLEztZ+3+ZE=;
	b=O2dHgrNvV2L/XtpPNNCJsM8JCKu9nGBbU1/MqP1NvxlcLCaOKulCCty4O6EwtfVjudiU
	 ROcloFicxm96fmbPTQBZKOJGa8RUNJpFV35ut0jZvT2KeRcerq/cTmKw9MaCc9YChnmdb
	 ZLQx52VqfbO/bI3djv92kp6oHsLwVt6PRR14g7DBDWhKVsgEBx1kLXMQC0aU1JeqHzfT6
	 rteRTOKZf4bjrIS5qQoTcNTi1hElh6Vfc6Y5cYX6yH+3/JCoyY+wplztowcIbofkbxbzz
	 0sTvFvAZAR6uYUxjcsTSIMxkB1p0UWaRuimtrvmcZuG85vKP4xZ7iCet6yjquHENv9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IULc81TM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB449606A329;
	Thu, 26 Nov 2026 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IULc81TM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E737E1F000C0;
	Thu, 26 Nov 2026 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704637;
	bh=wbok1n179ZSLNR8ISjMpU4jhhxeN56E6RLEztZ+3+ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IULc81TMZmobkrxN7SErJ1ZHtZd9/ipFO0U9mfm6cui+Os7ak/sHMZURUUb/Pba6F
	 RkaD7XCfx7C0pPNZ39QPrbdlvd5gyBbQE8NfB/jTNwDIut0gHCwG8MeEwNCvDZspsy
	 1RFVDNJuaSOSQSLgD6YdyJpbGPn5z1KuIhfahZMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 147/265] mmc: meson-gx: report busy from DAT0 alone
Date: Thu, 26 Nov 2026 15:37:57 +0100
Message-ID: <20261126143615.338489637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1075,8 +1075,8 @@ static int meson_mmc_card_busy(struct mm
 
 	regval = readl(host->regs + SD_EMMC_STATUS);
 
-	/* We are only interrested in lines 0 to 3, so mask the other ones */
-	return !(FIELD_GET(STATUS_DATI, regval) & 0xf);
+	/* The card signals busy on DAT0 alone. */
+	return !(FIELD_GET(STATUS_DATI, regval) & BIT(0));
 }
 
 static int meson_mmc_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)


