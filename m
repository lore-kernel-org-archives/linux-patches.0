Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721E723DE;
	Tue,  8 Jul 2025 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993207; cv=none; b=s+/M/5iUP0O+Uxp56SYEtHRb36O/iWoXDYLnQR9N//6UrWTBzuqBd9pTjOcA5+8UZm/7FiPGKeNdFXZKmwSWylCHgDmNKgEe1Oi8jO11ampBsFfC5g4D/2DmSOCPRsU/ThSTeqNktfkld6/QRaF0BvNIdO4L6UsJOMl3RKSyo8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993207; c=relaxed/simple;
	bh=uYIb/PSY/7grtTzN+s1tQ1Z1S0TH8HyP4nuA0EHNyQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yw+AsjNk0nRoPoaMvSg44+rNinzpq5vpCOqBbGzQWDzXW8ktOeNNRj/WvjfFLQWmPVY+vJQ9Dhrhk3hz8+cFrG6RnguUxQ0hzAWGJCFHPzqW5lzTiOfCRbc7D7Kn/NEj+Km2W6lYAFxaq8xlDDoKve1xSfekGd9WSgX2Rq9ym1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQuUOfQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQuUOfQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA97C4CEED;
	Tue,  8 Jul 2025 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993207;
	bh=uYIb/PSY/7grtTzN+s1tQ1Z1S0TH8HyP4nuA0EHNyQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQuUOfQ31Yg0vgxcw9vYq0oCHi536OYC9En6Tisk39ImkECyCk2PssBhnDdo015GS
	 2ErB0LDHC40n0505V7qVeS9+aKZgI6wwCCNEYscS74w+FpcDOyvDZJpcD1zKXmmm9m
	 Kd2x84228HcmYTZp0maasOgTHsrZOu6wde8K2qwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Harry Austen <hpausten@protonmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/232] drm/xe: Allow dropping kunit dependency as built-in
Date: Tue,  8 Jul 2025 18:23:13 +0200
Message-ID: <20250708162246.592155200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Austen <hpausten@protonmail.com>

[ Upstream commit aa18d5769fcafe645a3ba01a9a69dde4f8dc8cc3 ]

Fix Kconfig symbol dependency on KUNIT, which isn't actually required
for XE to be built-in. However, if KUNIT is enabled, it must be built-in
too.

Fixes: 08987a8b6820 ("drm/xe: Fix build with KUNIT=m")
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Harry Austen <hpausten@protonmail.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20250627-xe-kunit-v2-2-756fe5cd56cf@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit a559434880b320b83733d739733250815aecf1b0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/Kconfig b/drivers/gpu/drm/xe/Kconfig
index 7bbe46a98ff1f..93e742c1f21e7 100644
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config DRM_XE
 	tristate "Intel Xe Graphics"
-	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
+	depends on DRM && PCI && MMU
+	depends on KUNIT || !KUNIT
 	select INTERVAL_TREE
 	# we need shmfs for the swappable backing store, and in particular
 	# the shmem_readpage() which depends upon tmpfs
-- 
2.39.5



