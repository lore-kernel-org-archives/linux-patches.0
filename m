Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB36120E334;
	Tue, 30 Sep 2025 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246186; cv=none; b=oGwENFvntiSdTKH2dlmGpfMQZYnN0QrikbI5V2smZXLO+fea3K5UfPjS8zNe1r0iwpkU4TJy2KdtvkNxtSx1xaJTlDOIN901BucHng4xCSkZIs7UEc5Xg3Z0EgNqQKi55Y61441z7IL1f8OGaXq8C+geewh+gjHSDv0E2XA/xQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246186; c=relaxed/simple;
	bh=TPBBBi1KlVV/ItwZrSCPVAjj4XUzxT00jhIFPFkcZ3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya4+3IlywT0FP+YmEM8NQa+3ucgiNOrRkn5Q6XH+RJ35igyzUyV7xM4DGv7JNrgsVsdxBD+mCTljr3KE40oVU1Q2Y88FHwGPelVqmqgpePYGRUszxqyZMfyiVQ6UDeQAZk21SGDGoQnzbcqUmjR8pvtgJ1HHyCBOFprg6i2OV3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vngo3TiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vngo3TiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4327AC4CEF0;
	Tue, 30 Sep 2025 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246186;
	bh=TPBBBi1KlVV/ItwZrSCPVAjj4XUzxT00jhIFPFkcZ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vngo3TiR1K33Sj40fXzcGTvF3mZyF6LgbO6ueq7vOd47nknTI+M7axMz8Fy6KSjdf
	 ZYprwILIdy/zoX85LyTxMZz3B57z46oCZ0gCFy1y5eZmXFnF66CzV4vRWfJ+1vjlis
	 ZgnDh0ZK9717hWTqfkhnUWUFxboQQQIdD9xjCebw=
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
Subject: [PATCH 6.12 80/89] drm/ast: Use msleep instead of mdelay for edid read
Date: Tue, 30 Sep 2025 16:48:34 +0200
Message-ID: <20250930143825.205343311@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,7 +79,7 @@ static int ast_astdp_read_edid_block(voi
 			 * 3. The Delays are often longer a lot when system resume from S3/S4.
 			 */
 			if (j)
-				mdelay(j + 1);
+				msleep(j + 1);
 
 			/* Wait for EDID offset to show up in mirror register */
 			vgacrd7 = ast_get_index_reg(ast, AST_IO_VGACRI, 0xd7);


