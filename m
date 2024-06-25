Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209B5FBEF;
	Tue, 25 Jun 2024 09:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308233; cv=none; b=J1n2DlSM+t0/8gDIyH9nj7DENgRU6/Jd/8B+FIq4CmfJlhBHn5LyZl/hNTCZkQUsWc5Nz+0sUwzbTPxtT53dZRHp0CGE9gEw2307r15gt3b7n5hiaUeme350uJb5IVn8SVpRQYkpF/74UqUe319Ah+hZmWLUfYFFldDA8l1+VAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308233; c=relaxed/simple;
	bh=zig9aYPl0tZ0BpNqKic+/8UN7P7lZe+gginvbjg/MnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTsLsJYzgUFvGT72Y0Y7jDvCrgU7gDd1bVTFFGs2cyKurPb7qO0eGLpTvYCjlXGMJwpuunYkRYLhdTmijTjRrTqb5HoU8T9Tk829RAqBkFD6CIzYPgOIPzztN4nV9X3mZpsrgIqviySgt8bbIjGWT+7ciaETlYmC2C00XnQ8LmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Z7wIm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Z7wIm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A52AC32786;
	Tue, 25 Jun 2024 09:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308232;
	bh=zig9aYPl0tZ0BpNqKic+/8UN7P7lZe+gginvbjg/MnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0Z7wIm2IGxI4hozGyFPLaiE24eyjwSnIc1ZSNUSvU6WYnPh2ZMI+jybjoBM9PqRF
	 U4lY5KPIvggxp7NJxAe2v7ZbciYlOky4z5gFTVaP3bEQJayFvX8kSrSiSfo8WCy02e
	 AwnQ3qjLBanuXeUAJTyYA9awPmlhwrWpVwJkfvRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 051/250] ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14
Date: Tue, 25 Jun 2024 11:30:09 +0200
Message-ID: <20240625085550.019360995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 4fee07fbf47d2a5f1065d985459e5ce7bf7969f0 ]

The default JD1 does not seem to work, use JD2 instead.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240411220347.131267-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index a90b43162a54b..a98b9da2a2c4c 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -495,6 +495,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_BT_OFFLOAD_SSP(1) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN Transcend Gaming Laptop"),
+		},
+		.driver_data = (void *)(RT711_JD2),
+	},
+
 	/* LunarLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.43.0



