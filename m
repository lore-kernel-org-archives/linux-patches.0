Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829679;
	b=LLjzdLpX6xhn4txOmVAO+9su7XID2QSdFS0+Wma9OtY6kKRDM38PxP8HEmze0xb81X/5
	 IdvS/mv1vbaqcqR6Cioy+CNcNHxrIqVhg8eCsQcKVNGsUD+wSE5dFuq3ZPT1mUGCyftDB
	 sjn+hPpnjhpGN+dLdk6MLC3W23P+9L5khs15UxgQnvD5zKsfMdRxMyZCZlX4pUNpe42kZ
	 CvHFbTQgHNCD/68S3CG90J2ibBzBvL20RdsxWYWorLMVxWseOgnnIczTmER6mBOQfmr3e
	 HWkiMKs2UvCL0qB5eZSIYQZJ4+CmZKdcnH9xXzKeO8opBGj/WTo0giVTi0My6BWvgWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTKjaseIPLhRrTi2onmVzXL6BoIKDTttl0Yj4cZlcl0=;
	b=Jg23xElMTnESmL9lMzOeuhlldMPdFcB2UVqlY3hAUfdLtmBv6uJylr3dnVImZ0A5Z6z7
	 r/UlOtZAXkdmT/RtWkySssWBNXo6NHBIbs5faD3SzxMjsWZNZbZZEEoD8j8WAwCJGBO9x
	 uMedgpxslAsCaKXSDEu79VsT8pGbhk2ubX9hZE5wRaEBIPAdnVJsOo2FGT8Fae0S96mG0
	 k5KlBC/Uln1A5Rf2l7LLDw6uFo5cSAhmtYuCeLLxHk1UEBFW8gu8LPkH12GZ86JdjH4zQ
	 AZ8xh1c6RM/QktSFQdvAxBeRfE0ShhSW2CGc1Ei4PAHNo2DJwXOQSYZz6IB0ndVi4wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceoNEnfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E1606D828;
	Wed,  4 Nov 2026 22:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceoNEnfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DF1F000C1;
	Wed,  4 Nov 2026 22:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829679;
	bh=lTKjaseIPLhRrTi2onmVzXL6BoIKDTttl0Yj4cZlcl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceoNEnfQDkSHACTOokCpkevMi+MvEhiBrhkCg0inXiZiyZgqjyZkJY0+5P8HQEul6
	 g4b/qhmbI4goqsomBxHtWqWP9k8LhsVu2VwWVgx9rNs0QbXUTlD0aR6DgNhM51YZTL
	 N5ATjyPCHD0Q0NTEgILkOPcFvpS329gCkK9iY1Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0276/1005] drm/msm: Move nr_cmds initialization
Date: Wed,  4 Nov 2026 16:00:09 -0500
Message-ID: <20261104211051.617147871@linuxfoundation.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 9ee2884ed58e6b39da35732146446d5930e4746b ]

Previously if we entered an error path between these two points, we
could leak the relocs tables due to submit->nr_cmds still being zero.

In practice, relocs are disallowed on a6xx+, and non-ancient userspace
will not use relocs on earlier gens unless running on an ancient kernel.
But userspace could use this to trigger a memory leak.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/743085/
Message-ID: <20260729155609.20190-6-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 75d9f35743700..2b6b5297f0592 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -260,6 +260,9 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 			ret = -ENOMEM;
 			goto out;
 		}
+
+		submit->nr_cmds = i + 1;
+
 		ret = copy_from_user(submit->cmd[i].relocs, userptr, sz);
 		if (ret) {
 			ret = -EFAULT;
@@ -717,8 +720,6 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 			goto out;
 	}
 
-	submit->nr_cmds = args->nr_cmds;
-
 	idr_preload(GFP_KERNEL);
 
 	spin_lock(&queue->idr_lock);
-- 
2.53.0



