Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190061F76C3;
	Tue, 17 Dec 2024 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456037; cv=none; b=R6qPsJf6fq0wQbGYrxcopgsKR7s9dbOFCnlvRTOysqU3xnpJn0m8wnD5ZuCeJMIO4N0lFZ5yDoiwwfiC+d+01p2nkkn3jABjHg4hqmK55aXAi0zXX/e8uAtIS+3bRs+8Ctvf/d957rqwAzrmycUYz570LfvUbEtKcm4iK2eviUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456037; c=relaxed/simple;
	bh=5ZoR4DJ5E3vb0tVfW5eTy8xKqa9HyIyDkXO48EnM6Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mp/nN1DS1L8OoKi84UO90T8urhd99uihazMOgE1IaCuZYklB4qm6gUKvZle7xvF+3L7GKh/KGllTYS/QeiE2D5medBc15a8jiiB0k4pB90GaK3x+4FhUc1hpeAARozqf+tabNg1HbvVawbu1j6qcSJA+iWUSbLp2NORyFW31T5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdXHPQWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdXHPQWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E387C4CED3;
	Tue, 17 Dec 2024 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456036;
	bh=5ZoR4DJ5E3vb0tVfW5eTy8xKqa9HyIyDkXO48EnM6Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdXHPQWhQQwjB9kk989wjcYGzwKL50hE9FX4s+3bv40v1sLuMXvcBxNP4lStb5bBk
	 M3EJibcJEkAG6kqQ8qeV9M1yMy8DtnuEbwH2lKt7WE0cIMOP1tgaT5mOmajTLkl/9o
	 JTwiES18urYe9N9QWiW/8/YVeJjMv6hMlwL1Ksss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/109] amdgpu/uvd: get ring reference from rq scheduler
Date: Tue, 17 Dec 2024 18:07:24 +0100
Message-ID: <20241217170535.045444957@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit 47f402a3e08113e0f5d8e1e6fcc197667a16022f ]

base.sched may not be set for each instance and should not
be used for cases such as non-IB tests.

Fixes: 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
index 86d1d46e1e5e..4fba0b3d10f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -1286,7 +1286,7 @@ static int uvd_v7_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 					   struct amdgpu_job *job,
 					   struct amdgpu_ib *ib)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
+	struct amdgpu_ring *ring = amdgpu_job_ring(job);
 	unsigned i;
 
 	/* No patching necessary for the first instance */
-- 
2.39.5



