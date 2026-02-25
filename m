Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04331E2834;
	Wed, 25 Feb 2026 01:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983624; cv=none; b=W5cC31zbpUbCLMBgwZaYdgZVpnweHcJ8I8xwgPQZhV1ta9XgIpvmNV1yNLvYv9s/+TYt4IFWJJ4vGfNS317UVJP6CWGfEAnqM6URpSqU5K+ayc5mjT6Fl7f6v/3NevgDU5DTD16kI6NMgOncOMxGBibfonw9o3sIj3nD1EuJ4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983624; c=relaxed/simple;
	bh=oB1ODCXSyKNn5rHlj0E4FeqYnSZC8+jeUm1qcGn4tjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2ilSurm4LO/JiyZg6VfDwW2z8LymhOP6xA0mKX546lt+HgfLt1BTSr2hwEeVArhmq3W46lB+asAFrB1pE6oI/IhRP7BmIBD10M5pmt18EMRKDWm4jZHvdSaEdBytZ/vB6Z7/7X1Luk7Rgr/I4LwjfII8dmZH3XptSIzuYwOrK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2MYmZe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2MYmZe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C58C116D0;
	Wed, 25 Feb 2026 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983624;
	bh=oB1ODCXSyKNn5rHlj0E4FeqYnSZC8+jeUm1qcGn4tjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2MYmZe1+rtBwZxDW0UaB10HfmZ2HDGpak6wzSvb9rkkSlc5wPQG1++9+qlbKnnKM
	 N+K7nB2ukWVjbcROBfqsLxcKRU/mkw4i4uzq2JeAQhcgL+cEFL2Ac7tFYTO5PQ8BiQ
	 L+AUABAjx/Cj+gxPrJcUc0tsM2PbtqMT7wVoCRrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 716/781] drm/i915/acpi: free _DSM package when no connectors
Date: Tue, 24 Feb 2026 17:23:45 -0800
Message-ID: <20260225012417.302473272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 57b85fd53fccfdf14ce7b36d919c31aa752255f8 ]

acpi_evaluate_dsm_typed() returns an ACPI package in pkg.
When pkg->package.count == 0, we returned without freeing pkg,
leaking memory. Free pkg before returning on the empty case.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Fixes: 337d7a1621c7 ("drm/i915: Fix invalid access to ACPI _DSM objects")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260109032549.1826303-1-kaushlendra.kumar@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit c0a27a0ca8a34e96d08bb05a2c5d5ccf63fb8dc0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/display/intel_acpi.c b/drivers/gpu/drm/i915/display/intel_acpi.c
index 68c01932f7b4f..e06f324027bec 100644
--- a/drivers/gpu/drm/i915/display/intel_acpi.c
+++ b/drivers/gpu/drm/i915/display/intel_acpi.c
@@ -96,6 +96,7 @@ static void intel_dsm_platform_mux_info(acpi_handle dhandle)
 
 	if (!pkg->package.count) {
 		DRM_DEBUG_DRIVER("no connection in _DSM\n");
+		ACPI_FREE(pkg);
 		return;
 	}
 
-- 
2.51.0



