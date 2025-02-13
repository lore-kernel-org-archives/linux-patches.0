Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BBC26B0B1;
	Thu, 13 Feb 2025 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459239; cv=none; b=J3HUloBLiwooUYw8oSKHPLT1L6nCHXlcBUa3rTloFkVOlcvda9fKDEhHFMyySAD4KOIN7ncyd6gW0OcRvU5VH485mDrl4tQaEWMdAavjqvljEAH/eaQbQ5yuyO4/og4gZh4kF+vbYgTVbaV4sGLRL3i3JJOSskjqXLYl0DfjQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459239; c=relaxed/simple;
	bh=X2QUuaV2Uzps2NdJ/cAjhsemlEsLtlAB0/kLS1hLTBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWnL4LJOgVDp5cdDx3V9dxC03TGyrwZ69cFjlMmy8bHnD0GBuowi+5DSPBSsXZcAmy6pJH0f3MQ8LnSBACkBw9G9K9QHqaXZl8oamHcJ4LaREL0GiIm6ZSOpN535ikCgvBZgkHxMu/dNmOQvCURNpjAUJym1cOPUgIgnJ4SITkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe934E/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe934E/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1CCC4AF0B;
	Thu, 13 Feb 2025 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459239;
	bh=X2QUuaV2Uzps2NdJ/cAjhsemlEsLtlAB0/kLS1hLTBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe934E/O2WoB7s0EzbpRx8yOHMARCe3u4ivz8RhAP939e1dDAQkmyF+ifoWj4IcPk
	 fE4m524a+c28bAZP5Tecx30GluE3qzHPNXs4NwI5+8WQ/xqYQBQHb1Ct7rnsO5BkQG
	 9BCK0LxVfHbKpSDzdrt76wh2imHLjqmLQWbPl+Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 174/443] drm/amd/pm: Mark MM activity as unsupported
Date: Thu, 13 Feb 2025 15:25:39 +0100
Message-ID: <20250213142447.319677869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 819bf6662b93a5a8b0c396d2c7e7fab6264c9808 upstream.

Aldebaran doesn't support querying MM activity percentage. Keep the
field as 0xFFs to mark it as unsupported.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1732,7 +1732,6 @@ static ssize_t aldebaran_get_gpu_metrics
 
 	gpu_metrics->average_gfx_activity = metrics.AverageGfxActivity;
 	gpu_metrics->average_umc_activity = metrics.AverageUclkActivity;
-	gpu_metrics->average_mm_activity = 0;
 
 	/* Valid power data is available only from primary die */
 	if (aldebaran_is_primary(smu)) {


