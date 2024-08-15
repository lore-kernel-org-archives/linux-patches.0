Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74AA19FA89;
	Thu, 15 Aug 2024 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729024; cv=none; b=tA0B7Kimi/iucfeJnocXgvco1FrtEoy2h3lO1UTWH0vfgNypOYUC4lK36jSeCuE5sJATrJc+FRY0lL0lU2QqAQQDTYdhSySkpVfygy5K5xdA0pX3wFw65hdFRtmjS8AOZ3eOjj5zX9W6ViiiFBQ/2B0RITx6xmXQqhljUxdiGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729024; c=relaxed/simple;
	bh=eJMUQbCU/3bt2wLkONvo8I0PPbl8MrYqEEe8ewwHlRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THOp1uqY7DUtN/ur/9jXtB5MrU8O6GKRgIJYZ5D5aVKCStDsuxlC30EWoGog5cYUaQ5DM4xIWLCQlvOJSblzrjwReIsArHgdUZz/ypxziouA7FccVFtUvnDLY+NGK0OclAg4NL1PYTX6KrWJXvJH0p7lfLCet4YbjjESLaTC5S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQNzQaBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQNzQaBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A71DC4AF0D;
	Thu, 15 Aug 2024 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729024;
	bh=eJMUQbCU/3bt2wLkONvo8I0PPbl8MrYqEEe8ewwHlRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQNzQaBT+I9uMvb/lWHvg7Y2NyC79uw5iZU5o4kcaHGHlYQDrfZfZUvspOB/V/OxT
	 0crdgcC/tUYxMt/IZNSdG0yzM3l5P6aVqxtiLf7Bl6kKCGkuVUDoCmBNL4YkhX8fgf
	 pFwp7sUD2sZ6MTTagwig3EvvRSVG6oCAPeGIBrlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 4.19 187/196] drm/mgag200: Set DDC timeout in milliseconds
Date: Thu, 15 Aug 2024 15:25:04 +0200
Message-ID: <20240815131859.224783574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ecde5db1598aecab54cc392282c15114f526f05f upstream.

Compute the i2c timeout in jiffies from a value in milliseconds. The
original values of 2 jiffies equals 2 milliseconds if HZ has been
configured to a value of 1000. This corresponds to 2.2 milliseconds
used by most other DRM drivers. Update mgag200 accordingly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: 414c45310625 ("mgag200: initial g200se driver (v2)")
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.5+
Link: https://patchwork.freedesktop.org/patch/msgid/20240513125620.6337-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_i2c.c
+++ b/drivers/gpu/drm/mgag200/mgag200_i2c.c
@@ -133,7 +133,7 @@ struct mga_i2c_chan *mgag200_i2c_create(
 	i2c->adapter.algo_data = &i2c->bit;
 
 	i2c->bit.udelay = 10;
-	i2c->bit.timeout = 2;
+	i2c->bit.timeout = usecs_to_jiffies(2200);
 	i2c->bit.data = i2c;
 	i2c->bit.setsda		= mga_gpio_setsda;
 	i2c->bit.setscl		= mga_gpio_setscl;


