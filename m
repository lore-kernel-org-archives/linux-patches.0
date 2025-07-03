Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFBC2E339E;
	Thu,  3 Jul 2025 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554902; cv=none; b=B7EEx15MA6vT1g2G2DyNL5lHT83pqDspGFFKON6DQJKepL2ZpJ697BkehGbgJQ6deUnMKAMf+JQvID7JZG3FnDx7mO7SWSyyNLg/u+W7bjsd9EjTDB3Q+VGD6eDA9bJxrvG9vJh9G5lMfxWQpTh8ZlxuxPbuvsKHFcjJTRo8W7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554902; c=relaxed/simple;
	bh=GPoAzZb9KTjB9xCwhA8xFWdjBrk64hYGMJOdjehe8zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CroxSRvEDrQ1256iRfHfD1xhFR+EeWaZd/WYyhUyeHESrTW4iXqkGp/qTHe64FEVXIIlfPId6R2XNClz+/d6wiQZjT+g+9lXJim0iqsIK0KkNDvCSPHkITahsymx4dN+xaUbYWQUs8GS/slQbyu1XPdRhkqjRYajXULdlXK53BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZZG0sHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZZG0sHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFB6C4CEE3;
	Thu,  3 Jul 2025 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554902;
	bh=GPoAzZb9KTjB9xCwhA8xFWdjBrk64hYGMJOdjehe8zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZZG0sHPXPLArFG8freurlMPbW9pbkIdAIeeoxNNdr9mBRXnBDowAdspMKMs/LlZu
	 rUZ9NcMOjdeqCIOR6azaHQAK9CWSo56Yb/urULj987LfpdRZhP4wgc6MQy9JHFAvcW
	 D8o6tZ8+jCvN240qkZrEaeUVHAm17Bas+vhxTkG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Schramm <oliver.schramm97@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 114/263] ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15
Date: Thu,  3 Jul 2025 16:40:34 +0200
Message-ID: <20250703144008.913862131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Schramm <oliver.schramm97@gmail.com>

commit bf39286adc5e10ce3e32eb86ad316ae56f3b52a0 upstream.

It's smaller brother has already received the patch to enable the microphone,
now add it too to the DMI quirk table.

Cc: stable@vger.kernel.org
Signed-off-by: Oliver Schramm <oliver.schramm97@gmail.com>
Link: https://patch.msgid.link/20250621223000.11817-2-oliver.schramm97@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -356,6 +356,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J3"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}


