Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF6168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F3DC433D2;
	Mon,  8 May 2023 10:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542957;
	bh=FC884IW4HmSfoKS5dBzpF8BXVzOw0LBrRmhS3DCvSEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bimP2C8u5vjDCKmbdJ8cSXkFXJF4QSBfiFDByQ29MNJR2E/C8MDLbJrpIdw6EHkrv
	 e03TNhpZWX6wt4U7JfXf4RpqwmLGHzoU6cemPzfCmnuzfftnXGVix2Xuq95ytXLB9P
	 rn/fmd/JeMxNZRC/7gwWPyHgqDoloayhRNBlS5F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 604/663] hte: tegra-194: Fix off by one in tegra_hte_map_to_line_id()
Date: Mon,  8 May 2023 11:47:10 +0200
Message-Id: <20230508094449.182441223@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e078180d66848a6a890daf0a3ce28dc43cc66790 ]

The "map_sz" is the number of elements in the "m" array so the >
comparison needs to be changed to >= to prevent an out of bounds
read.

Fixes: 09574cca6ad6 ("hte: Add Tegra194 HTE kernel provider")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194.c b/drivers/hte/hte-tegra194.c
index 49a27af22742b..d1b579c822797 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -251,7 +251,7 @@ static int tegra_hte_map_to_line_id(u32 eid,
 {
 
 	if (m) {
-		if (eid > map_sz)
+		if (eid >= map_sz)
 			return -EINVAL;
 		if (m[eid].slice == NV_AON_SLICE_INVALID)
 			return -EINVAL;
-- 
2.39.2



