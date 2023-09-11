Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170C411705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2C1C433C8;
	Mon, 11 Sep 2023 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443424;
	bh=z2XbQlF/z9YqeDR/0MsNi0kmmrJO4pYMvR4V5NOVfeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/j/ojj2q4uoFvX3MWs+O+6QC9U05uKC00pS1WcbWtd7TAvaOXs0JF+QDYlMINMqN
	 h1c6XJ+COnE20JEp7iDyik0t44csCE6A8XD4mcby1geIdWYpjrFHI/WyfoN5Ru3cH9
	 mPN5AXbSHW5mm4T/4VnPI9XB+P4LbEZbmW9HoXMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 373/737] bus: ti-sysc: Fix build warning for 64-bit build
Date: Mon, 11 Sep 2023 15:43:52 +0200
Message-ID: <20230911134700.971280081@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4cb23b9e06ea4..dbc37b3b84a8d 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3106,7 +3106,7 @@ static int sysc_init_static_data(struct sysc *ddata)
 
 	match = soc_device_match(sysc_soc_match);
 	if (match && match->data)
-		sysc_soc->soc = (int)match->data;
+		sysc_soc->soc = (enum sysc_soc)match->data;
 
 	/*
 	 * Check and warn about possible old incomplete dtb. We now want to see
-- 
2.40.1



