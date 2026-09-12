Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF562E06E4;
	Sat, 12 Sep 2026 12:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216151; cv=none; b=FAIunnfcjY2oJe9UaZ2PeRhgyp4YRlFZFIZy9VuGrnbG7GVGkkJ3FFIItDqs11q9vPQIOESDfWzja8S4oKrgj8n9NLQbl52WVLN7BTiVKqLwoAxUoOu35FkAkJVeVIq/YmFpa2ZzfoSgB0awWeh2vHqiNrXQqq9CunuwzFo2xpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216151; c=relaxed/simple;
	bh=8LJSUwiZugRO+v6DOYggwJYfcmFCClE1yt48L4VzF1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM8GdDeiOmXjgLW+z2+5gXnbzpzncujKrvBpOYiixu9aYN8aqKAFpW9p3MAdDxdJx/b7IMK4oM/PKPZYWmClOle18F8ysetKD/rZh5cHsiIbEIRvh8ip6mRKELK1xuQhyJaQ16b21xsyxRlrsyXGO96PVmNMYVcawPFcn+b+z2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPLiO8q1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPLiO8q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D6D1F000FF;
	Sat, 12 Sep 2026 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216149;
	bh=KzPgU9HezV0TY4u/Vl/PNVOYTUKI2IpLCSIwSgrTek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPLiO8q19lK4y4ZVcjSdFhURa+BSw4RVR7IuLXNujxdQ+7n6oXV0Fn14/KGIaxI/f
	 NKgABZpvBbS2j7bhHcOHhc6wVdH77dJt0eTnkmExdPS1qhMtLnncr2NJJvT72wXGws
	 728H7iDHmUpWO1G6xhUC7cZPG3Q0eHti8dc0NP3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0678/1376] drm/tve200: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:51:44 +0200
Message-ID: <20260912065622.657778193@linuxfoundation.org>
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



