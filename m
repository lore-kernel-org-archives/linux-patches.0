Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE730762DA;
	Mon,  8 Apr 2024 13:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582217; cv=none; b=pkOlgQtYk558YD5o/PrEBosJHoiSkeV4fqu8EsoJKNEIibyKrP2yX9T5HaR3mT229BzNKcgSLtDsI4dIWVT8zkz1zY4taqPm7SitMjKd/tmtkd8qhn3WWr9YTP5UQSctLW2zEyzvJEheqevo+wMYQOED2iKFIPuQhV2qNDWcW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582217; c=relaxed/simple;
	bh=6D++A2YjSPcrP85himGLW48Jse9hQw1guWVUbeZEJLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwR0JAJC4Y73eBWJAcnlOnVeltLjfsNBpm1VbgBW963iMFU7eBd4ex+uQO8MvL4pZgTWlZEQA8cCuhDGyR9bJlS1bIT/3ZfczsaXCa/s6CPNStCmksUu7a4Odri1YyvIcGB9qKS2d7QHL5aJceMZCjGj43++47kYbGLCGBE7PqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDaBL5qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDaBL5qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35984C433F1;
	Mon,  8 Apr 2024 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582217;
	bh=6D++A2YjSPcrP85himGLW48Jse9hQw1guWVUbeZEJLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDaBL5qupDfv2pISz/Lnj90EHzoA/u0aC4FEVP6AeSFmTrPpJFKFdm83utmJqCxTF
	 qEf3m2jjfbKLxkcBLCuNgsJIGTvIgmU4HtLcerPEn6UrCNR1SffsPM2vBwZSUQ6MY/
	 0eXtYVYfBhY8BP0eLwOt0HzbQUdCZefw7t4XQfv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 057/273] drm/i915: Do not print pxp init failed with 0 when it succeed
Date: Mon,  8 Apr 2024 14:55:32 +0200
Message-ID: <20240408125311.071999967@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit d392e1b9c2e8c60550a2a467732107f0f98b8e97 ]

It is misleading, if the intention was to also print something
in case it succeed it should have a different string.

Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Fixes: 698e19da2914 ("drm/i915: Skip pxp init if gt is wedged")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240320210547.71937-1-jose.souza@intel.com
(cherry picked from commit d437099ab21cd4c6ce5d578b765df642d759c929)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index c7d7c3b7ecc63..9967148aedf15 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -799,7 +799,7 @@ int i915_driver_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_cleanup_modeset2;
 
 	ret = intel_pxp_init(i915);
-	if (ret != -ENODEV)
+	if (ret && ret != -ENODEV)
 		drm_dbg(&i915->drm, "pxp init failed with %d\n", ret);
 
 	ret = intel_display_driver_probe(i915);
-- 
2.43.0



