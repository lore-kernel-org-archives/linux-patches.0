Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3397212D16;
	Tue, 12 Nov 2024 10:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408497; cv=none; b=ehtFtLZdyVlexu+C4yoGScyhudOTsvyQQUX5L+ibULhot0Rv97+Eoms0RyuoQGnvuoEYbfuwIqLIfmHmUlZSjhTLehtXuGOJYt+INE6OJ3aCMaMkIP9RSsFIG9J5vFq3Sw7ooJWHgyjqE8HsMicF3seiXvdiOUgPM9WQCgoIGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408497; c=relaxed/simple;
	bh=jDKS6R6uI2kj2tGIjOFAeUpDzlQHmWm2o6bQIoZHezE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9qOHKERaGv2h+A/aDkPEi4XKW7bC1A83IM7dRmO+WYjP9gGwRSc41cvHcUSV+iXja/Jjf4H/zEwvUmCVaWGugfZf/0xdL9ZepEmmd7h0KiJRNgJNV9NgO3rcRFuA9Y2n2uG/WAkoO3YoCh3oTD3qk8D3wOmqYQyoEYr4EXPF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ji97/cTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ji97/cTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D23EC4CECD;
	Tue, 12 Nov 2024 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408496;
	bh=jDKS6R6uI2kj2tGIjOFAeUpDzlQHmWm2o6bQIoZHezE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ji97/cTs1ApNKyl7vVLyLYjNjApvUKIGmzIv+G2RaeGxLe+cNiNsHQ+311ffnStK1
	 IUiCi2GmNKX5ga3cKp+zDBmieVVbpc/v4OkZ/UmQraXZ0ckgirwGLzfk/creOZ5hSO
	 oQ6YSx6j0fJfFGIR7+rNBdiObhmCUjBNzWlDfe8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Mark Brown <broonie@kernel.org>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.11 181/184] ASoC: amd: yc: fix internal mic on Xiaomi Book Pro 14 2022
Date: Tue, 12 Nov 2024 11:22:19 +0100
Message-ID: <20241112101907.810627808@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

commit de156f3cf70e17dc6ff4c3c364bb97a6db961ffd upstream.

Xiaomi Book Pro 14 2022 (MIA2210-AD) requires a quirk entry for its
internal microphone to be enabled.

This is likely due to similar reasons as seen previously on Redmi Book
14/15 Pro 2022 models (since they likely came with similar firmware):

- commit dcff8b7ca92d ("ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022
  into DMI table")
- commit c1dd6bf61997 ("ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022
  into DMI table")

A quirk would likely be needed for Xiaomi Book Pro 15 2022 models, too.
However, I do not have such device on hand so I will leave it for now.

Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://patch.msgid.link/20241106024052.15748-1-jeffbai@aosc.io
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -384,6 +384,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Xiaomi Book Pro 14 2022"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Razer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
 		}


