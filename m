Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED4A2641F9;
	Wed, 30 Jul 2025 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869298; cv=none; b=oCuM7DKv2pKqbacKpf0qYwyOqMXyU5GQ1N/UtUlkZ0yZFmsyzGHsKGRqG/rdbyEYKlMGw5q7I9waDxo/D/Ha4LOdJezYZPKtMAnd0VWMmw311d3Z8Px6Erkj2wSq9y6z2KFJAHlo4GKsY7s3/tROpHu5iIuSAS1XCPLaVV9P9CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869298; c=relaxed/simple;
	bh=CgoJ88cuHCISSIlF4Oq8ZdRXbx+F7ddla5sAUBKqjkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owEmpVebIIguh85it3liGfME6kPsynGNfTLTpwVwjX9SndR2z5scBNAmFewBMSHKh443vi64KWQnsXoXR2wpMq2EgYi/uaPqD8TkGlrqhYdefV4lk9ivAVnl0wTHafzIf57JanNbmxhpp/yih9isefxRF9Ajy2h8jpMwAr5XERI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ApBIXoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ApBIXoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0DEC4CEF5;
	Wed, 30 Jul 2025 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869298;
	bh=CgoJ88cuHCISSIlF4Oq8ZdRXbx+F7ddla5sAUBKqjkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ApBIXoeY9rYSBxjMuA/U1ohByWir9/UDmhiNCDSv7cj/GL9w5uHorjwyUUQHLiF2
	 NtVWcVVXA111wFh/TvNFl9XqdPawvld2cPoicFMV5JoO59aYW5k90KzIHvLZmaXQgD
	 QXvR2sNai7zJnTuV5TIOwGPo2HiSsDSmw4rW4X7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.d>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 85/92] drm/shmem-helper: Remove obsoleted is_iomem test
Date: Wed, 30 Jul 2025 11:36:33 +0200
Message-ID: <20250730093234.034488360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit eab10538073c3ff9e21c857bd462f79f2f6f7e00 upstream.

Everything that uses the mapped buffer should be agnostic to is_iomem.
The only reason for the is_iomem test is that we're setting shmem->vaddr
to the returned map->vaddr. Now that the shmem->vaddr code is gone, remove
the obsoleted is_iomem test to clean up the code.

Acked-by: Maxime Ripard <mripard@kernel.org>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.d>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250322212608.40511-7-dmitry.osipenko@collabora.com
Stable-dep-of: 6d496e956998 ("Revert "drm/gem-shmem: Use dma_buf from GEM object instance"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -340,12 +340,6 @@ int drm_gem_shmem_vmap(struct drm_gem_sh
 
 	if (drm_gem_is_imported(obj)) {
 		ret = dma_buf_vmap(obj->dma_buf, map);
-		if (!ret) {
-			if (drm_WARN_ON(obj->dev, map->is_iomem)) {
-				dma_buf_vunmap(obj->dma_buf, map);
-				return -EIO;
-			}
-		}
 	} else {
 		pgprot_t prot = PAGE_KERNEL;
 


