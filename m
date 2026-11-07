Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063545;
	b=IdS1u+4e8HRd7owWQp5rO4oiopN/KI+IW6IBgGyiIL98NcU1Yhs80M+gP73S+oUjRjf0
	 ItZCWUhFQjDga3WJ2hiYDRR7dktHsrjcYuvx0dsOONR6Tm1bfKd7ewAVg89LwstHC+gyY
	 LWkfg8vsUW+8Oc7Gv8lcOEAdwWzzxvjAy9jbE80x53Z+KTNa1RZvpUV8VdGsVlDDZ41di
	 wodqM8QUIf4GoHasB43WINVwJ1x+iJSAnA/o1ZzyDlOHH1rXE+XpYZhw7pgw9gcMXrcI9
	 DU+9YTW/Cu9L75HLH0jElPCAX5mj2gWdiXhQem47u+K/FfulAETtj679iVTyzgLLrlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLmmrCzCohLpgYOKeeLF4phEowLHE14pcT7EFpsxBXQ=;
	b=xYZ58MgCgJYmcBboqZ43F8Iu8GGqSX7+ZatMpvy6ri5OI0kyVrtKLWCiK/LMBua1RnVt
	 KoF7zzXDca3EKoFh811gWzTZZO1v/eRXXanVYAD9sYGpoO6M2bvsXq9DuPm7tQDgFVvo2
	 amZndVBGz8oRdb3Bp/oxa9hZh2kxo8g+yK4mXORXXm3EMVHQ4jmjTieJHatImN5k0UvR5
	 bcSI5qPQ3cYds2JdOj6P/qWrvCKTZFgGJztVjeCoohoAAdVc9kkjAxZbBLRt2tZS5Xp/x
	 7fU2QDZD8P1VDqbn6QiVQVcKv735ivQ45rzWh1EUAbiaMlDeUom0UdTHbc8YW5tuP8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irEoEwL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA066083614;
	Sat,  7 Nov 2026 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irEoEwL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA661F0089F;
	Sat,  7 Nov 2026 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063545;
	bh=eLmmrCzCohLpgYOKeeLF4phEowLHE14pcT7EFpsxBXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irEoEwL3QSqoq03e7cVMWLhTSTG61tgD+8vshQe6anRf6Uzn+Dpo1c5V5A6VARHEJ
	 qvbLLfveZdUYb7VxBXC1B1O+8UfETPqXIrPMQ/sUXbFE6ni+kOQjgBoloHpYgOdRPF
	 okst8pDykINitM97TIP7E6QyOlcUuOlteawvRYqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahzeb Ahmed <shahzeb.ahmed@amd.com>,
	Manjunath Gaonkar <Manjunath.Gaonkar@amd.com>,
	Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>,
	Apurv Mishra <apurv.mishra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 679/869] drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950
Date: Sat,  7 Nov 2026 08:56:01 -0500
Message-ID: <20261107134916.096172409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>

[ Upstream commit 232213c9bd7f703836164f23160b76657094a7db ]

Add extra type-2 TLB flush for GC 9.5.0, similar race condition was
observed as Vega20+XGMI. Add to GC 9.4.3 and 9.4.4 too, as they share
the same multi-XCD TLB topology.

Reported-by: Shahzeb Ahmed <shahzeb.ahmed@amd.com>
Reported-by: Manjunath Gaonkar <Manjunath.Gaonkar@amd.com>
Signed-off-by: Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>
Reviewed-by: Apurv Mishra <apurv.mishra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 138cfb165ae6aa98c0767b431e718d1a8199db28)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 0f0d6cd52d916..230a346db3b1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2186,10 +2186,22 @@ static int gmc_v9_0_hw_init(struct amdgpu_ip_block *ip_block)
 	 * (type 2), which flushes both. Due to a race condition with
 	 * concurrent memory accesses using the same TLB cache line, we still
 	 * need a second TLB flush after this.
+	 *
+	 * GC 9.4.3, 9.4.4 and 9.5.0 hit a similar race.
 	 */
-	adev->gmc.flush_tlb_needs_extra_type_2 =
-		amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 0) &&
-		adev->gmc.xgmi.num_physical_nodes;
+	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
+	case IP_VERSION(9, 4, 0):
+		adev->gmc.flush_tlb_needs_extra_type_2 =
+			adev->gmc.xgmi.num_physical_nodes;
+		break;
+	case IP_VERSION(9, 4, 3):
+	case IP_VERSION(9, 4, 4):
+	case IP_VERSION(9, 5, 0):
+		adev->gmc.flush_tlb_needs_extra_type_2 = true;
+		break;
+	default:
+		break;
+	}
 
 	/* The sequence of these two function calls matters.*/
 	gmc_v9_0_init_golden_registers(adev);
-- 
2.53.0



