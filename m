Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212848;
	b=RrAL5BVq0u/Iy6hAY2TtzsNYf1FpmORg416t/g163ZYpxSkCA87Y9crfJsiSx9zCA/jk
	 7y6GilblXk5mpR0suRF5gviHg7L4mcQIp+9+pmrHsyYKCSJa7FT09x9BQFu1X4EtEubLK
	 36rYJwtvLaAusbUauOnyNuEb5MmI0s3gOZ9xi9+N8mBrcnL3a+Fufvag8vy/ZmhGhKCPJ
	 r5M+Dim6q+QxSX6wYeuh+8QYkv67+CuniDRWngXf4xjeSHQQRbGUHKXyvCdcQU6sHpMBO
	 oT3BYrJ7SRNi2Fu5UvTI+xz6ws45yNJ/No1z5pwBvdDCxnOj7R3gQ/4e0gmMciAFMWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0vWPb8f/IQqfhYg8qkQ99ez1zBKY3ztW86FzQYa3pk=;
	b=4cZU/RPLRSG7umQZlR1NzorH7v3sX5Pboi2hKcZykbQAlYLf4ZgTfLs3ohMc5tMks3SP
	 P1uL9C1/ibA9Q2KpTM5P251MxYU2WVCh9Q1zgqh1E9+pSJ1kjv1EJhRmIm+P6oq3z1acx
	 Xe7GC+YfXUXIE3cl+XTY39V9cN2aHw9MVO4CRPbfe23tvZ/eQs1TIZJnebri/3Y+WNS5y
	 4GylgdcP61oYeq0nXplYfMxkT1j3jAvNAIoJ9AQ0XlACsYNd/COhQO8/2kW1yPrJLo2zC
	 b840xBA5TwvQiFfI5xLc1vQmY1n0yNAAHwHuj33Y++LIvdBDBcOL4qeTy8GKFTXf/ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSqIv8oJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C1606A31D;
	Wed, 28 Oct 2026 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSqIv8oJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FF51F01825;
	Wed, 28 Oct 2026 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212848;
	bh=o0vWPb8f/IQqfhYg8qkQ99ez1zBKY3ztW86FzQYa3pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSqIv8oJ7H153nP6yhHfxFAirGG+wQAcDh3Ek+LPKFtqWaGM3AmLzDWy+QI5nVRt0
	 74096i1sLwJnbBlImmEI4qlB2/lciRQCFkgPVtGwV/sDHwQeRk2Z5aNw5I94QGi4KN
	 vt+sSP14Ppqp6hUA1GQ1n1Ozfy/+J5RvhqptY+a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0255/1887] drm/amdgpu: fix IP instance memory leak on kobject add failure
Date: Wed, 28 Oct 2026 17:39:11 +0100
Message-ID: <20261028170505.033628063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f5a5add3605935163dd0f75749b6a7869e9765af upstream.

amdgpu_discovery_sysfs_ips() allocates ip_hw_instance with
kzalloc_flex() and initializes its embedded kobject before calling
kobject_add().

If kobject_add() fails, the return value is ignored and execution
continues without dropping the initial kobject reference. The failed
kobject is not retained in the kset list, so the normal sysfs teardown
path cannot find it. As a result, ip_hw_instance_release() is never
called and the ip_hw_instance allocation is leaked.

Call kobject_put() when kobject_add() fails so the initial reference is
dropped and ip_hw_instance_release() can free the allocation. Keep the
existing best-effort sysfs behavior by continuing with the remaining IP
entries after the failed registration.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: a6c40b178092 ("drm/amdgpu: Show IP discovery in sysfs")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5c75fbcca8af1096d8d9415b91d8ea6212c22ee1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -903,6 +903,8 @@ static int amdgpu_discovery_sysfs_ips(st
 			ip_hw_instance->kobj.kset = &ip_hw_id->hw_id_kset;
 			res = kobject_add(&ip_hw_instance->kobj, NULL,
 					  "%d", ip_hw_instance->num_instance);
+			if (res)
+				kobject_put(&ip_hw_instance->kobj);
 next_ip:
 			ip_offset += struct_size(ip, base_address, ip->num_base_address);
 		}


