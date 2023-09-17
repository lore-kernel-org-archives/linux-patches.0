Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6C97469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB03DC433C7;
	Sun, 17 Sep 2023 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982198;
	bh=3hPLdBVL40Y60nUG3xcOXcegDGvyVubvecIryjaXdZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtBu4vmtmZ0gTGgSrI8yfmcwDZMHSsMZG1kW8jPQARwfoEY/CWoH+6Wk9nsZFYoBK
	 Yi4NfyYCaZciyX3jVbQ844tnqdnEFOa2YlhDZV8LKkh7FhBc6T7rqqDf6SgUyrG686
	 DIq1u7Af/JPHQ8RmwJXZ6q9yfmErtHfzaqFX76vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/511] bus: ti-sysc: Fix build warning for 64-bit build
Date: Sun, 17 Sep 2023 21:10:07 +0200
Message-ID: <20230917191118.178684417@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e1e1e9bb9d943ec690670a609a5f660ca10eaf85 ]

Fix "warning: cast from pointer to integer of different size" on 64-bit
builds.

Note that this is a cosmetic fix at this point as the driver is not yet
used for 64-bit systems.

Fixes: feaa8baee82a ("bus: ti-sysc: Implement SoC revision handling")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 71b541538801e..b756807501f69 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3055,7 +3055,7 @@ static int sysc_init_static_data(struct sysc *ddata)
 
 	match = soc_device_match(sysc_soc_match);
 	if (match && match->data)
-		sysc_soc->soc = (int)match->data;
+		sysc_soc->soc = (enum sysc_soc)match->data;
 
 	/*
 	 * Check and warn about possible old incomplete dtb. We now want to see
-- 
2.40.1



