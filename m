Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7D94AAC72;
	Thu, 17 Sep 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659929; cv=none; b=dr2V3rYhDa27KSHlGGTfG011Kkk7vJWcaN0GMCzP7JUHmi8CFlDrtw89h/gEH08/d91OFnWh7JPY23u3S7CnVnqRSuXPn+Kgc2eBJZ8ICleuQcTqV9VGT/qSMTCc3aP56YuOA39HB4Nu7KmMsxbQF+VRNrkBN1zQffkzmGKKzWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659929; c=relaxed/simple;
	bh=BeJm5eu0xgGAI5bQHWLQkS68W23HkUzvZKeY6KoFlo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uda9WAbTNW2QdP1q3eRbsO0KQTPKy/k5N/n1Rv345PROvj8Psjhx5XBCSeuZRxjCY7jYFXrX7s1LKz9NzPyUdxJwKCg2/nSYJlX0fUJ9t/rbusU5yzwpUsuUklUbsE/bfmtFTXAQPW3CzLCCp09+xq2h8gMaeAwR7y4JO17j8B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/UJJzra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/UJJzra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8DD1F00893;
	Thu, 17 Sep 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659917;
	bh=c+2soabGRlYsCxul5HRSCmCKwLFFpzHrGAb0qYqjs9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/UJJzraw/8oD1BwpQjIQs8mgd8TxHaG70iFDAPfiwfVYDb9nm0FYFKCWXBdnE5JE
	 IlH7YXAwvt035rvpvCOc5jKgQ2M1mcTpRbxaD6igsupvxwRiDNPRWKU20NAaFU8Rf2
	 CR+Jp+0g1mC2GKU8MddTd/AIOyvEhfsWYr4bceh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 368/733] drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Thu, 17 Sep 2026 16:11:16 +0100
Message-ID: <20260917151400.799608776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f97802dd98b27e45c04293f9926f07642578b23f ]

CONFIG_DRM_KMS_CMA_HELPER was removed by commit 09717af7d13d ("drm:
Remove CONFIG_DRM_KMS_CMA_HELPER option"). When commit 6bcfe8eaeef0
("drm/fb: rename FB CMA helpers to FB DMA helpers") later renamed the
select in this Kconfig to CONFIG_DRM_KMS_DMA_HELPER, no symbol of that
name existed, and git log -S finds no Kconfig file that has defined one
since. The select is silently ignored. The driver already selects
CONFIG_DRM_GEM_DMA_HELPER, which is what it needs.

Remove the dead line.

Fixes: 6bcfe8eaeef0 ("drm/fb: rename FB CMA helpers to FB DMA helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260905080344.34077-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/logicvc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/logicvc/Kconfig b/drivers/gpu/drm/logicvc/Kconfig
index 579a358ed5cf3..11aae1626199b 100644
--- a/drivers/gpu/drm/logicvc/Kconfig
+++ b/drivers/gpu/drm/logicvc/Kconfig
@@ -4,7 +4,6 @@ config DRM_LOGICVC
 	depends on OF || COMPILE_TEST
 	select DRM_CLIENT_SELECTION
 	select DRM_KMS_HELPER
-	select DRM_KMS_DMA_HELPER
 	select DRM_GEM_DMA_HELPER
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.53.0



