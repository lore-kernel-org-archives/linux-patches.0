Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060657;
	b=Sryv7kDtPaag55l3yE57jI3PLHB8IsENoWE5oYmLahQuWM0R6dtmSnjIdmFkdFqxSzzs
	 DGVrcAmZvylhxfiDeksWfw1Kw4HRX7CoCcVfkazDCf19G+G2nLCqYh0U1G8UHEYffMqpM
	 d1awEcj/VrEWmzTNlHg3BTNwuEqAB/DaD3LO6kD3LKasG+xlSAtsEppc1BiUEHRsoaa2e
	 nL5xG/fOLnj9s3fg/Ab+miInECfvBGbt/Q8nZazJ0fzTBn88KGdg5DMlZYA72u9l/pok4
	 eUjb+/yPyKZziOWHiGdA9R6mO282AK6tPkTvwxK18qdnkiMZ7cphuG6D2b5f5h+iJbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FD/seO8mcZnf0pKtKCjrwXIJHv5Sf4yw2FpqPnklaiI=;
	b=VmKgNnX8okOymDjOqKWOAPYBbtJcK1EDKp4N/cPFsTFlizKmOXdAVyh1tkjvFxbq4Uyz
	 Dt8EO7HzT5iKAHFpqlQLkNLXOVLiw5tVhzRJm1R8f+EZ3hZX47tDZM344VdoK1CYNcdHv
	 jCAztOu+ulp0z2g/0YlRbj7oUrli++z0hTxH5vo4hG2yo39/MewqZm57+zO3ySyRNKsRN
	 9bvsP7prud3oc+4BwbBrscKyPEhG1U7MaWvgodO9rH7gqrhhT1l6k5FKKm1uwQ4MZSgAT
	 CF2XUKgPQU0jyhhWFHCbilZDPbzaOza6caWGicStRkZA63+0DAQ9TFNswsKGk4Bis0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6avg9Hc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FDC606A326;
	Sat,  7 Nov 2026 14:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6avg9Hc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4063E1F0089F;
	Sat,  7 Nov 2026 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060657;
	bh=FD/seO8mcZnf0pKtKCjrwXIJHv5Sf4yw2FpqPnklaiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6avg9HcWT+QQDpESo4cW3HurTb2O0lZV4uHX+cxzU+iIN8fvmLc6jdoKJUj//8Ln
	 GSlbyK/NOkG6EY2Ytog6RD6a7aYDl5A1yyy7jwPae1Zr20S2LjaNp5nn8dkD4QWWar
	 M31LarOF7t1p/IjkPqFlB3A60y/QjJM6/1EfJrvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0097/1536] drm/amdgpu/atomfirmware: WARN() rather than BUG()
Date: Sat,  7 Nov 2026 08:35:13 -0500
Message-ID: <20261107135000.388214190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f873dd3cae160..8d8da11ab9a1c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -797,8 +797,6 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev)
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



