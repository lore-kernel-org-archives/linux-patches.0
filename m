Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4862C30E85D;
	Wed, 25 Feb 2026 06:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002705; cv=none; b=I2VItDpzGJlQDrHhsqrBIR4Fe1ONxoA4uFgBaAjADGTNhagmGypBXIYjOwxjc7NlsAEWjHzFHqwHTnT3mIPrOqbudrj8spWFrmDfkB+dE4vqPij0BRAaI5hlFZhoNlGe0OELLLvF0F8e0MfB/FbdRc9+YiH5iZ9E++lrgmGVVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002705; c=relaxed/simple;
	bh=+13Ucbj4WeHDaMHJE0/v/p+oF7SWf+X1QunpZfE5Wr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPjDB0Zmd9EN8tubO5/pmOHTV07jBGD+07Ooggf3C8brow+UGI+JZq6gm9YCMZnw7lILc/VHSSoDzzMDWTeSJ9iICmD62ORuVJBFW0EMzFIxpaa8wAbyJ7vcoEqkl6O+Hpvwbgydn6DEy+v32YQaHVeEqMcixa3/1WiVPx5xQuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLfehNHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLfehNHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225DCC19422;
	Wed, 25 Feb 2026 06:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002705;
	bh=+13Ucbj4WeHDaMHJE0/v/p+oF7SWf+X1QunpZfE5Wr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLfehNHe73PLRDeWhZvCFx8MGFI+ah3pDSG7j2kEceoxTz7ZxCc/VeeH9bf5ZnSDl
	 E4QdBRoHP/HsjAW5ZiM6m3Hs8vRiQOgr/GeBRBFT90PU8NoNt//AEe3xCLwRFBuxda
	 RD89aZofwimm7mtAnmWTH5v8XCP3OemhyVosl5uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 504/641] powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check
Date: Tue, 24 Feb 2026 17:23:50 -0800
Message-ID: <20260225012400.734635230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit c7d54dafa042cf379859dba265fe5afef6fa8770 ]

On partitioned systems, multiple TPMI instances may exist per package,
but RAPL registers are only valid on one instance since RAPL has
package-scope control. Other instances return invalid versions during
domain parsing, which is expected behavior on such systems.

Currently this generates a firmware bug warning:

  intel_rapl_tpmi: [Firmware Bug]: Invalid version

Remove the FW_BUG tag, downgrade to pr_debug(), and update the message
to clarify that invalid versions are expected on partitioned systems
where only one instance can be valid.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260211223401.1575776-1-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 82201bf4685d4..34c0bd1edd61a 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -157,7 +157,7 @@ static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 	tpmi_domain_flags = tpmi_domain_header >> 32 & 0xffff;
 
 	if (tpmi_domain_version == TPMI_VERSION_INVALID) {
-		pr_warn(FW_BUG "Invalid version\n");
+		pr_debug("Invalid version, other instances may be valid\n");
 		return -ENODEV;
 	}
 
-- 
2.51.0



