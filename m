Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652E52E9EBC;
	Tue, 30 Sep 2025 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244809; cv=none; b=NE45IMq+GC5HqIUfIsDqIQvPOwRReV1axSl2ujXu4zskV1azUOLKeKgjGAOyShLzhiIbT58InCk/qRkKKhiG1CLCySg/HPIPvXj4L3ETKapvwsz5LbHONRfbeKtDdUvt9HvceGzpXVDusdQKCG9NiHRCfccVWogayhjwrFwHVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244809; c=relaxed/simple;
	bh=ld12mXPsRGA40jH2s9uM6ZyFjAwurvHbaWd7pI9mx+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyaXYYQlFQ8tk0C931DWxJ85kBRDEhLGc/DmfmaCR4ZcBVCNo38hk/zG02OeuItukmPGQpJaxIkCqxrdqc0WW4B6vQ6KYTkE8ywm2lHpe+duRiO8oK6YgIZy35nCj9g+oSsNOMcUmCqVoG/Mme45hBskUirtEoFZhSIjk6ar63Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtZ7hV3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtZ7hV3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF20C4CEF0;
	Tue, 30 Sep 2025 15:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244809;
	bh=ld12mXPsRGA40jH2s9uM6ZyFjAwurvHbaWd7pI9mx+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtZ7hV3uMdWUQCcXbxt1pB6WWmJwRQ0sTgcch8Ouq4+Uv/1PyvEYTVIynNJ2UguA/
	 GJ2ylFscjlSTc5x9z4JOerT3GwsaGL4iG0le1FumoZ2fPp06TRL/iwCuR9GPKInwtf
	 2w2PWSillwTC4sJ2YjfMtfHSZsz7jG7oanuQxbMk=
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
	"Carol L Soto csoto@nvidia.com" <mailto:csoto@nvidia.com>
Subject: [PATCH 6.16 119/143] drm/ast: Use msleep instead of mdelay for edid read
Date: Tue, 30 Sep 2025 16:47:23 +0200
Message-ID: <20250930143835.972719210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

commit c7c31f8dc54aa3c9b2c994b5f1ff7e740a654e97 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -134,7 +134,7 @@ static int ast_astdp_read_edid_block(voi
 			 * 3. The Delays are often longer a lot when system resume from S3/S4.
 			 */
 			if (j)
-				mdelay(j + 1);
+				msleep(j + 1);
 
 			/* Wait for EDID offset to show up in mirror register */
 			vgacrd7 = ast_get_index_reg(ast, AST_IO_VGACRI, 0xd7);


