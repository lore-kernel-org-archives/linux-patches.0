Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C9D30BF68;
	Wed, 20 May 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298005; cv=none; b=dcjqKrm6O3CwPfWgS0fEuImnhzsRsqtqx7dvS1FnPkCc3oFrixea0egl3piA0kRq+hP/pzsBoq7PGK2SLh4/lUTggz+jKyPVihkJt6REN6tvl3CBEZSCekPm5qh1yJEBgn5aTl76c8/aN8ZcfSRKK/uIsIHt5x0rTtIY4UZJBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298005; c=relaxed/simple;
	bh=Jztbxz5Qxz+J+HSHVXZVju6c2b7hLhFne9dEdRsITrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZgjwxOyFgCMfDecAdh39sl4/dmUfbGkP8Mg/7DDNLjEgTLigDjQlyInNrZskGEz3j7t69Os8dtL32xgGkYXUg8AXht4joW/RJJnm8O3cr89aUm9HzYwmRJT6KcwFZSkONkAUzA6VvvebVUbgU1kc4QF8KBI9spOr2LJDqK6UDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuWTH/Jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuWTH/Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C777E1F00898;
	Wed, 20 May 2026 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298004;
	bh=FwvVikEE/Tk01e3JRR7cImJgoG+KEA9xDoHnPxBssaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuWTH/JcuwD8y3C6Bct+06sd1WwuUE7n7pyn3TnpUXGFeMDfHb5NPoUN4Rj5z6CGL
	 GLOKx1h866UwzEcijHugXO89hqZCl8MxzDAu73/405dC0IZk0r8dpkggMZkuz5qQtg
	 bTNj1JnaEHcNGONtyJcF8qv4cAISDZz3uO2qdGQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/957] drm/msm/dsi: fix bits_per_pclk
Date: Wed, 20 May 2026 18:12:08 +0200
Message-ID: <20260520162139.857966674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 2d51cfb77daa30b10bc68c403f8ace35783d2922 ]

mipi_dsi_pixel_format_to_bpp return dst bpp not src bpp, dst bpp may
not be the uncompressed data size. use src bpc * 3 to get src bpp,
this aligns with pclk rate calculation.

Fixes: ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when programming dsi registers")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/709916/
Link: https://lore.kernel.org/r/20260307111250.105772-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 6cb634590e7a7..3efcc3f6c381c 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1048,7 +1048,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 */
 		h_total -= hdisplay;
 		if (wide_bus_enabled)
-			bits_per_pclk = mipi_dsi_pixel_format_to_bpp(msm_host->format);
+			bits_per_pclk = dsc->bits_per_component * 3;
 		else
 			bits_per_pclk = 24;
 
-- 
2.53.0



