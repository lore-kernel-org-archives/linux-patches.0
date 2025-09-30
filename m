Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462718BBAE;
	Tue, 30 Sep 2025 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245881; cv=none; b=pcSPpdD40G/H1x58LX2ABspsc0LwTLUg756ihfNNGs9eo8ZimVXoewJ5a3E2oaowSvYn+7hroIXgRWifNR1NPTIgvtFVTsPNKIqyyeYzzr8k3kkj9OQJ2OwtDXZ8wRdE/k8WV68xagdYldL6Q4enTgJeNo8lHQWLUT5+ZRcxp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245881; c=relaxed/simple;
	bh=/q2T8NxtMgljoqvxYcKGybTDgksMzNgWR/Ojj0DUoNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byEGKVRoBpEy/JxFIMXK4w+a78my5/fqJjr0bklPTgVz6e9xdddZdOXno+/5dqaMjSAb43uLNIZToB/DOgglniJUwKoYF8tDsri8o4ACVEj2iSdNy9Defyf4cLLOQHnSjeGFKb5x1zqzji4rSWdfNVZ2STG9O8TkaQV023y1PZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrB0cxGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrB0cxGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CDFC4CEF0;
	Tue, 30 Sep 2025 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245880;
	bh=/q2T8NxtMgljoqvxYcKGybTDgksMzNgWR/Ojj0DUoNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrB0cxGMGfD8azyDIiayarogdF71XHyIISVG1HjbOa9FMthr1LfoEYCrw2JK5xpvT
	 zfF0OBZC4aTVf+VpsYAKXDhDl32LA4NrcFWlrrCM+z++hFxED2d7xKDLZqTIRbnkH5
	 XbF5PJVPyDe+UA5pL7wXjn0spwHqKsW0FlaAok8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	"Carol L Soto csoto@nvidia.com" <mailto:csoto@nvidia.com>
Subject: [PATCH 6.6 77/91] drm/ast: Use msleep instead of mdelay for edid read
Date: Tue, 30 Sep 2025 16:48:16 +0200
Message-ID: <20250930143824.381701781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

[ Upstream commit c7c31f8dc54aa3c9b2c994b5f1ff7e740a654e97 ]

The busy-waiting in `mdelay()` can cause CPU stalls and kernel timeouts
during boot.

Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Carol L Soto csoto@nvidia.com<mailto:csoto@nvidia.com>
Fixes: 594e9c04b586 ("drm/ast: Create the driver for ASPEED proprietory Display-Port")
Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250917194346.2905522-1-nirmoyd@nvidia.com
[ Applied change to ast_astdp_read_edid() instead of ast_astdp_read_edid_block() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -62,7 +62,7 @@ int ast_astdp_read_edid(struct drm_devic
 			 *	  of right-click of mouse.
 			 * 2. The Delays are often longer a lot when system resume from S3/S4.
 			 */
-			mdelay(j+1);
+			msleep(j + 1);
 
 			if (!(ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xD1,
 							ASTDP_MCU_FW_EXECUTING) &&


