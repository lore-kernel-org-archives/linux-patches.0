Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511523760;
	Thu, 18 Jan 2024 10:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575168; cv=none; b=I0UyBo4SdQQG/a1MkDakB5GaWoPzVQp/fxhGHapfaa8c4GgOM1CIgctSd4/hLAxEL8l9b8iawl7FizYnRHryc6XRwffJV6WUli0aEgf/3elhMZnfzYnI0Ys8DBxoMgcGUnnoM4YjQ6WLkq28fojKkY1zLSuYz686RCCpbEUIG7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575168; c=relaxed/simple;
	bh=OBB3fJ+zpoU8NcWlzmErrHwTP+cn8IYLbMJM7n2AVKc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=DJ19hBcMTqS43ddDTTAQyvEBGxltRXEvXYQPWGVugx0hIZrAjS+cM91H1dFEWE7B6P08BMJFDwAP6t6pHghH5akXZ9pdZVxPjnkcobtdzE9Uh0af3WXK5xwuGbcus2RGVFkyW/jNVHVLKxvHt4SWX8khH472w46rbvPoVoic9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByIUiHlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByIUiHlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3E4C43390;
	Thu, 18 Jan 2024 10:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575168;
	bh=OBB3fJ+zpoU8NcWlzmErrHwTP+cn8IYLbMJM7n2AVKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByIUiHlRo9P8d8kH6Zt28vGAkTMCJVISLWNnFgI2c4tH4sMC6nPpVjj8nv8PAxJ5n
	 TyKne+ZBPfGzXmU2e6aDCthuh7n8wb4OWZwo70h3ioT1iE10eyrkoawKKWsDfZkBv6
	 ygenVNwZ/9ci7EvPIhzGcJ23QTX4Vfi1u3e+8CHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Malych <matus@malych.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/150] ASoC: amd: yc: Add HP 255 G10 into quirk table
Date: Thu, 18 Jan 2024 11:47:30 +0100
Message-ID: <20240118104321.384024830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Matus Malych <matus@malych.org>

[ Upstream commit 0c6498a59fbbcbf3d0a58c282dd6f0bca0eed92a ]

HP 255 G10's internal microphone array can be made
to work by adding it to the quirk table.

Signed-off-by: Matus Malych <matus@malych.org>
Link: https://lore.kernel.org/r/20231112165403.3221-1-matus@malych.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 3babb17a56bb..a3424d880019 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -374,6 +374,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A3E"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8B2F"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



