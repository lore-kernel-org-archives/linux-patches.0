Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829418;
	b=BPFk78CcuT74jYO48eprzsgarnqsBO2szILvc0OsX9dhypViCyc69Jw9Mv0fxMbyDYp8
	 vHEgaDXnfa+t2py1lBvZ4aPcVbihMpuuKsMsX/9fKeA3PnYvZHSsGk/S9BHxebBYqOf/X
	 n1wfmuA8l0VZt0ZhFFyOOAwzDWCA+T7C8YdgqM19EkxnPQ1GJSOnfRrDwZ9gqDpsQ1V0a
	 Uy0b6v8v0wNSUHp2QubJGxcldx8eVQxEk+7UXItbNhQHR5VqEKnc38dFj7eyu/YJmR2/e
	 KO5x9dhy+92VY9nRUi3qICAiDv35IdmyL0vbOU2QUtCxuqdl3HRXj4+qlYpHpTmetrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RAHpEgUj2su69iAuj+Au46CBcCjTqNh0hL51WoMUNQ=;
	b=WqTtUz03KA+0MuIuJ+ziQ/+Y9xaJ/GsTIG51xS4Cdju/quYRK350MNfl2IP5GdHiYnov
	 1JracMD0Qu4LS3fygNWn3SbRUxZAbwT90xJGUPtJtVkT1Vf34WLAV5CcRob6SIphD6tSe
	 j+yjgn3slv9RiYQ5rX1Fc4r8BXFlrGZ7TQWy/p2u6uZY+D9EzLagk4cP6sJXXwhP9Bjkp
	 MRkaQmqtrUKoqTIpEQk9jHSVaEp5Ztz+oyxAOEVNb8+4TgND0NrZ2hsM7fKbM9FE/X9l5
	 oy/DL4CbDnBhIw7QraT1WTr/FUs/WDCz7vih0I5A6bDbK3yFm5v3jdAdu7/10wlLiZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X44ZgW75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB32606A85A;
	Wed,  4 Nov 2026 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X44ZgW75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144451F000C1;
	Wed,  4 Nov 2026 21:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829418;
	bh=2RAHpEgUj2su69iAuj+Au46CBcCjTqNh0hL51WoMUNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X44ZgW753UF7eXgxK86eIcyFI0518RkQmiYB3FjpfkSiVZeY1Gvn0aPJopoMjN/PU
	 wi7XlFzitI+15DoLWQjSa7KhScEf2H25eBo69Hqw4yhuULn7NJJ6j8LbN50qMTPGJM
	 hw8Nbj3p0NiDV4aJ5uc0s/TKLWFlq6pauU+3YiUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0114/1005] drm/amdgpu/atomfirmware: WARN() rather than BUG()
Date: Wed,  4 Nov 2026 15:57:27 -0500
Message-ID: <20261104211046.847805251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d7c595044965c826e6f3ce30590d3ec4399cd633 ]

There's no need to crash the kernel for this case.  Just
return an error.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index c7d32fb216e4e..ce2a4a15d5ecb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -806,8 +806,6 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev)
 				   (crev != 6)) {
 				spll->reference_freq = le32_to_cpu(gfx_info->v22.rlc_gpu_timer_refclk);
 				ret = 0;
-			} else {
-				BUG();
 			}
 		}
 	}
-- 
2.53.0



