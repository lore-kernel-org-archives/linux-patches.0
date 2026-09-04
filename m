Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4773718D636;
	Fri,  4 Sep 2026 05:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501312; cv=none; b=I+SpJ+wRntq7fnTN+EDCF2f1tpiRDvg5LfQfySS30USvwHgQq6YqxJc6hh+qbjDeAfu0WSE82XQx4Ul2WJeozwn2X2fKSyXI6HMKYyZUjoUuDvbs2yWoQjmaRVL8GWCjrdjlDjDBslHLrwYXXsgz5A8m5f5vOesC0rigbJtRbv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501312; c=relaxed/simple;
	bh=DVWhjs/aiBdPLB6zcnaUZxJqy1s8e/a5GIqQNJF8K3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RovC1/11ZSs0c+LsMpCxMMVLBEZagWwNL6Qwt12QhQXDkTgndaBEIBYJFtmnezeBCmfBSaLZCjwKu7JS7b8SS/xiZxkA5cEdiChYH4LpuKmW7ACc9tBTaoX4eJKzGiruj/XATSGFc2wyD/JFq9xTR8S5WMNdRFda9hHBxRVO6Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcS5/iY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcS5/iY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A086C1F00A3D;
	Fri,  4 Sep 2026 05:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501311;
	bh=PTW2KC6v2JjGW/iOVoV2w1tviSc7e/wUgwat6lfX6dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcS5/iY4k9xjQLIQbVjwHUtY6tH3UMHwq4/0JvbHHEbOzzWRCuDhsE4Unv9aKoYmk
	 bacn6i8LvHVL/IQCRmktq7T5B+CT9Ow85IPTQT1I9eKgyGfLZhxnLQh9oUAv0rlIp8
	 byCcECOznPxpEqHqAA3s8zDuQ/1PvwjVnIjdrvj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Tolang <christophertolang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 348/552] ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC
Date: Fri,  4 Sep 2026 06:58:25 +0200
Message-ID: <20260904045758.138875250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Christopher Tolang <christophertolang@gmail.com>

commit e2aa5ad3be41accfcdcccc62348f21af7baa3a38 upstream.

This model requires an additional detection quirk to enable the internal
microphone.

Fixes: fa991481b8b2 ("ASoC: amd: add YC machine driver using dmic")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI Codex
Signed-off-by: Christopher Tolang <christophertolang@gmail.com>
Link: https://patch.msgid.link/20260823113221.19744-1-christophertolang@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -749,6 +749,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7UC"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
 		}
 	},


