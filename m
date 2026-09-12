Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57E30FF08;
	Sat, 12 Sep 2026 09:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206535; cv=none; b=Og2vUo7W1RVXabiMiripdWFfodL/y88OTTsYCK+DewoVMgHI79T+oaaoa17SoiACmKFpAHpojQ+Fk2Ool8wOIuXBXe9cZ1o7xzhdf/yep5wLHqTeb6DzQwWOGtfsAokWp0Q7UWXJvu2jiSdOEJy0cM4IRipG4xL2WVxgnUYDX1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206535; c=relaxed/simple;
	bh=euQRgw3bE4ut6sGyRJPSDhWQFWevVpAxcN+OVt0kh+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHVtPdTROafmjldPLZJAImfB6JntN38NYNFkBqBgPyrjgnSSiAIITXUtmKL3ZKf6MHa7IIJIJDBhzFkY9gQbhne8YtdZxvNd6LVn+0anjnjPim+JP3yM86rvsgSoNhcUKt2dLb1xVRUK5lraZNd2kUsFrdNWjn6A7ePKDfRrYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciqq8ZW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciqq8ZW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2459B1F000FF;
	Sat, 12 Sep 2026 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206534;
	bh=QL5X/+oiyzRA6urcXH6L9IUJL4Od6Kxy6lMLq3G59e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciqq8ZW8VyMcdq2GFl1RXV6NSYN3PvyVGJad5/CgIdGXhRjtRTWm2O9DHqCNSoMu5
	 WTQkPbn5iHiDlyfTekJ1ozvzWiZAE9BVFa6fkIL1k9xAs9shbO4AoyH/YoEtt+UQ9F
	 a+ksweVFThkuNvPgGGkFFG2ih8eC6MJm6b7YwpEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0225/1518] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:39:54 +0200
Message-ID: <20260912065628.577312580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit f883fa1a0a0212f63acb18c50e5f900301f3bb1e ]

manager_sysfs_add_store() passes 6 pointers to sscanf(),
but required latter to return 7 which always failed the operation.
I corrected it to 6.

Fixes: 49b9137a6002 ("staging: greybus: audio: remove redundant slot field")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260521182331.22685-1-grandmaster@al2klimov.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_manager_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/audio_manager_sysfs.c b/drivers/staging/greybus/audio_manager_sysfs.c
index fcd518f9540cd..ff323ca8154f3 100644
--- a/drivers/staging/greybus/audio_manager_sysfs.c
+++ b/drivers/staging/greybus/audio_manager_sysfs.c
@@ -23,7 +23,7 @@ static ssize_t manager_sysfs_add_store(struct kobject *kobj,
 			desc.name, &desc.vid, &desc.pid, &desc.intf_id,
 			&desc.ip_devices, &desc.op_devices);
 
-	if (num != 7)
+	if (num != 6)
 		return -EINVAL;
 
 	num = gb_audio_manager_add(&desc);
-- 
2.53.0



