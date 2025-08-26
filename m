Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67263093AB;
	Tue, 26 Aug 2025 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208650; cv=none; b=BZ/cLEAQoQsnwwgQgx+Xv8IXF2p9pW4UhzRPS57sgm/uUs7psfsLZgd1J4Onazx9fk2IHIC8gvwYMYIuNG54GN9cNKOC1jJNwzAnqsPbGLI6g0+4NPSqg4jJnG6V08jpYjDJhUDdMv7vIT2rFqcJZwoX/cbKcLPEJr8N2Y2/c7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208650; c=relaxed/simple;
	bh=8VYaVR0us/EsqLi8QP/XHp8SRmTCKvJ4kOxX6AOh9L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUAoh2YV32TzmhyypMUswiHRRss9v9EIU2Ravxa2ilpxMpoZGQhRoNu4Smntkw/CpjFRNfy0fJclHIek38KWP5Olfqqiy3mU7wx0+I0Y7+Ct2R81lhkPDWWKKl330bLSV0kJiDvXqqDK+jay23vbLcs1QcsOPgiJnXETSFVpDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7PyYPRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7PyYPRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F28EC4CEF1;
	Tue, 26 Aug 2025 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208650;
	bh=8VYaVR0us/EsqLi8QP/XHp8SRmTCKvJ4kOxX6AOh9L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7PyYPRyEdkwjjOcEywZGjICXU/H58pn/xwxulYpUDtuI+EDLsOI7CZsi3tKqr1bc
	 sQ4Nhix2SnAdbcbvYJ/IYpN3KsKM4qJNco4b7K0L/mQy3v5u/OeQQm0bDAt0coM87c
	 Uh5IJoMVQIz4dOpF3/39Q4cXOnr+byfAlX9AsZgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Richter <Simon.Richter@hogyros.de>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/322] Mark xe driver as BROKEN if kernel page size is not 4kB
Date: Tue, 26 Aug 2025 13:10:07 +0200
Message-ID: <20250826110920.605937471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Simon Richter <Simon.Richter@hogyros.de>

[ Upstream commit 022906afdf90327bce33d52fb4fb41b6c7d618fb ]

This driver, for the time being, assumes that the kernel page size is 4kB,
so it fails on loong64 and aarch64 with 16kB pages, and ppc64el with 64kB
pages.

Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20250802024152.3021-1-Simon.Richter@hogyros.de
(cherry picked from commit 0521a868222ffe636bf202b6e9d29292c1e19c62)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -3,6 +3,7 @@ config DRM_XE
 	tristate "Intel Xe Graphics"
 	depends on DRM && PCI && MMU
 	depends on KUNIT || !KUNIT
+	depends on PAGE_SIZE_4KB || COMPILE_TEST || BROKEN
 	select INTERVAL_TREE
 	# we need shmfs for the swappable backing store, and in particular
 	# the shmem_readpage() which depends upon tmpfs


