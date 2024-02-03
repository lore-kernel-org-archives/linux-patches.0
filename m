Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCBE36122;
	Sat,  3 Feb 2024 04:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933601; cv=none; b=JQEvZ/lGsu4QAeZTozodGJcF0PUnksvPIIGt+0gFMIX5v/HM/21voiS8oAe6KnEriQkYoPvtE/7tvpKCnSBnN7OnFsNxaxbGEHJIAaf4IYo+JUrCBvC4iGcDkEOFIvn3lPzFAFNCoBw7bxD9dGOflcHFRC9GazZgcnjIh1Vc8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933601; c=relaxed/simple;
	bh=8Qu75LzH1eNQNAC6RC89HaB00zjDjjv0LNa9eGnaTdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMFZdsevX2ycf1jD9k/OMcMKvFF7T81k51DzMgcRZRJCl1bzslhTkT7yldn24C1IOO+5DI0hc749eeCp2QXWAhRere3Z6ksqEF3eTafKkqeNuOFzUIQvPPNRPX1Mz/cQAU/fIHTGeOIKIYHN7sFOa58v7j+f4HkNQyeX8lzDW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNhlF06E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNhlF06E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B610FC433F1;
	Sat,  3 Feb 2024 04:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933600;
	bh=8Qu75LzH1eNQNAC6RC89HaB00zjDjjv0LNa9eGnaTdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNhlF06E7Hh40Q+UHNeRDucSbiAgDEAof7Br6cSsGw+/8DR9kxkLjkS0j5bzBePgB
	 96OyiDukkZHbXyaweYQ+e3guMmlxhT2DzsCSi6lE2MnKxf5hi5INBL4IlfEl/OLj13
	 aZ4zAzGhxctJcXMZi7fibftACd043OOXHG+PjXjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/322] drm/drm_file: fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:26 -0800
Message-ID: <20240203035404.698367770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 1d3062fad9c7313fff9970a88e0538a24480ffb8 ]

smatch reports:

drivers/gpu/drm/drm_file.c:967 drm_show_memory_stats() error: uninitialized symbol 'supported_status'.

'supported_status' is only set in one code path. I'm not familiar with
the code to say if that path will always be ran in real life, but
whether that is the case or not, I think it is good to initialize
'supported_status' to 0 to silence the warning (and possibly fix a bug).

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-1-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index e692770ef6d3..a7799086017a 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -958,7 +958,7 @@ void drm_show_memory_stats(struct drm_printer *p, struct drm_file *file)
 {
 	struct drm_gem_object *obj;
 	struct drm_memory_stats status = {};
-	enum drm_gem_object_status supported_status;
+	enum drm_gem_object_status supported_status = 0;
 	int id;
 
 	spin_lock(&file->table_lock);
-- 
2.43.0



