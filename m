Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A8C2D023;
	Mon, 10 Mar 2025 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629339; cv=none; b=VISp2yGNWfSi9Hx4xSjrtJPBkzW0eLuVEc6TmgfNj0ZDNdRmLcdCDdVmrHyE/sz+eNP//sFajawHVSp5FISikDPKcakd+iS+gOTNtUdMBm89MDXSkelZNlOD6A4gxrX6j+cGIAHDDYEYiCwzh9uURgql478FqccbKeYQWKNdVFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629339; c=relaxed/simple;
	bh=y17FguLoJ4Zldy7YEEvI8hao/tMVnmCfMfeeDAvZbFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaX7S5hrHHd4v2dbQhrfYPcJGdyDNgaGTEtD3Ige7XC7h007b7He+JoL+Oztmm6w0Xbys4h3EVJqSw7dMpSg00VIsyFdTN9tmIZ1Byj3gMGfzaTg1UF8KTiZxeyMCzipECSAmKcNCpWsH2av3JzDXZhjPBqSAjhxienA7reWVPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlfE6dTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlfE6dTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C611C4CEE5;
	Mon, 10 Mar 2025 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629339;
	bh=y17FguLoJ4Zldy7YEEvI8hao/tMVnmCfMfeeDAvZbFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlfE6dTVlAh9SNYEZojgf1XmPuI1a6Ta8WjXMPPOW6cF48ti5KX9C5bap/xQMuWK7
	 4eLWPkIp3YRjMDXmttHd5OCiE7KJ/mjWdaJYniv8L+vDiGiyrpeNTmcOzxNbZz2uxo
	 ezr0iAGKCLmYdn6MLDyMgli/mLTbnksSjQ7T9gs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 261/620] drm/amd/pm: Mark MM activity as unsupported
Date: Mon, 10 Mar 2025 18:01:47 +0100
Message-ID: <20250310170555.927975745@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1711,7 +1711,6 @@ static ssize_t aldebaran_get_gpu_metrics
 
 	gpu_metrics->average_gfx_activity = metrics.AverageGfxActivity;
 	gpu_metrics->average_umc_activity = metrics.AverageUclkActivity;
-	gpu_metrics->average_mm_activity = 0;
 
 	/* Valid power data is available only from primary die */
 	if (aldebaran_is_primary(smu)) {


