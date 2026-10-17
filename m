Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B573AEB39;
	Sat, 17 Oct 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255349; cv=none; b=mJeqE3UWgZfKHgk2BwPYKsAXorRewCcv4DPAu8eiuC6gxHmg2SiF4Y/m79tEFoqg8pwptuvyt1V+nSV6JkSRUYkdoC3vbtY4OPzO8PyM+9HKV29quL8JKxrxI77aHVt/WMR3lPpi63GFTqoY6j7cty4uoS6vONT7pcHX0e67XtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255349; c=relaxed/simple;
	bh=f5WoZh2cUsVNIVASh7JkQwZ2PLsc9i8S+JgSzSCAnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlMDETDMu5KnvkDZxecm0nKqYR2pmY02XjIIBsQHq2j9OyRFqCjw0IHsMtkOGnEB9V4e5ErrJWgC7wNryBYiUDxgcF2lzBqaVmdbzs+F9mHiN7rEzyJZhFAjF+76M97vxxqcDf8JixnAnbnDjtSYvB/6bdzmACaPj9ApVzj41d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APwlh0oS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APwlh0oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C51F000C4;
	Sat, 17 Oct 2026 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255348;
	bh=vLhKfNqg9EZCCD8n7KMNVViaZckJ8SAU0OYIzcleBAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APwlh0oScoi3kX4CcVQE4sC7apsfXvw63fY84UXDoGA0gHfolNIi2y8LNoJKbhJD4
	 WyQ5l19/iFyVhZ9utLiMJwLEAfznCMUHNEXVS1pNw/5vDdQCiOYXqaENbspDSxx76U
	 Df8zeRsessS/7OkuhF2/rI9kaGtGJm8sY3JU5LsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 744/869] drm/amdgpu: Remove unused amdgpu_i2c functions
Date: Sat, 17 Oct 2026 17:59:45 +0200
Message-ID: <20261017160056.014778825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 00d6211e0fbf9..f0765ccde6680 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -225,15 +225,6 @@ void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c)
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
@@ -247,22 +238,6 @@ void amdgpu_i2c_fini(struct amdgpu_device *adev)
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



