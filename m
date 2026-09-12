Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77FE43B3EF;
	Sat, 12 Sep 2026 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214905; cv=none; b=jR6oHsX0Iqu/uPAhVEEemr636czPJtrTg9JQ0WzVoDidbK52uS+xbldHOnbMDzM/ved0yu8mPbHJ/OjY83y4Yka64e6AnL99oA4XWlkbQBZxa1lBvS54+FIKL5OgXeD/CaXHijnre/IbHYnw3GzPKAQu8ZVwgw5tWJGDX9YQ72g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214905; c=relaxed/simple;
	bh=WT5kYARIAH0r37EKjMH1RGDX3oUyCgl/5ovs/1GNW+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9GLZ+LiyUZKMYUhbU9MC7mlnpZD9cAjs7cNLvn+8RvgNB7M9OVrz6uXgW18bCo5VBvnotojGiXJuK19TOes+wkMhTdgDK7LtSawptJZua2b73FTaURwpSpwQdsnY8ZsW+e9JCsYjuIO56FymcszQnzKvg/1jNyW8SIuiV6UzL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpx/Dr1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpx/Dr1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA981F000FF;
	Sat, 12 Sep 2026 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214904;
	bh=7fCKPLq0dRPLbIfjAU+Yq3+Et76iC7gNevM3ZZQHWFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bpx/Dr1RXYLFPgfwFqLk8FEXUyHb+5xXE2vUjezztvYANFxWMXRfjIEkE9nFyUDO9
	 kEoRwl/3vtjL+yBxIzPmD0Gxu2q9+9aQ9lElESIB5aGodK3HDZg1Nn/EVNZL3UP/rw
	 K+kNXa3lDUHb02cZ9+LMeU+eTXjOyiMgaE6KbbWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0420/1376] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:47:26 +0200
Message-ID: <20260912065616.898496492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



