Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CA28F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D240C433C7;
	Sun, 16 Jul 2023 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538194;
	bh=hpGf9vCdNEztVJI2ZSWvpw22AOSaYsUojgeYrE59Aog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ob0/8U1cQWsupsUfM+ewUsK7hjg1U1uEWCwpuavmae0ZYzixWCCcvz1CIv/cEY7t
	 uv5b3JwhRmCWQ2qb+MNqdXay6M9vZmZKbV17jIhKD2/8kZWi5eLVPM9/sHPXpteij4
	 ipHofA/S4p9ylL43+DTKg4cw990vzs+1pWHHqDa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 365/800] drm/amd/display: Fix a test CalculatePrefetchSchedule()
Date: Sun, 16 Jul 2023 21:43:38 +0200
Message-ID: <20230716194957.556597737@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 960e27a5741cd3001996ff6ddfb3eb0ed3a4909d ]

It is likely Height was expected here, instead of Width.

Test the correct variable.

Fixes: 17529ea2acfa ("drm/amd/display: Optimizations for DML math")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
index b7c2844d0cbee..f294f2f8c75bc 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -810,7 +810,7 @@ static bool CalculatePrefetchSchedule(
 			*swath_width_chroma_ub = dml_ceil(SwathWidthY / 2 - 1, myPipe->BlockWidth256BytesC) + myPipe->BlockWidth256BytesC;
 	} else {
 		*swath_width_luma_ub = dml_ceil(SwathWidthY - 1, myPipe->BlockHeight256BytesY) + myPipe->BlockHeight256BytesY;
-		if (myPipe->BlockWidth256BytesC > 0)
+		if (myPipe->BlockHeight256BytesC > 0)
 			*swath_width_chroma_ub = dml_ceil(SwathWidthY / 2 - 1, myPipe->BlockHeight256BytesC) + myPipe->BlockHeight256BytesC;
 	}
 
-- 
2.39.2



