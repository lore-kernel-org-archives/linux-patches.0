Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5D13B9618;
	Wed, 21 Jan 2026 18:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020439; cv=none; b=hxcohd6GFQUoEadaV96ug/nf73VbCbfwNTkMTQCNJyY95SX4q4o/iFi7ZciFqA9WQtQky1NKuYvhLKFEirgYETqbYR2wFVF5ADqTjozU5cm0W3Gb/wlrTNrtVBORBIT/iqPScmoRA7+JyNeCc+O8QDDH8vgrxjFiSemc5sxvPNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020439; c=relaxed/simple;
	bh=lrNbrjL/97OPaADqHnBGgpTBk8iC/WA6/QFf66zPYnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdubThl8wDwgc2yp0zWd8SCwSKoW6vbhmdz6R4JLMGx8n9JmtK+/CbQV384XY58TxMbmd3MyrWYavRceYG5Pim450SIHdLHM5Iat4JmHyjaq1vu9fXLKFqOM/HeLCsSm2JDkJxA3gAaJrsLVVcXE0hOMrR0CT/5Q2x3ZS3TX5Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZ7DccLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZ7DccLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DE4C4CEF1;
	Wed, 21 Jan 2026 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020439;
	bh=lrNbrjL/97OPaADqHnBGgpTBk8iC/WA6/QFf66zPYnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZ7DccLs89aSWRU4FbvMsuTgKVrvhlA1WbfUlHzWjnsHOkaLoZWiFITIp6JNMgZA2
	 MpoaOca0I3oudTiBf9lBY1I0UiYbgv5C24yx9cXHopjBEETpy1t0u5qYDsEuTHE/ot
	 jCS/suz8W2aTODfQ8gX7zFmAq4m4VsFYteDUavc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.18 158/198] drm/sysfb: Remove duplicate declarations
Date: Wed, 21 Jan 2026 19:16:26 +0100
Message-ID: <20260121181424.237429961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit b91a565ed14fcf900b4d95e86882b4b763860986 upstream.

Commit 6046b49bafff ("drm/sysfb: Share helpers for integer validation")
and commit e8c086880b2b ("drm/sysfb: Share helpers for screen_info
validation") added duplicate function declarations. Remove the latter
ones.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: e8c086880b2b ("drm/sysfb: Share helpers for screen_info validation")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260108145058.56943-7-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/drm_sysfb_helper.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/sysfb/drm_sysfb_helper.h
+++ b/drivers/gpu/drm/sysfb/drm_sysfb_helper.h
@@ -48,15 +48,6 @@ const struct drm_format_info *drm_sysfb_
 #endif
 
 /*
- * Input parsing
- */
-
-int drm_sysfb_get_validated_int(struct drm_device *dev, const char *name,
-				u64 value, u32 max);
-int drm_sysfb_get_validated_int0(struct drm_device *dev, const char *name,
-				 u64 value, u32 max);
-
-/*
  * Display modes
  */
 


