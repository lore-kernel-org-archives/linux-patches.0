Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015286;
	b=wMdusnibvC1i8nQT9glXyO7NuKHUBu5N9dI0grVwEGECxzpVeT9hV0KwSRMKH+4gF9Er
	 ALy+UD4PhE2gSfCQDmglYXRKopeQS5vu4PUNAbP3e0VL1BGflUYIvDvsQLsNg3EWtM1SC
	 11I9ABvAneN6oJgJCJk8b2sfWa8nlzedb5pdTnWNdopPEI7iECrQt/PYVN3NZnJrglOkS
	 889IAww0DI6muU5C27kQeXnFcF0anEv/Rodtr74tJV/s7tL7wNAtZdaxqUsH0Gzu7O9T1
	 PVu039uZQ7uZnqw6RckG6paG1BVZsTU9s7AtG+k8dpagH9L0PtZQgNBn+x8ZXmlk0WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1PYkagxW9EnNdX0HlL1PfLBiF4RIh0ryxy2eAyzAJpo=;
	b=tDpshtfHfGM/VbpREBLqoz0cJoL67ylJlRQRhPOJlPSclR0HOO2IZHOU+bPCD18m795h
	 mpSJEcFMPLoj7lIvrlfW/G87+OJPjKN90nIBcbfLUT6QIiBBlsg/leKF2SCeBsSDGn+Nh
	 nXqS3QfCV1RKZ2pS8ClPyli7z8CnshQFeAFaQVZ4y8jbgliQovpKmML/7jd5mpibNrul0
	 Q0lnNateamWBc8OwHknddV3gDg2HlMH+KTC2Sgoc1/sIxrzDt0ZXvmiHwSliv7AcurCXM
	 0wnE2CxgPrvZmt8ptDiv0lVPN0vS4UM43DINhnuGSKpRN3NhHmCZuIlohcpHi66giGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAIdR+jQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2280606A325;
	Wed, 18 Nov 2026 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAIdR+jQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C7B1F000C4;
	Wed, 18 Nov 2026 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015286;
	bh=1PYkagxW9EnNdX0HlL1PfLBiF4RIh0ryxy2eAyzAJpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAIdR+jQ7oj0jW05oz5uQ2W2EnzsNDj46pWWq4qfMZXc+ifUspXqhy2ibR+oX2rOE
	 J9x0lJ7ifiRkjuW7xrKynpsHtt4CWBwDLpl7XBGAMWcl5oS8pDEP/DArcowSNVdJUv
	 pnYE3kVMc1TL+q3TMxCiE4eF9yI+SraA0uKZxA7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0077/2651] drm/panthor: Take reqs_lock in soft_reset for clearing pending_reqs
Date: Wed, 18 Nov 2026 15:21:57 +0100
Message-ID: <20261118150250.697845375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 2d354adc5bbabe2e818be09bbe13f6bfde4a30c7 ]

panthor_gpu_soft_reset() sets pending_reqs to 0 without taking the
requisite reqs_lock.

Fix this by taking the lock for the duration of the modification.

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-3-751e32901898@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 110ca6cd3d098..aa903fda20a59 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -424,7 +424,10 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 		return -ETIMEDOUT;
 	}
 
-	ptdev->gpu->pending_reqs = 0;
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		ptdev->gpu->pending_reqs = 0;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



