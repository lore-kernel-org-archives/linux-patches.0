Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEF6173;
	Tue, 30 Sep 2025 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245628; cv=none; b=NRufUF+PNvNBvor/vqCCOuBDFaYn6SFvxUp+vpfbbetUy+f9CC9JN8bCC0esLdZhFjaZnexbKr54GJD47JbWO1ScvduAdViAZRhIfJouene/leJdGIqOf0zaqTdIrjh+LBwegLTrV0sfTgu4Sr3/n/7AHBFdGgc3AI8AxHEI8Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245628; c=relaxed/simple;
	bh=8/3DhC5onrZs2Umkjp8b9fSWM/L4JsvuXQeNMFDvABI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMdpDUZQra06yR9SbF0h+rXKuHdCtYtZA9bJWD/Nhp/5yzl5Bn93LTOjrL5QtDzMfqoCe/U7UG3jLXZMtU45mZ9Acfie+tCIc1lk/QskGbKpYHr05L0xxLtT2Xx042c76uCD3sUL2JE6jlZwvvv0ZywuxdGgoehE5WX54BUO67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNz5AnRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNz5AnRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082E6C4CEF0;
	Tue, 30 Sep 2025 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245628;
	bh=8/3DhC5onrZs2Umkjp8b9fSWM/L4JsvuXQeNMFDvABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNz5AnRNP5KyUjEJtoR2V7ToP1bFRhtyBdd3gURj0tou0qGN2LHhYHeinjKVgqcmM
	 Y4Kjl5uO++QZeAQPJq7Fh11+Gsurdu46UaRNFox5ymiR74k6+MBIP+bxweySvtrUOh
	 un8vLg88vr3Q6aKrOL+60D9I51sTPz/GcYnWi9sk=
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
Subject: [PATCH 6.1 65/73] drm/ast: Use msleep instead of mdelay for edid read
Date: Tue, 30 Sep 2025 16:48:09 +0200
Message-ID: <20250930143823.368711315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -51,7 +51,7 @@ int ast_astdp_read_edid(struct drm_devic
 			 *	  of right-click of mouse.
 			 * 2. The Delays are often longer a lot when system resume from S3/S4.
 			 */
-			mdelay(j+1);
+			msleep(j + 1);
 
 			if (!(ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xD1,
 							ASTDP_MCU_FW_EXECUTING) &&


