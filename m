Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67EA3AC0EB;
	Mon, 23 Mar 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278312; cv=none; b=V4XQfuaYhZ6Rz4UThjuBbeDz0orwkDBDbIuvst6sL8IaoSBbvxL3pwC33p49RXc/luBARyHXtllOTRB8bAecuhzbDRjxEhcdjX7zkLQgdC3bKjsYMgpW2jrlJnVy2i/llkKY62a0XSScPNJacr+fSQ301+cPAv4vBThlviSKPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278312; c=relaxed/simple;
	bh=lvfPdedbxCAuFHSR6lv8p3vVzShzo1biHBxVy+SD16A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsbr4LdV8+E/cv47sIYMs0Il+JgX1PBw4o3WPu4IdIul0AM2cTCifDar32B0wS1Mo9LEkMdRENrGNedr+tkL3xKzdnAi262VudzJYVuvaX4N2MeA7oVwO+L9DEB45EOobhF82fRCffyleXbkzjp2jvLVo+Lh1f3llBEh3gBv//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge/sxZr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge/sxZr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587DEC4CEF7;
	Mon, 23 Mar 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278312;
	bh=lvfPdedbxCAuFHSR6lv8p3vVzShzo1biHBxVy+SD16A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge/sxZr7J03tSqlvuhI0TmUvTV10kZSQXHu5eJaRSK823T5w4JoTHs5WkWl9e4yBR
	 id69YRAiVOmnCFADB4ZTtRTlb5zbcG+3UdL1WeyEmAxJ4nOk5EIojviYWeOjWF18PB
	 udkPGxGKppuaoWd7uZa9kuX3vV3bVs96vZSzfZHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 267/567] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA
Date: Mon, 23 Mar 2026 14:43:07 +0100
Message-ID: <20260323134540.435759865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 325291b20f8a6f14b9c82edbf5d12e4e71f6adaa upstream.

Add a DMI quirk for the ASUS EXPERTBOOK PM1503CDA fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221070
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260304063255.139331-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -703,6 +703,13 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
+		}
+	},
 	{}
 };
 


