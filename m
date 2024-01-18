Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B7722EF7;
	Thu, 18 Jan 2024 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575191; cv=none; b=tjG69Excf6lbPj5GEdcgEI5Hiv3Anqx5galSBbhKT+kId7rvbgS8EZXb4ZCygwZoTBGZ0zN+/DOWwc0ugv2sotvWmPg7iLkWcNLJzoUpKlilm97KiZzJSdWjGE0c5sufoFyVAll9djZpAcjb0kidhr1Ye/9HuUW+K/MWXWE/5vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575191; c=relaxed/simple;
	bh=/AYXz5oZNLQn2dCQkpsPfebE1DAlMt9jPxrV8iJz9iA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Z2AVihUXY2IIWt/CcIz/zQWHDL2m3/pd9Yf2XpuhorEqTQO9/clyhrOgzf1tUhSeQ73P610IE9bgO8gLYY/P8+GMJQBl5MZZdFERXtZQyMk3kuW4883zO+ugGICUxL+oGqHYgoZl5netVGueao1DgUSrcCUJJOMljdifuoLWuLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtCScxhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtCScxhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196EBC433C7;
	Thu, 18 Jan 2024 10:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575190;
	bh=/AYXz5oZNLQn2dCQkpsPfebE1DAlMt9jPxrV8iJz9iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtCScxhpHxiY3jehq67asue0Kl+hDjBBkmKZWxYE4mdhz7jxSVE456aTjFbu1tEq/
	 XMYoseskJQO4RpuCkIibH2ZfoKvu/GroLgKD5izD2lKBf0uVr+zaop7WM0t3FeiSWS
	 XZ7QO0HTgXuFodaCALA669KxdOP6qUpRvkCY5RcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Soller <jeremy@system76.com>,
	Tim Crawford <tcrawford@system76.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/150] ASoC: amd: yc: Add DMI entry to support System76 Pangolin 13
Date: Thu, 18 Jan 2024 11:47:46 +0100
Message-ID: <20240118104322.069602329@linuxfoundation.org>
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

From: Jeremy Soller <jeremy@system76.com>

[ Upstream commit 19650c0f402f53abe48a55a1c49c8ed9576a088c ]

Add pang13 quirk to enable the internal microphone.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
Link: https://lore.kernel.org/r/20231127184237.32077-2-tcrawford@system76.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a3424d880019..d83cb6e4c62a 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -395,6 +395,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "pang13"),
+		}
+	},
 	{}
 };
 
-- 
2.43.0



