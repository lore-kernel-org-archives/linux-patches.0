Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774790;
	b=QPPP+1XNmpFGaVIp3W+UtppNbB9DdUhgPiqjWPbxTRZKpMqr15M0b7abizweMVPJGAk2
	 AI0rVuvP6FfWjmoJmRBBF141xUnuwiWpSdp6v/3yCImrptI4G20+3VMBvq41De524w27b
	 0lVbOaObhkBKJxIUDfMwHUS89jTGxlrDGBjhrUeSefX5p0s70gdFV6V2t85SLNzqemD+d
	 zqloF02AaU/jSR9XwY3jOIbjO1ILOzBLznj+4c7qlnYWlUTjQgQNIPr/TAWmfFUfil1c2
	 q7eGK7FKmt8X0LE0l0DteTyxWjFDxRHe6yPnxbapTaHAwpExbNksLDzTetrr3aYap+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uQqJxF5GnPWbeBcGHfUxpp75olWaA3MsJAcgfj+EQu0=;
	b=n8Iyu4vT2+zsDAU+ylmzEJkWPrm96/R5qpqIIjL+Y+ICnAMt4iubrSvQVjsHlOCQyRh9
	 xUQ2v6yU8/Qe0/8pPjkLwMFIFQ1SdzXTGEXYv57WLFKmuA9S33Yd/URvOYXMzQxm5vMYV
	 yLbF5floIymzsxUULGMd7cS7jWnIduFJYr3EXufv9q+xLd6VsI7bN9ILGgI8EocbAovFc
	 F799mqB5jYeml0QjEVDz114IejUD2m5R6WZ0Ij0YB+vGjRMNzGzzerx0TvECh39AgHUzl
	 MSDUNhlWk9rzKujdxC2zoIQqttY5XMsw8AIi3RWtnX9nda/1BpI1BxvOSJn1VdSgUvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EEbTHfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8154606A31A;
	Fri, 23 Oct 2026 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EEbTHfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBC91F01825;
	Fri, 23 Oct 2026 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774789;
	bh=uQqJxF5GnPWbeBcGHfUxpp75olWaA3MsJAcgfj+EQu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EEbTHfr/LwvxmsVm4t23IiC58dtv3QSfKleIXz9OfbLKNZjl2fy0Kglevokqfdtn
	 +MM7scmCX871MUtmSqOCng6K6+1D1+IseunCBcJyoLvweVtkiUFGt+pkJgi+xTlPnP
	 +nnhPjhKGkktlKGraLvTqDi8TxPO5LhBVRp2eXu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 158/242] drm/amdgpu: keep the eviction fence until the last handle is closed
Date: Fri, 23 Oct 2026 18:40:00 +0200
Message-ID: <20261023163717.519828775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 3c44cbcec5eb370713bbd2c315ed7c34d8ccec2b upstream.

amdgpu_gem_object_close() detaches the user queue eviction fence from
the BO before it checks bo_va->ref_count, so closing any handle of a BO
removes the fence, even when the file still has another handle to the
BO and the bo_va with its GPU mappings stays. The BO can then be evicted
without suspending the user queues of the file, which keep accessing it
through mappings that are only marked for update.

Seen on navi31 with a SDMA user queue: a BO opened twice in the same
file (GEM_FLINK + GEM_OPEN) loses its eviction fence when the second
handle is closed (traced attach/detach of the fence):

  attach bo=ffff8c78a6c84c00
  GEM_CLOSE handle=7
  detach bo=ffff8c78a6c84c00

while handle 6 and the mapping are still in use.

Only detach the fence when the last reference to the bo_va goes away,
matching amdgpu_gem_object_open(), which attaches it only when the
bo_va is created. With this the fence stays until the file is closed.

Fixes: 31f7efcdca4d ("drm/amdgpu: enable eviction fence")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8387982f03d4026b7dc11b0b5e3118298eee4d6a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -337,11 +337,14 @@ static void amdgpu_gem_object_close(stru
 			goto out_unlock;
 	}
 
+	bo_va = amdgpu_vm_bo_find(vm, bo);
+	/* the fence is attached once per bo_va, so keep it for other handles */
+	if (bo_va && --bo_va->ref_count)
+		goto out_unlock;
+
 	if (!amdgpu_vm_is_bo_always_valid(vm, bo))
 		amdgpu_evf_mgr_detach_fence(&fpriv->evf_mgr, bo);
-
-	bo_va = amdgpu_vm_bo_find(vm, bo);
-	if (!bo_va || --bo_va->ref_count)
+	if (!bo_va)
 		goto out_unlock;
 
 	amdgpu_vm_bo_del(adev, bo_va);


