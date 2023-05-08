Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A78168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EC3C433EF;
	Mon,  8 May 2023 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544255;
	bh=k+PASQsFqRBatIw20f7DNAS8gvqBLR/gAz1oKm9TSZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPRoW6H9oerAcyepPg5i4xse8DjYP5Ck3r/BMa8o1WV49f5pLgrmEec13FcknjXvn
	 ZI9axGnXIokfB0qeMjj7pjEFsD4rjM3VBXlH+Eo/mt0kvjFqvvP2ltM9KJLauAx0Ps
	 wf/VvgzWkccsiULIjlYXMYMfq5BfgPMvkcsxtqT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Prashant Malani <pmalani@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 320/694] platform/chrome: cros_typec_switch: Add missing fwnode_handle_put()
Date: Mon,  8 May 2023 11:42:35 +0200
Message-Id: <20230508094442.701293036@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit dc70234c408c644505a24362b0f095f713e4697e ]

In cros_typec_register_switches(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: affc804c44c8 ("platform/chrome: cros_typec_switch: Add switch driver")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20230322041657.1857001-1-windhl@126.com
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index 9ed1605f4071d..752720483753d 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -270,6 +270,7 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 
 	return 0;
 err_switch:
+	fwnode_handle_put(fwnode);
 	cros_typec_unregister_switches(sdata);
 	return ret;
 }
-- 
2.39.2



