Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DB1CF5FB;
	Wed,  2 Oct 2024 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876721; cv=none; b=nzLBl5Nk81bk6/PL1xwliLNBLEJU0glQD0IwvNrIg38ZFfqb/54HZeEEFC9IyYYdMdPGAMze6OSVu5cdIBgxBTKz6hz4Z2JF3EDeDluDWMWmCnG3jiutoz9W1CtXUyRrNpi6D4RZXUQSkkt7El4bo9QRgVv42UX5y2ip6e3xU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876721; c=relaxed/simple;
	bh=Q/0xjOVq8+c+g0kI61+rQQKqWKDB9Wj/h8aI8Rv4s+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTB9kv8CtqH5R/HEN2sRCT57aDcgjUEfhXP1RjcHdC30SmfYi7VZuWZ/hMh5qq6ZABdehrSrWHwtmTBTOemVOJ4UBrnj6JcRm7CPEuSOsydMolEC5aSEHl/zmYNZBpQdKwGmlzSdBrRjs4X61Fbtp3zmEh8ayhMYWYUGqBEhfr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhjK9Nqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhjK9Nqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9513C4CEC2;
	Wed,  2 Oct 2024 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876721;
	bh=Q/0xjOVq8+c+g0kI61+rQQKqWKDB9Wj/h8aI8Rv4s+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhjK9Nqu7F2WWoZ/jHQEn45MFv+dyg4GwTndcnFpsCBBCODdaDeRUEI2q0EhcckTX
	 5tdwjOkvVzTpmh/vh53QC5ZehsGq/0e4QefoXAXMYwFHCLZAVGMCbKaUGOA+2LeE9W
	 qt987jzOXrTdGRbXnQCCJK1zpWoY8Sf2Vt5yYLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 541/695] drm/amdgpu/mes11: reduce timeout
Date: Wed,  2 Oct 2024 14:58:59 +0200
Message-ID: <20241002125844.093435340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 856265caa94a3c78feaa23ec1acd799fe1989201 upstream.

The firmware timeout is 2s.  Reduce the driver timeout to
2.1 seconds to avoid back pressure on queue submissions.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3627
Fixes: f7c161a4c250 ("drm/amdgpu: increase mes submission timeout")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -160,7 +160,7 @@ static int mes_v11_0_submit_pkt_and_poll
 						    int api_status_off)
 {
 	union MESAPI__QUERY_MES_STATUS mes_status_pkt;
-	signed long timeout = 3000000; /* 3000 ms */
+	signed long timeout = 2100000; /* 2100 ms */
 	struct amdgpu_device *adev = mes->adev;
 	struct amdgpu_ring *ring = &mes->ring[0];
 	struct MES_API_STATUS *api_status;


