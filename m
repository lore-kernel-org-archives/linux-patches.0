Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E76356A12;
	Sat, 17 Oct 2026 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260423; cv=none; b=DiAvxDm8RUV+4bz6xfGb7WZa4YWaltHuwKI/jDF3FJdY5cYmrnMi4CeXew2VEjLA3vEHDmn/SW795n8DUf2+ILoQ4ZoWiQoOmScw2j8lG8mg25aohQ8qZhZud5TCKQ+KL+yIf5XJVivx/HyHzAEvPehr15CXXqdL+H/Pc1zq5hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260423; c=relaxed/simple;
	bh=aX2gB8zn2wxp6aufA3iomoXjZTfEC36nFdrThG3Cf/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flcwscOQQJCrPKaq1HxAObb0SvSLlbsIY0qdbomNcyA6s4S5J9+9UQaCOl9llDfO7QvGvEdo2cpYnpQ0BoIY/RS6JNFQvFZgiFUkJGkC8cePmngol/LwGqF0dS1g/NHcDHyxsF9DByliAwUGbeLUe5gKdWMSO0m0//axp9aqPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGlJQNNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGlJQNNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416FA1F000C4;
	Sat, 17 Oct 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260422;
	bh=zeLD1MI4X7qTr+XL0JxKjLNRRO5y7thPc90jQoV7MsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGlJQNNQ28GAuTIpi57IY/ItODYIRujftWgxGZrNosAnXUY1akbsYlMVnOaNuo/xI
	 /WpXo4/mkqiHfqwYjmsUrpcWkwUlc3UtOB9Pv7PjeS/82ffbOWS8bAxnbh7kuO+vxN
	 Q9mK3nOLIImVpmVlz6V4JDJt5con6dqoFlp2Mx00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1538/1674] drm/amdgpu: Remove unused amdgpu_i2c functions
Date: Sat, 17 Oct 2026 18:03:30 +0200
Message-ID: <20261017160510.590929886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit 0ee239911634dd29c3b05e1138d617cc3cab33fa ]

amdgpu_i2c_add and amdgpu_i2c_init were added in 2015's commit
d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
but never used.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a99cd231cd92 ("drm/amdgpu: Bound GPIO I2C table entry count from VBIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c | 25 -------------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h |  4 ----
 2 files changed, 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index 82608df433964..7c9add7652daf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -226,15 +226,6 @@ void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c)
 	kfree(i2c);
 }
 
-/* Add the default buses */
-void amdgpu_i2c_init(struct amdgpu_device *adev)
-{
-	if (amdgpu_hw_i2c)
-		DRM_INFO("hw_i2c forced on, you may experience display detection problems!\n");
-
-	amdgpu_atombios_i2c_init(adev);
-}
-
 /* remove all the buses */
 void amdgpu_i2c_fini(struct amdgpu_device *adev)
 {
@@ -248,22 +239,6 @@ void amdgpu_i2c_fini(struct amdgpu_device *adev)
 	}
 }
 
-/* Add additional buses */
-void amdgpu_i2c_add(struct amdgpu_device *adev,
-		    const struct amdgpu_i2c_bus_rec *rec,
-		    const char *name)
-{
-	struct drm_device *dev = adev_to_drm(adev);
-	int i;
-
-	for (i = 0; i < AMDGPU_MAX_I2C_BUS; i++) {
-		if (!adev->i2c_bus[i]) {
-			adev->i2c_bus[i] = amdgpu_i2c_create(dev, rec, name);
-			return;
-		}
-	}
-}
-
 /* looks up bus based on id */
 struct amdgpu_i2c_chan *
 amdgpu_i2c_lookup(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
index 63c2ff7499e17..21e3d1dad0a12 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
@@ -28,11 +28,7 @@ struct amdgpu_i2c_chan *amdgpu_i2c_create(struct drm_device *dev,
 					  const struct amdgpu_i2c_bus_rec *rec,
 					  const char *name);
 void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c);
-void amdgpu_i2c_init(struct amdgpu_device *adev);
 void amdgpu_i2c_fini(struct amdgpu_device *adev);
-void amdgpu_i2c_add(struct amdgpu_device *adev,
-		    const struct amdgpu_i2c_bus_rec *rec,
-		    const char *name);
 struct amdgpu_i2c_chan *
 amdgpu_i2c_lookup(struct amdgpu_device *adev,
 		  const struct amdgpu_i2c_bus_rec *i2c_bus);
-- 
2.53.0



