Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BE6263C78;
	Tue,  8 Apr 2025 11:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112389; cv=none; b=U7ttcY0YfCTM1ws5afI+1P1pnSIYqIiSh2Dexq/1JGMLIWZD0zpCrututLBzunJfb/QEYW4QoyMtGfD9M8UxzvHvWi9pIdoiLZ42rNrXGwVmWyK4L4r6ee5pY26QkmQStuDDJzKoK5k6BeUZeyU3PDE2gki1FTKlu5pZhUjXbRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112389; c=relaxed/simple;
	bh=NcNV2gO4GxJlFKR9vFrWdLQEGZQDg1A16Sb7y7QomRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZlROyZkgtElE+v3WimE0n9HcbqyRs3JYQgDjHChadsnSgW4jsHHqXgkrE/yp0OPOz6Ti0jg8hU4u+HrIrLDR8MeARSjo8LeQdhj+gRQrRInNuYcI8dPKBFPUyYhRKHsv/q0PjB6zoOZ57FEOsAmx7oVT467b5PV2nkMbfpy18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSWgkKw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSWgkKw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281F1C4CEE5;
	Tue,  8 Apr 2025 11:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112388;
	bh=NcNV2gO4GxJlFKR9vFrWdLQEGZQDg1A16Sb7y7QomRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSWgkKw3SQWwgLzYj15Ze39Hn/2BY86O6y5N+xEFaQYuF7fmwNJS4oe2wxzQAS0je
	 GZCfarcuNJYz4NQeMtVDaJGyr0bfMk35WGuDaO+TXkpUjtopeN9e1Rc2G5GDtch34v
	 oupC8obNBt7v7ZJNh0MRzWm3BaUol4Mabi+1e4ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/279] drm/nouveau: Do not override forced connector status
Date: Tue,  8 Apr 2025 12:47:14 +0200
Message-ID: <20250408104827.743225183@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 01f1d77a2630e774ce33233c4e6723bca3ae9daa ]

Keep user-forced connector status even if it cannot be programmed. Same
behavior as for the rest of the drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250114100214.195386-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index ac9eb92059bc3..30f871be52cb3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -754,7 +754,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



