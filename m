Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06F26E6F4;
	Fri, 21 Nov 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731198; cv=none; b=sEQDVWqkmgaZvCBoT9wGxK2ORg+FYA6U7QtftIKVVX8HtKFNVomjPV2AMhPwE/DAUQv5tWAoxYK9P9vqd/UUBXvvlXrG47iX8Oat6QsoqX9Sg033iFlOI4tf+AhF2BSAMhIR4hX3NKmYlnZ3Z5x4YNxtfz/gYbfp8akNk3kXBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731198; c=relaxed/simple;
	bh=m0NWgeqrSxErVqHoIvbc8iTKlv37Z6CmcGtC7d36oKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2unvQjTIqOqOBqaqzfC3Uod9eTSwK/k4Q9mxF3/903rfrguuAoTdDxw6loBoBHunryZeVxPcjjTLc/ohALuxWhqvwVpv71UYOkOBMlU7aHeVSCEU6TQz4Okupb8bnpXo9iUapR8f7rFezB2pqBj4rRE3ya7q4ZpXfw4jUvJ89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxvxPAQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxvxPAQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF0CC4CEF1;
	Fri, 21 Nov 2025 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731198;
	bh=m0NWgeqrSxErVqHoIvbc8iTKlv37Z6CmcGtC7d36oKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxvxPAQJtUr005pFJuqpgSOZKSwYCh9JtBNAX4BhaSN1RVNdKrldkNI59e8o0OQ8l
	 tP7XV/9uJL555BxkL9Mh6pSaeUaA0svYLARz7JcKUELhZwZnkrIVOuGiwnzqOLunys
	 Gp40XuWeQpYAmtMmcG5BL35dvfFcEINgROenwyLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 117/247] drm/client: fix MODULE_PARM_DESC string for "active"
Date: Fri, 21 Nov 2025 14:11:04 +0100
Message-ID: <20251121130158.782067033@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0a4a18e888ae8c8004582f665c5792c84a681668 ]

The MODULE_PARM_DESC string for the "active" parameter is missing a
space and has an extraneous trailing ']' character. Correct these.

Before patch:
$ modinfo -p ./drm_client_lib.ko
active:Choose which drm client to start, default isfbdev] (string)

After patch:
$ modinfo -p ./drm_client_lib.ko
active:Choose which drm client to start, default is fbdev (string)

Fixes: f7b42442c4ac ("drm/log: Introduce a new boot logger to draw the kmsg on the screen")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20251112010920.2355712-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_client_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_client_setup.c b/drivers/gpu/drm/clients/drm_client_setup.c
index 72480db1f00d0..515aceac22b18 100644
--- a/drivers/gpu/drm/clients/drm_client_setup.c
+++ b/drivers/gpu/drm/clients/drm_client_setup.c
@@ -13,8 +13,8 @@
 static char drm_client_default[16] = CONFIG_DRM_CLIENT_DEFAULT;
 module_param_string(active, drm_client_default, sizeof(drm_client_default), 0444);
 MODULE_PARM_DESC(active,
-		 "Choose which drm client to start, default is"
-		 CONFIG_DRM_CLIENT_DEFAULT "]");
+		 "Choose which drm client to start, default is "
+		 CONFIG_DRM_CLIENT_DEFAULT);
 
 /**
  * drm_client_setup() - Setup in-kernel DRM clients
-- 
2.51.0



