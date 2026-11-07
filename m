Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065152;
	b=opOScHNHXou8s7/YWXs6fW1gIP7fAwdTiwhWbU43+r+WRvFcAPcSrlkobKP1I0VJEa82
	 rgoC77UpAPOXLTeCDC9laWLvXgvT/LE7DC5MsYuSyyBSeK4rBMqszd0s+xhepVyG3DjT9
	 /C2R682+rqg9DDWwtZ7lscEFdWqCWCljV9+dYGrmWVHFiSIAQ/nsFTJ2pdlv8CSIxbxiA
	 2OVDBBLPHgNZj3c/VCohCW2GnoQxkflRVdvPOxoQcXmDctHO0Drj1ZGKzENt0bPY5t4x7
	 gEVLbez7mfi2Kx6U6DZOzTTTTGbk9p8plIzl1YpdPvnJPpTaCkn6pZzGKrlVV2Lq9xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xd4Jd5yXqPjFZGx47s/npVh7xLaS2E/kScqon8uYTGM=;
	b=4bJ0F4h5CcGew+4D9nyQRkx0oFSHI7DVyzBUQv6bvtJhQ5734jL7BGyMfvmlGUb/ORn2
	 dpT8gQwYLR93+Td2vbqpzezBH8oIXO8w7Ucc89N482YzYF+mI0ATgNk9z+Bp8Afscf9HL
	 C19f34vomot+h8JFViwfCgTzvdTlGrREoFd8XjziGYIzTHSdq/B2YVHcXdqn3khk+EWn8
	 UqcRQHDs3Rofh/BaHp+lgFw3xNNK4Fn0GPL+DMBdIEL9mEgMX+pAFYTeSapUSJnYSoruV
	 /yW9GhCir+6hK575dezL1yt5hrqQaf/RmQp+qAsq5/In5QEKPh4AsDl3pOqoLQC/9IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sacbCzu1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C90606A32E;
	Sat,  7 Nov 2026 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sacbCzu1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2147E1F008A1;
	Sat,  7 Nov 2026 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065152;
	bh=xd4Jd5yXqPjFZGx47s/npVh7xLaS2E/kScqon8uYTGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sacbCzu1iTmUPSNXOUayKec7IhxBNpJ4ZwDwxuwlda6sEvv7EEC0ehqfOtI2j23ax
	 /IdM44SaP9Zr+fEcHLm2fc80cg71IF07tTpT3UyeJA7SRzYJm0cgun4J4OaR1RJ0cO
	 vVhB6PgjrJh54VWjQYiN6IkBBg1G9HNMZCyUg1CM=
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
Subject: [PATCH 7.3 0963/1257] drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950
Date: Sat,  7 Nov 2026 08:54:19 -0500
Message-ID: <20261107135005.937871476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1192682735300..bb0d013e1fa12 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2172,10 +2172,22 @@ static int gmc_v9_0_hw_init(struct amdgpu_ip_block *ip_block)
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



