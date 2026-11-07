Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062873;
	b=gO0LMExyLaurtvQSzRIQkNs9D2rhn6v2pfLHHHeuVfUtAU5MYTLbkTAVrM0OvbeI2uDV
	 yYTWpddJE/aaQRUx5+2kLTXjbHriEEN+zZMroOKkucMqQQUhhoUJfKA9CVGs1WziGCYqT
	 eY5bn1t7SyBwolEUSO2r8Hhxx6CEuOOP5r0/C4OgotGcSadsAkLFT0tFLeX0RqW76q9g7
	 NEL8o7Z1uqhBEXt7AqoLbEszxOQkHxpGjbBPqQuQOWWDXdXelHAIajpxOz7LN5I4I3Rwr
	 0LAhYk+EMFLYqpDF7HgdNbqzDKSPixWCWl0DTW5oTeDPTURrgVuvQtOezH02BpXegXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pbq+gh+2s8PSuMr+1iFDlit4CKg8xZiFkZyIHosWMsg=;
	b=xw5E0FjfROTDP7C9vMfSuCPLw2p25TtX6yJ4s1CpBlhJQE4f6Z0qIQl+0hoWS3xc29fB
	 lWIIOVMEh4WQcdzFAmeY2VHk6JRGkucweSa3uPpOv92v2KUA8dWm/OC2Tp6y5xWRN7C+e
	 duerN972m0j3lhKjxI8WKHuRPCXepykl6Y/N/yvcBY7Sgo3fmi3y1Q9Po35y+RpOfBodv
	 RpwUabk4Y/kleQbjonrq6stkOJqAZ+muOoHW3XslhOx7R1JkDdEvYLy5Pv50uymhCMdi7
	 LFKJ3qs7crmh3+DN6GG1V9OaxqJixZpzWzU3pf0nwBNjyaD3IldbMFhfn4coAy2CNVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WTycPMw/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BECC606A326;
	Sat,  7 Nov 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WTycPMw/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9051F0089F;
	Sat,  7 Nov 2026 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062873;
	bh=pbq+gh+2s8PSuMr+1iFDlit4CKg8xZiFkZyIHosWMsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTycPMw/y5jHErUFM28kOb+yMZogWBg3mKdQfn6fu8aPk3qMpsTJNS6auejgLsIe2
	 2XiivC0nUUi08GywzN+ZbGFCnYVqbG1OlfGLJZgXHDCElX6yIeFuXeMV08yg/pQpX0
	 7+poMdZC7AeKHIS+D1r62RMxMry0Y66Jfw6iH3kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/869] drm/panic: Do not use un-escaped URL as format string
Date: Sat,  7 Nov 2026 08:47:18 -0500
Message-ID: <20261107134857.595959615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6596aae25585b183ebd528206bde6f12efaf8db1 ]

Replace the direct use of DRM_PANIC_SCREEN_QR_CODE_URL in snprintf()
with a %s conversion specifier. Avoids a possible vulnerabilty from
a crafted URL string.

As the attacker needs to control the kernel at the Kconfig level, the
potential for an exploit is likely low.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.12+
Link: https://patch.msgid.link/20260911124540.279841-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index d4b6ea42db0fe..b95d869257a84 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -662,7 +662,8 @@ static int drm_panic_get_qr_code_url(u8 **qr_image)
 	char *kmsg;
 	int max_qr_data_size, url_len;
 
-	url_len = snprintf(url, sizeof(url), CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL "?a=%s&v=%s&z=",
+	url_len = snprintf(url, sizeof(url), "%s?a=%s&v=%s&z=",
+			   CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL,
 			   utsname()->machine, utsname()->release);
 
 	max_qr_data_size = drm_panic_qr_max_data_size(panic_qr_version, url_len);
-- 
2.53.0



