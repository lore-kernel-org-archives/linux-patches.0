Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFAC18E77B;
	Tue, 10 Sep 2024 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961494; cv=none; b=HFeqdeY9atCWo8LCX1WGAqrOMAeaDAylBEgk+Fsn/aWDKaGLy4te7l/4BkZ2CvkbB536DEGW8043xNxO1y5WALoOqTTkyEnvfKcXXmbIROX89ke+hzF7xs8bWPA2yG1AsQq8KU/1VrhVNXkUrB1Wvb8d1CASduJa10OTYcLuZBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961494; c=relaxed/simple;
	bh=OCQUOBCGd4jrc4G5BUuCRGzACCOHOmQoOqj70Y2LxGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bp5j2gRGc5xe8TF+HgTwsWuCkLhChUhaxmaCoFo7wltbGYrjFvoAVO/bFG0WFyKpKWmPdVR8z6UGd+8IDY0Pt8t86TQ8Q67OrOFzodS1Nhy+quWmEg8S0K9bJ8hO9o8MJNvDzmoKs/AdCGzU3bZ5hUsrKRwGICIbVXF2cHS9qRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StszJNDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StszJNDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378D5C4CEC6;
	Tue, 10 Sep 2024 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961493;
	bh=OCQUOBCGd4jrc4G5BUuCRGzACCOHOmQoOqj70Y2LxGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StszJNDSH7IJynmHZIHRarSFdPyDlfyUGkqT4IdFvl5us/eWPgPO0yZXtwo8oFCLy
	 wLZxrn9nSKOMcQ2FrQdrTypVEQT6DYJP0KO2VMf5+V3eMlZL5/I2YBdYofal8DVfzu
	 dQaiwNZDImKK3EEgyFg49tk5S5tEgtMFz9quvmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>
Subject: [PATCH 6.10 089/375] drm/amdgpu: always allocate cleared VRAM for GEM allocations
Date: Tue, 10 Sep 2024 11:28:06 +0200
Message-ID: <20240910092625.227357256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4de34b04783628f14614badb0a1aa67ce3fcef5d upstream.

This adds allocation latency, but aligns better with user
expectations.  The latency should improve with the drm buddy
clearing patches that Arun has been working on.

In addition this fixes the high CPU spikes seen when doing
wipe on release.

v2: always set AMDGPU_GEM_CREATE_VRAM_CLEARED (Christian)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3528
Fixes: a68c7eaa7a8f ("drm/amdgpu: Enable clear page functionality")
Acked-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com> (v1)
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
(cherry picked from commit 6c0a7c3c693ac84f8b50269a9088af8f37446863)
Cc: stable@vger.kernel.org # 6.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -347,6 +347,9 @@ int amdgpu_gem_create_ioctl(struct drm_d
 		return -EINVAL;
 	}
 
+	/* always clear VRAM */
+	flags |= AMDGPU_GEM_CREATE_VRAM_CLEARED;
+
 	/* create a gem object to contain this object in */
 	if (args->in.domains & (AMDGPU_GEM_DOMAIN_GDS |
 	    AMDGPU_GEM_DOMAIN_GWS | AMDGPU_GEM_DOMAIN_OA)) {


