Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270761ABECF;
	Thu, 15 Aug 2024 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732918; cv=none; b=lPCtpR/gI35JyHvqchTAhSR4ZTMaK/bak1PhjtNt6T5HXtL3DofiJxPxicuw83SVdv1wSOWEzcBErcCEa2PaT8FDmBX8UgTPaPOso1dIbgn/r9HdtyKobN83Wd+oC2V3m6XBktbZkqKMKxwY1hrVPBLBkiSuncN1fWfLyI0dNKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732918; c=relaxed/simple;
	bh=x0N8jQwsK/HCOvqdsvy0TJR2PTtkg7PHYTH5Y8Z6WdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtJPtdf7Q80in7v8/hLekpom+lFVnvCAjsCjG5OBWr4rt5k9lh/S3O22aDqXNa6gHYBNRuMSJpRqjKTmAQJBO5mOiPpuzZtmCi48sKaD7KHuLnXzAupIJZFCIdcBK+vgF4unVhUjocTEUgw7CZgRB4dIMvgMLC86VRTCGzZH/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMKUGStp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMKUGStp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A047EC32786;
	Thu, 15 Aug 2024 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732918;
	bh=x0N8jQwsK/HCOvqdsvy0TJR2PTtkg7PHYTH5Y8Z6WdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMKUGStptm5SzDFieSjq6w7rlin2i3uIIPt5C6s0ncrN7R1eWseyTHKkGmF6sprxd
	 B2bmSc7OG25UAnM6ce0mHC4A50k6JxV2V9uESVCsznNQaXdgGcf9XyTXNIoCHUYRai
	 I0nCYMmTLnpyNusdSFcirCRkWcnQtV0H5kFVvghc=
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
Subject: [PATCH 5.10 327/352] drm/mgag200: Set DDC timeout in milliseconds
Date: Thu, 15 Aug 2024 15:26:33 +0200
Message-ID: <20240815131932.090249827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,7 +134,7 @@ struct mga_i2c_chan *mgag200_i2c_create(
 	i2c->adapter.algo_data = &i2c->bit;
 
 	i2c->bit.udelay = 10;
-	i2c->bit.timeout = 2;
+	i2c->bit.timeout = usecs_to_jiffies(2200);
 	i2c->bit.data = i2c;
 	i2c->bit.setsda		= mga_gpio_setsda;
 	i2c->bit.setscl		= mga_gpio_setscl;


