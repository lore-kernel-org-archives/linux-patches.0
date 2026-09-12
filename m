Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38BA78C9C;
	Sat, 12 Sep 2026 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223831; cv=none; b=EyRPg/9fsdnyMBa9zzGEkcfXfPHb0RLtW7jRqFS60EXixE+XvQKH/N7S7/M0b72oVXlVsZhy+6hw3JjoErjHvOIhy7Wy11CjV6FzXKyR5lEpwQ2uHpyHJZX5iZ0OqVCpEBImfjs5xKerj81XpBD5AcchTBPVHlMBMNPVtVW+U1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223831; c=relaxed/simple;
	bh=ZWDul57Gqf7n4I/EQSYe2Ual3IsXeIciPGOMyK/Mya0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0uMO/QjP+lfT1vni+wMxAC84HbXwJLTW+mnllJkyzEYJrzhANftVMdegkHwQAf0SrI3eZIFqSsAJOxNc06OkvP5JJ1VKWrcFv3wPV/lKpwK5fPVK2BRYe3qcoz9vW84wzORBFfKYCcqoLedsKQd9vKQDw3wrStf0o3v734vPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S70umv0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S70umv0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3601B1F000FF;
	Sat, 12 Sep 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223830;
	bh=wCkVz0jxVJgZEXTT5W0ajNoKUi0UVm+Bhyzuvu0rgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S70umv0LdphO88l1XEUCX3bCHvkFBXeGysfksIh0MuiqQqvUkIZo0jfzyWSVdovub
	 IkxW7Kngj00njXz7RYBkiGOUPiDQjygmFTYyv2+/5mtP845LPHiqOdkoiDhAVrZyFA
	 BfbTuVjHtXHbPYRcoF4ZVDUa/svbdOiwU6r2N+mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0870/1424] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:55:02 +0200
Message-ID: <20260912065626.804249900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit b6c3585f2058e0fbfa8cb403458f5cc6cf5c5e06 ]

The TVE200 DRM driver can be built as a module and uses tve200_of_match
as its OF match table, but the table is not exported for module alias
generation.

Add the MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF
module aliases for OF based module autoloading.

Fixes: 179c02fe90a4 ("drm/tve200: Add new driver for TVE200")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260715024130.186416-1-pengcan@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tve200/tve200_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tve200/tve200_drv.c b/drivers/gpu/drm/tve200/tve200_drv.c
index acce210e25547..0f55ead3ddbbb 100644
--- a/drivers/gpu/drm/tve200/tve200_drv.c
+++ b/drivers/gpu/drm/tve200/tve200_drv.c
@@ -261,6 +261,7 @@ static const struct of_device_id tve200_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tve200_of_match);
 
 static struct platform_driver tve200_driver = {
 	.driver = {
-- 
2.53.0



