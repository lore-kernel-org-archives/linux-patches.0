Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B793F1F8697;
	Tue, 17 Dec 2024 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456457; cv=none; b=kc139fbXdfxvY1lyrBZuVVropUhB6IhVJLnusf+v3KTyAhJkuiB+fgmEBN2S0dpXe6NRz+NxlbEo2YhUvCxt3ITFwNpKn0DpA3h9UvVcdEmn/TTDI2KV0S+Glz9asZZLtKase/Or7FI3Riab+Ijc2m36bbwMlqhkgkGwbShe5E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456457; c=relaxed/simple;
	bh=8vwmemZ0C7lx5EAZfRWHX5eFJDFetATRKMogKPCQPec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7AfWBtkexODXmrrfNYrPO2TuK2qyu5nzDpWEj3t5A1g2Hy8/PyQ5EwezRp7UeFGUJKBdgHZk+a810dVSk953bcxy1Qcu3CE9EUs22JBqjyUQt2HWTWiBavUa6wBTEJFC4KVIpQCy3DLiew5hP5Fvyownk882uMPyZSw7GIeGDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa2fj/gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa2fj/gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB83C4CED3;
	Tue, 17 Dec 2024 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456457;
	bh=8vwmemZ0C7lx5EAZfRWHX5eFJDFetATRKMogKPCQPec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa2fj/gk05xV5+tyB+VUAGbm7XQ7TrNprL/y4Ct6J2J39dsue6gK5Ls/Yqk25i+QV
	 Mh5eoicSLW4AM1hi3SnmQt4tvoLmV/3Vl6go3M3qcpGZ+2657h7BJW5HHa44wwwmq/
	 J0yGFGJv3uftdFIIQ40t0iAhFiat7uY0p53HBXlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	David Belanger <david.belanger@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 066/172] drm/amdkfd: hard-code MALL cacheline size for gfx11, gfx12
Date: Tue, 17 Dec 2024 18:07:02 +0100
Message-ID: <20241217170549.016335561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit d50bf3f0fab636574c163ba8b5863e12b1ed19bd upstream.

This information is not available in ip discovery table.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: David Belanger <david.belanger@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1503,7 +1503,7 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.max_cu_per_sh;
-		pcache_info[i].cache_line_size = 0;
+		pcache_info[i].cache_line_size = 64;
 		i++;
 	}
 	return i;


