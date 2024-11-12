Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B422ABC4;
	Tue, 12 Nov 2024 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407899; cv=none; b=fIIbft5R3fzExmqCqKaBWPTJ5vyUf/dcg1W/GXpopSgLU5yYbnso15+fjhoB4W5MaGChtxjuglP13S/7hCvPXUETPkfzM5Vqchu0Cjxj+Q1NK6ho4mKeT+d0ipWS61Lx+rBS7tOSzBTaFyxNa9pM47csw26cFf9WahAFuI+5KF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407899; c=relaxed/simple;
	bh=g6cHlQO0PdKodydZgGVsBSpQnjnIZgKCTrCvBMqrWxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3CTnzsdSDjCg+T4T6EWf5clhxBmfCOygR9gaELs3NCGcbhOdBdqChmgbifCyEk5lj8ctnvwl/9f5vdb61aMxQJuuzPpuDA8KLSrWWZZ99yFdmmM8Q9vOWjXLp6TDptRaN8gvmHS5Mg93JXKT9OEteiru6sF2fAjS1oQfs4M4zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdWk1kdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdWk1kdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301F3C4CED7;
	Tue, 12 Nov 2024 10:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407899;
	bh=g6cHlQO0PdKodydZgGVsBSpQnjnIZgKCTrCvBMqrWxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdWk1kdPwuhtp5wzRt0yyu37UmXz9hGincgW1frpVQijXkXv7BqdYZDNGC6kbtXmC
	 ZEeXIaCMcJRkmvCCBv2dgnRvbc1BGzo5JCxMxdjtceUw5QGur8mMvbvcXMlEDUHhXw
	 bIKqtbtsVUkq/3U+lqJrDZGmf2/Ud6mRcGpWxtiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Mark Brown <broonie@kernel.org>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 117/119] ASoC: amd: yc: fix internal mic on Xiaomi Book Pro 14 2022
Date: Tue, 12 Nov 2024 11:22:05 +0100
Message-ID: <20241112101853.187483298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


