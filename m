Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043147;
	b=KvSZVsXLDzMvi2iu2dVRwWF5foclgZAwEqUHaohCl9etgk5fvuCh/7cC9G/pte1OJO30
	 ipG1Bq0xJSXya3KugIECsc4vt7KqiOQlQa/h/4sQofA8vuFBdV9ISZndTTonK2P/xi9qk
	 hoCwAGvedC6fvL9Bue9xOYtgqIPdJ3PWWhu6DxjSZQ0Sa2ym7fiJS4qUBGKlq8sZJHAMq
	 nfi4jwr5m8IfMatCIjpk4V7cLVXcX/BlyDw4S/G7h2z3R9HL+xPhr3n1+8BWB56v+NbEm
	 AqkCQDxEo7ImrgeMca6w5BMVcRgQoiHDxncGc4GcbiV1I2VeEjv7hqQLv5Jh40XdV3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pnmqSBJei8c1/+3hRR3R7SwRbSyqsAy5xWXRjQuzlzU=;
	b=bfgikU8KTpU2b7TYv+yulaPud1N1L6vYJQvHhYtFrG9XvWByOJH0NgzLKaEy/CJQVc5t
	 6V1o1U7KfmMk+AIoEpGfKgPbNRU9Os4VJeANVh6h96kvmCZP1A+3+1j1H9HuQwNHlsQPT
	 DDtB3zKgSTG7SFefk9ceLZGsf8G9pyqSbJt6pAdASVrxDCx6dAMw7sCH3vCd7KaM5sANe
	 /N9fdgjQK6mvo9cf7JUNuAWNmV+itpD7pfY/JAyP9wMaV40EZE4dMX5Xwir3Wciy3gC/5
	 RbE0uq9XQc/knTIfVlOJ4s5Yqzrhtn8qM+1SIr490McAami9sDciTaduvsy2w04EYzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XsWDIC9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAEE60A2606;
	Wed, 18 Nov 2026 23:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XsWDIC9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06C51F000C7;
	Wed, 18 Nov 2026 23:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043147;
	bh=pnmqSBJei8c1/+3hRR3R7SwRbSyqsAy5xWXRjQuzlzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsWDIC9OtA4Jhy3toaAk+gCOqZtaWH+fSatmkhDAuLFzQjQpIYAaDaaP1C1tPLeac
	 wLiox+PLyJAtBBSgH0yDGeG3JWhNkSUxS5CCnQLaeT3WkgQpGs/hkq09NsTbmMIKeQ
	 +zjanyGKzSilPQ4LgXnBJZD7DwGNqzSr2DNDvUmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0065/2857] drm/amdgpu/atomfirmware: WARN() rather than BUG()
Date: Wed, 18 Nov 2026 15:18:19 +0100
Message-ID: <20261118150203.670744966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 1e64720a70a2b..f66e0489937bd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -738,8 +738,6 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev)
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



