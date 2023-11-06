Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF727200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViMGIgSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3DDC433C8;
	Mon,  6 Nov 2023 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276001;
	bh=8H7xu6cZeYDQl+KYaF8vjs73VhUjxJ8wse8oKv11SAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViMGIgSIjnK3ab/lKQYwghk3kvleK9YKjBH2z3MROUBygR71jShiY3KjcGMcJ5KgN
	 QxjNosDjPTVaNxuOLzpkh8o3by3lIvlJwpZ4uOVIM8liHWLC8gI7B+E56G3LxzVOxl
	 Y4v07Q8IXBfZcUiUtkJ+pJawD4YVouPIcONHJAFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Maidana <jorgem.linux@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/48] fbdev: uvesafb: Call cn_del_callback() at the end of uvesafb_exit()
Date: Mon,  6 Nov 2023 14:03:27 +0100
Message-ID: <20231106130259.090620885@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Maidana <jorgem.linux@gmail.com>

[ Upstream commit 1022e7e2f40574c74ed32c3811b03d26b0b81daf ]

Delete the v86d netlink only after all the VBE tasks have been
completed.

Fixes initial state restore on module unload:
uvesafb: VBE state restore call failed (eax=0x4f04, err=-19)

Signed-off-by: Jorge Maidana <jorgem.linux@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/uvesafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index ee86c62e36728..72255715bbee0 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1931,10 +1931,10 @@ static void uvesafb_exit(void)
 		}
 	}
 
-	cn_del_callback(&uvesafb_cn_id);
 	driver_remove_file(&uvesafb_driver.driver, &driver_attr_v86d);
 	platform_device_unregister(uvesafb_device);
 	platform_driver_unregister(&uvesafb_driver);
+	cn_del_callback(&uvesafb_cn_id);
 }
 
 module_exit(uvesafb_exit);
-- 
2.42.0



