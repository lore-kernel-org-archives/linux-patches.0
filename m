Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06801C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6ey2lCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62829C433C7;
	Wed,  4 Oct 2023 18:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444498;
	bh=N7oQPsSYV/uH0Ii2tSEf6s63iSwEZPxcJ5n2JWfcu5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6ey2lCS8puRKFx4CW3L/d8h85z1ZbzIkkCX/L3GHowEBd0UN2AayLkxZmdJgmStq
	 zH8FfvuSvpLTjonGNA9qIJFUaszoG4QwZAx9BvzMG5I1b37bmPHFrfcR4UBPlX7UEz
	 1Ddef7TWWM40NeS2Lvx2evpqucUbVWMW56LTTcsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	August Wikerfors <git@augustwikerfors.se>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 270/321] ASoC: amd: yc: Fix non-functional mic on Lenovo 82QF and 82UG
Date: Wed,  4 Oct 2023 19:56:55 +0200
Message-ID: <20231004175241.793912436@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: August Wikerfors <git@augustwikerfors.se>

commit 1263cc0f414d212129c0f1289b49b7df77f92084 upstream.

Like the Lenovo 82TL and 82V2, the Lenovo 82QF (Yoga 7 14ARB7) and 82UG
(Legion S7 16ARHA7) both need a quirk entry for the internal microphone to
function. Commit c008323fe361 ("ASoC: amd: yc: Fix a non-functional mic on
Lenovo 82SJ") restricted the quirk that previously matched "82" to "82V2",
breaking microphone functionality on these devices. Fix this by adding
specific quirks for these models, as was done for the Lenovo 82TL.

Fixes: c008323fe361 ("ASoC: amd: yc: Fix a non-functional mic on Lenovo 82SJ")
Closes: https://github.com/tomsom/yoga-linux/issues/51
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208555#c780
Cc: stable@vger.kernel.org
Signed-off-by: August Wikerfors <git@augustwikerfors.se>
Link: https://lore.kernel.org/r/20230911213409.6106-1-git@augustwikerfors.se
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -217,10 +217,24 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82V2"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82UG"),
+		}
+	},
+	{
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),


