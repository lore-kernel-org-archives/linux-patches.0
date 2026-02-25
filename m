Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21FF243376;
	Wed, 25 Feb 2026 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983567; cv=none; b=DRCBYpRqAgqxRxsJF7dbmq8L47N1FAGlZuhwLPmFVxZqSfynQANmOhVup+8a8Xm7TFGWPt+zFG3dfX/+mnvOI3havu2wVWkAZfBd4wJErE2KuXrNZx/5T1QaNeO3yyPJLQtuBoK0xTJznHTnrdsgzgR9ag/nLk7S33CqmogwFLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983567; c=relaxed/simple;
	bh=u0W2WLbSmGNtv4Hz+QZRFyUxoCehWJVdT/Gl14hZU3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw1hvPZvDXXozEeMRO/UojPuyAJj6dZlcOJxq8qKs9CAv+XOxdXtRKrRsW5x6oP0AZd5LycFvfNFUooz7Zd0hb+yzOmX4HjTAXLiUTVkCNw3tpsxwViRmwyHZzgRD0tWUyLhVDXQiyoMxU6lHvL6WdoOg1BlKsUlSGharOcCu3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1j/tf6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1j/tf6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A2C19423;
	Wed, 25 Feb 2026 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983567;
	bh=u0W2WLbSmGNtv4Hz+QZRFyUxoCehWJVdT/Gl14hZU3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1j/tf6n0syCtGdKfdU0cHfNbskjWEEAFtBvLK2L1sZ6pedtX7DKYVcAxydDQ6IYU
	 r/RAkLrpwF63lZRhHVESG/Rout4qRiPXz0VoZTtnMHgxCIMaHS/5PJVz8E7xUEM/jZ
	 nGaOvDhmtoyHFfOXi3O8WuNxaGTpGsFaaRc1GlMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 625/781] powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check
Date: Tue, 24 Feb 2026 17:22:14 -0800
Message-ID: <20260225012415.140848749@linuxfoundation.org>
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
index 0a0b85f4528b1..0f8abdc592bc1 100644
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



