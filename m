Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92A847A57;
	Tue, 14 May 2024 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686553; cv=none; b=JwWUBCxVbmqmn6UNkEUMheTyNPI2QpJ7lXuP+YP5Raoa8/gqjftniWT93JmJPs29hOYbrIOfVaI77E6Ksj5TZevF1AJc0a1jlquUpzUy4TdgJZ+8nIcXcPBqiG6QRwwTJE6ue6BHK5V8P7XW2NsvumoooN810D9dtZebvIh7lsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686553; c=relaxed/simple;
	bh=HOUFTI+uRHVS7tUi10XoF0Uo3jRh6wr6w65jj0LyP4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2yXHivD7idXXz8EI8EqCa/psfCu03LT4Ox9H/sJmPqI3P523NbYMJ6KA19T8H7g2SE4vgR6lDw4h5q5ntJx8TZXV1Bh7cwzComUv9utiMfLRLnu+0QvxpYpQ62QWElvkcLhT4717tu/nsLM4UmqmYmCXal5WZxjKUvP3Dwzhow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esPNdtnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esPNdtnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70876C2BD10;
	Tue, 14 May 2024 11:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686552;
	bh=HOUFTI+uRHVS7tUi10XoF0Uo3jRh6wr6w65jj0LyP4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esPNdtnuP4K8AGHBjXZTe+BlK6TAjhDp9MessUHoj4iSzw3q4LKf7bdeanz8/4+qp
	 /yozV2fdgJoW0ioRNMAs5DdwilIOv9P+tX8HiYo5nczFgWZPWm21JdbLmdpw4Ltck6
	 YlZjHOPADnXUh8DhGYw7p7PvcAS+jdH5uhTZKsDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Simon Ser <contact@emersion.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/236] drm/connector: Add \n to message about demoting connector force-probes
Date: Tue, 14 May 2024 12:18:58 +0200
Message-ID: <20240514101027.044159339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6897204ea3df808d342c8e4613135728bc538bcd ]

The debug print clearly lacks a \n at the end. Add it.

Fixes: 8f86c82aba8b ("drm/connector: demote connector force-probes for non-master clients")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240502153234.1.I2052f01c8d209d9ae9c300b87c6e4f60bd3cc99e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 27de2a97f1d11..3d18d840ef3b6 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2707,7 +2707,7 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 						     dev->mode_config.max_width,
 						     dev->mode_config.max_height);
 		else
-			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe",
+			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe\n",
 				    connector->base.id, connector->name);
 	}
 
-- 
2.43.0



