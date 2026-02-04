Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DEF3C1963;
	Wed,  4 Feb 2026 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218091; cv=none; b=n/hVR644zNEbNQmkBh37bjNa7tuo1myeDNZIG6qwlRme+F1xENw/LAjy/Lx0lkphG7+Sc0LWYJ8ytqqWMF2PMfEn+Uy+Xt6x2HfpIWge+9DDS5njbtaUYABa6sc4ik87y5OmjzkeOqgmpsvW3IQfy56OOIUp9YpgDheJ0D6SoDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218091; c=relaxed/simple;
	bh=+B3/AypqNsgDwFMjdMQLbi9U4FG+BjbJFuyfG0J7qcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOp8drYeHr7bmd0GxhWiesR+Y1TK3h3UFwEh2uwlQj74KLegBoPs1FIhJdfPG7uqJ9sVC/EgyL1GfTH2vn9zn7DLfG4gdG8PR6sNOFutFECFrhgp/X668vfbV2ex75DELki4BZaLILKGC9SmPl6QCCCBMMjLQ3lQ2pNtrFGhzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOkvV0Pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOkvV0Pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EC4C4CEF7;
	Wed,  4 Feb 2026 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218091;
	bh=+B3/AypqNsgDwFMjdMQLbi9U4FG+BjbJFuyfG0J7qcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOkvV0PdnuRjKSqOYlsUWc/KsOIQNGKsvILUR5cFmwJerjX6za/6QFlIFSr2jeJ/x
	 0AB0UbmMUaBgi1WXw/oF5TG5XvCpqSRwso7enx9iqleQomaTCU4STaLw5o2qdlwyAA
	 6w81X2+pp9SvZ5kZsYada6yCcVaocWD5WASGw9ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 210/280] ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO
Date: Wed,  4 Feb 2026 15:39:44 +0100
Message-ID: <20260204143917.155915196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

commit 9502b7df5a3c7e174f74f20324ac1fe781fc5c2d upstream.

Add a DMI quirk for the Acer TravelMate P216-41-TCO fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220983
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126014952.3674450-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -528,6 +528,14 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_BOARD_NAME, "XyloD5_RBU"),
+		}
+	},
+
 	{}
 };
 


