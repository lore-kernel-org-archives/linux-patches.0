Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE494F5E9;
	Tue, 23 Jan 2024 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969892; cv=none; b=QOM5U501znu/UzPdrwxXCsWTUsfEExcHypDSmwALU2myi6Ypt3mRYJCE9khd/Ft6rG+6OWEW5kJQvkgglDTg+Qy2FUUh1gUz9MQXMOZUanzBRvReJQNTdBUiTYMliaqOgEB/VFmQvqD7TYqoUAL19lFi/kKl/UYIYHSLaa1aSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969892; c=relaxed/simple;
	bh=yHqLBVsuTscQkU1DYIHjNBlxuiTVOOjY5kHifHYDGiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf79C8AR1sJ7dA+kJw8+XZt6Szof2OZVRLtscnfPB4EHWUAxVNBvP/Cea4xti5G7tPQQHOl4mciAuqURLuqJwuFGH7s8qhb04pEF9vKzjvtD/bZ/CzN8qwhhPApf3VSruAa1n0dCvhZfSXvtLflBzMDas+th5O7RaLGkzGk/zzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cO/qbym1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cO/qbym1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A79C43390;
	Tue, 23 Jan 2024 00:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969892;
	bh=yHqLBVsuTscQkU1DYIHjNBlxuiTVOOjY5kHifHYDGiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cO/qbym1mykUiu/XQrDPQEMUfVngnhGUa1fRiYtfKAyG6RSNifqrZ0TtpXGciXfyo
	 19Lb70iwt15JvIK6HwIQHFXQaQtR0Yk9xC6Z/LtrkSO6fMgu2XaL1ooWxz3jxrJMYk
	 FtJrhkPxa+rUn5XDwU7DXt1iWdukdr3L7Mp9G4Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 510/641] staging: vc04_services: vchiq_core: Log through struct vchiq_instance
Date: Mon, 22 Jan 2024 15:56:54 -0800
Message-ID: <20240122235834.041260627@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit f9c42898830383aff4fdc723828fa93a6abec02d ]

The handle_to_service() helper can return NULL, so `service` pointer
can indeed be set to NULL. So, do not log through service pointer
(which can cause NULL-deference), instead, use the vchiq_instance
function argument to get access to the struct device.

Fixes: f67af5940d6d ("staging: vc04: Convert(and rename) vchiq_log_info() to use dynamic debug")
Reviewed-by: Ricardo B. Marliere <ricardo@marliere.net>
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Link: https://lore.kernel.org/r/20231128201845.489237-1-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/vc04_services/interface/vchiq_arm/vchiq_core.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index 39b857da2d42..8a9eb0101c2e 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -245,7 +245,7 @@ find_service_by_handle(struct vchiq_instance *instance, unsigned int handle)
 		return service;
 	}
 	rcu_read_unlock();
-	vchiq_log_debug(service->state->dev, VCHIQ_CORE,
+	vchiq_log_debug(instance->state->dev, VCHIQ_CORE,
 			"Invalid service handle 0x%x", handle);
 	return NULL;
 }
@@ -287,7 +287,7 @@ find_service_for_instance(struct vchiq_instance *instance, unsigned int handle)
 		return service;
 	}
 	rcu_read_unlock();
-	vchiq_log_debug(service->state->dev, VCHIQ_CORE,
+	vchiq_log_debug(instance->state->dev, VCHIQ_CORE,
 			"Invalid service handle 0x%x", handle);
 	return NULL;
 }
@@ -310,7 +310,7 @@ find_closed_service_for_instance(struct vchiq_instance *instance, unsigned int h
 		return service;
 	}
 	rcu_read_unlock();
-	vchiq_log_debug(service->state->dev, VCHIQ_CORE,
+	vchiq_log_debug(instance->state->dev, VCHIQ_CORE,
 			"Invalid service handle 0x%x", handle);
 	return service;
 }
-- 
2.43.0



