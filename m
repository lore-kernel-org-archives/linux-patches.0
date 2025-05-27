Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63774182D7;
	Tue, 27 May 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366205; cv=none; b=pB4dJF0K7OIQ2MaHZ7kco9hT7PU9vJGewABYEjbBDAjCCFvK8Cp7KMKqwBMfuYCaJWMj34JTIXhLjxnm66+IZVPfEfa2OEJufah2NMqeHf9hVT2y0GyBXBZaNaIuwQqYKIgqn71+K2yZauRGd/sa8Z5C/oBBUK3HBadv7wzwKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366205; c=relaxed/simple;
	bh=kEooL6bZJ4NU1A2iFrVMVaG9qB5aplxzgtIQERo3IWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Plrh/D11d9v2HqHlaufb00uw8G1fOoq4iiC5XUg3zL3j8uzxhF9TmYVpwsW0UBa3Rodftm8mr1BF33lVrOk3G2by3eusMtWeSdJe6LegEwzdLc4qqW12WZVovywhyKYnsesyHTgix1mfqlXNAY8N9hYKPR6B5zwmpApn+u3GhSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PByjsERD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PByjsERD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF7C4CEE9;
	Tue, 27 May 2025 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366205;
	bh=kEooL6bZJ4NU1A2iFrVMVaG9qB5aplxzgtIQERo3IWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PByjsERDtZKyq0ZvmOvzlhnv91hQvMIR3uaX/eFS72EO82Xqoa0yo8Y55jb9Vcioz
	 wQYb/bL1qy08PAvDA2T904vdaEmf0VIFsnVbmS785/T+ZkI3S+NKNjhPdUhYadj9Uq
	 CfySOlteUAQABrEI6rZI+6H4fAndd/BGvy7QUzdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviwanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 621/626] drm/amdkfd: Correct F8_MODE for gfx950
Date: Tue, 27 May 2025 18:28:34 +0200
Message-ID: <20250527162510.227778604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

commit 0c7e053448945e5a4379dc4396c762d7422b11ca upstream.

Correct F8_MODE setting for gfx950 that was removed

Fixes: 61972cd93af7 ("drm/amdkfd: Set per-process flags only once for gfx9/10/11/12")
Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviwanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
@@ -69,8 +69,7 @@ static bool set_cache_memory_policy_v9(s
 		qpd->sh_mem_config |= 1 << SH_MEM_CONFIG__RETRY_DISABLE__SHIFT;
 
 	if (KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 3) ||
-		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4) ||
-		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 5, 0))
+		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4))
 		qpd->sh_mem_config |= (1 << SH_MEM_CONFIG__F8_MODE__SHIFT);
 
 	qpd->sh_mem_ape1_limit = 0;


