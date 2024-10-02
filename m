Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4321C9B91;
	Wed,  2 Oct 2024 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876718; cv=none; b=SqWYB1wIjZEMNZKNBe6qwzRa1TztdQYt2tkHVEPM2klQr47zAZHxZVsUfvtXyOO33gH3MwLye/Vev8QYvKaUcfhyQwyM4celMLHVUrZxmA5cII8Lj99qLXtyaZQ6RZnvSq+A1rRdM9Hv/KVlo1Yg2/akjd1pD6iyp+IOCSTeKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876718; c=relaxed/simple;
	bh=x5RDqtdJEQaokOeYxnFADRCkJ1/LTxMO1S9t8BZ3pw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVBAt5ONL2FGwtJyDMS78RDCGsI8smiMmzPMtSjAm17547JwPzJYfnqQzZKs93D2nzyCLCNSFoOchTQpRKKK4ED87GoUbfc+O9CL7sE7qgCYL5D19BoBauLTm0SUHDbvW2B0LfgSrZjRfoKFDimRPeoUGp96XPGNZhIXUbrBQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWUJ9YXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWUJ9YXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE37C4CECF;
	Wed,  2 Oct 2024 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876718;
	bh=x5RDqtdJEQaokOeYxnFADRCkJ1/LTxMO1S9t8BZ3pw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWUJ9YXk6V+6U5xAAS/X90U4ejO5ix2N0fhPwN+/qCcsQfGx75BUCs4u4QhHH9FxH
	 1mZVHY4nNRp9aKlr+KFEIj6aEhUuENgb9uj7WXVhf2b6kJMsVna8ynwPrbMp5+8t6R
	 MG9VKUfp8Tse+4159EkhbfsJlFxiWl4vPZf+mJgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 540/695] drm/amdgpu/mes12: reduce timeout
Date: Wed,  2 Oct 2024 14:58:58 +0200
Message-ID: <20241002125844.053910483@linuxfoundation.org>
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

commit 84f76408abe989809de19d02e476b044fd985adc upstream.

The firmware timeout is 2s.  Reduce the driver timeout to
2.1 seconds to avoid back pressure on queue submissions.

Fixes: 94b51a3d01ed ("drm/amdgpu/mes12: increase mes submission timeout")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index ef05a4116230..186f77813397 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -146,7 +146,7 @@ static int mes_v12_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 					    int api_status_off)
 {
 	union MESAPI__QUERY_MES_STATUS mes_status_pkt;
-	signed long timeout = 3000000; /* 3000 ms */
+	signed long timeout = 2100000; /* 2100 ms */
 	struct amdgpu_device *adev = mes->adev;
 	struct amdgpu_ring *ring = &mes->ring[pipe];
 	spinlock_t *ring_lock = &mes->ring_lock[pipe];
-- 
2.46.2



