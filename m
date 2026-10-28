Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212450;
	b=cEAP/5hzG2juwWl+kUYD7mBvqKPpVhYPTAU5vbEAd7QxweTOslXdLoPgbrdWB+/HTuDe
	 T+TG3VXCfmxZmsfsSaWCFNgELu8JfcKb91LRgd+kldeye89m2o/0DCbw0S06dHb68J79U
	 VzWiNFl1PWOjzCfebMjxwLkyg2c6zzQ3QH3Y0aKmf0xkCj9PU7+QNansRH9gtjtMG0YKQ
	 St12jvvnfe8aiGo+PpqgJhL3gyraANe9D6o+8SUH52rXYGHN/r6mTjQhSnlq99p/jlRuT
	 zr8bbx5on3juS8PP7T2sl6PVFf+EehoDTXLe0QtKslZ0bz/t6ZTd9GEB5KAkjurlSVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emCJPX04NX4ewAnlx8q+OK5pF+dxqZcw3lVsjTlB43s=;
	b=ZeYPx/GcpX6En3m1TFPKWO5eZFOFQNdu8TRRLrm8qqPk8kAYZRie6XNGNEFV9T4eqbTM
	 PHQYXjpNp25t6uky9GY5qzc/aj4TAee0CW4LzV0fqD//7I9k/+HKZVf8SEF7MB8LEgzCA
	 RjkbD2BRmN3JE3zTVD17dXuZpVv9OqaYttdyv9bZeoPTxvaj2LO5kwfh8ZAWdyizZ8aI2
	 LVHGGWdIFNgKWxuTXhPZqlkZNXXdtWLBc/dFaJ4HGl0ZVepFa9siwBkN5d/HZsFZocGRJ
	 pJELJW81431dfi46T3IMnm29daKEZ/lgYPh/5vyr6U/EFegLE44t0ejLZDjYSiuAESw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPpMj+qg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A28606A320;
	Wed, 28 Oct 2026 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPpMj+qg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DB91F01828;
	Wed, 28 Oct 2026 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212450;
	bh=emCJPX04NX4ewAnlx8q+OK5pF+dxqZcw3lVsjTlB43s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPpMj+qgk3LYpWsSOwCPM3tSXz7KjfAvNVDqLG2CIXaVPdH68BU6sfEdlVbm1WWrR
	 vyo3NwfA1quhOFEXylHtSDrRxn3Pv8TttmFP8w4CKYh6fPV1CvruZsej+Cx5N5NNDr
	 +ysSj7QEMyOjm53l9G/8eeoEk/idCXX1x+a3qnHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0115/1887] drm/sysfb: simpledrm: Improve stride validation
Date: Wed, 28 Oct 2026 17:36:51 +0100
Message-ID: <20261028170501.852639030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit df6533f11688aa30be3bb883c7637f4ffdbb7cbd ]

Validate the computed stride against the maximum value INT_MAX.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 7bfa5c7b28d6 ("drm/simpledrm: Compute linestride with drm_format_info_min_pitch()")
Cc: <stable@vger.kernel.org> # v6.1+
Link: https://patch.msgid.link/20260625094509.157581-5-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 18489779fb8aa..4b5ccbb13ecfe 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -693,9 +693,15 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 		return ERR_PTR(-ENODEV);
 	}
 	if (!stride) {
-		stride = drm_format_info_min_pitch(format, 0, width);
-		if (drm_WARN_ON(dev, !stride))
+		u64 pitch = drm_format_info_min_pitch(format, 0, width);
+
+		if (drm_WARN_ON(dev, !pitch)) {
+			return ERR_PTR(-EINVAL); /* driver bug */
+		} else if (pitch > INT_MAX) {
+			drm_warn(dev, "stride of %llu exceeds maximum\n", pitch);
 			return ERR_PTR(-EINVAL);
+		}
+		stride = pitch;
 	}
 
 	sdev->mode = simpledrm_mode(width, height);
-- 
2.53.0



