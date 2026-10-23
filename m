Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774407;
	b=Aa2Z08QmcyylgCqYFQG4DPgHBgUwKZieu4ZvTcW1fMVXzfZktJS2wzl8riX6oArwb/FS
	 VypK0NFq6Wlyw5zDgh3vlu+/TaNMKRvkOgBGj1AzEhPTauXMWhFkwzOxyT7d+DbugUSr6
	 5RK6woh0BRRAVUW/K5G4tTzIG03Eqj8ZhdsP6+8VUEgXdpmvY0uqD+++xa4jp8MSCvjiO
	 oZm/6KjO/EoUHSBwDAcX90Cdx0eyk2xkehnisWQiviTbVt6hPvYnKEKenLgdKypCNW8I0
	 nm8UXVpnboXLmtt/onMaKuxHANoCVnkqqjJJSJRy/rDceR+HR4hh9Ggzu3odUPMt5YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNVsvbT3IzRFzDtdWYJ0OWXPYaqOreTJLUo+EvVY8TA=;
	b=EWHGBLIvTh4aqmIGLEdzsQpSSV4C8VclC4WXQ//z4xoi+0DisIIAd5MyE+RvC0i2NhQT
	 uG+eeZn6/kX/2M5klqzYkfj+btKM2bOHuLcSydl8aW4iZs5qR+jcpmLM9pJLZf3GOgDyC
	 tfbc/zFKvRiCbPnQZFUiBc8Cq0+PG7gtDmN1fcjzzWVM5CYdSgAzIIzFqKhNbPjhlo/fq
	 RuFRzVLEg4Fi3/j27ioNJW+tQT9Gn2Ar3utks0FoVlpTN/TvYLxDkxHTSjfgyaUjZDXtV
	 QVg4dZ1eOs0Kch7JObPiyTyzKPF1GMrMmN3q05FVdezI08hfMtzGCXFEV7rJneuOg6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjkNallb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59798606A31A;
	Fri, 23 Oct 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjkNallb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD21F01825;
	Fri, 23 Oct 2026 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774407;
	bh=dNVsvbT3IzRFzDtdWYJ0OWXPYaqOreTJLUo+EvVY8TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjkNallbZ5Jj57MyLSwF12g0zCYuPjUYpA9qXYJcsGZ0Vrjb6VZgtFzFYpQBWgH1j
	 yjmBYDp09H56JJCBNEDKJVQOAbfQw1RujYHRY65DKzaFn8j4lwUiZt4iihozyTc+HN
	 jyqWez9QIGnDzRPFTDbgqGFHfihLF/u/RwcVUby4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 030/242] accel/amdxdna: Fix Kconfig invalid configuration
Date: Fri, 23 Oct 2026 18:37:52 +0200
Message-ID: <20261023163714.494126608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <liam@infradead.org>

[ Upstream commit 8240e19d329e9e1502fc96608d8afe6861e9df90 ]

The amdxdna has a soft dependency on the amd_pmf module.  It will use an
exported function if it is available and fall back to another function
if it is not enabled.

amdxdna and amd_pmf are tridstate modules supporting both built [y] and
modularized [m] in the .config file.  Since the amdxdna decides to use
the amd_pmf if it is either a module or built in (see
drivers/accel/amdxdna/aie2_pci.h), then there is an issue if they are
not compiled either both as modules or both as built-in.

Adding the optional dependency to Kconfig does not allow the
configuration from being selected.

Fixes: f66d6cc6891e4 ("accel/amdxdna: Support sensors for column utilization")
Signed-off-by: Liam R. Howlett <liam@infradead.org>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20261009011010.3521631-1-liam@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/amdxdna/Kconfig b/drivers/accel/amdxdna/Kconfig
index f39d7a87296cd..eddff490b4f75 100644
--- a/drivers/accel/amdxdna/Kconfig
+++ b/drivers/accel/amdxdna/Kconfig
@@ -6,6 +6,7 @@ config DRM_ACCEL_AMDXDNA
 	depends on DRM_ACCEL
 	depends on PCI && HAS_IOMEM
 	depends on X86_64
+	depends on AMD_PMF || !AMD_PMF
 	select DRM_SCHED
 	select DRM_GEM_SHMEM_HELPER
 	select FW_LOADER
-- 
2.53.0



