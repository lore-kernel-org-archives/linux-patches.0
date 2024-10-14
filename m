Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440F91ABEB8;
	Mon, 14 Oct 2024 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917051; cv=none; b=pRR6kHohBz6to9QndPuRJ0QppVb8rcKdqQvXZtRhUrquOeKy0WAE28250/VvJD8Lh0Y2HU0QTPeMuPO9WnGYEyLo2Iq8dAiSn6nrLzImbIoNSZQXWwzUqc3LPi9xe+1g+QmVqMr1pJbXFIdtrLGFRI6fytSCbldAu9UC/QYbsNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917051; c=relaxed/simple;
	bh=bUjUGXoEUN+x82ZmNR68nBO9tfCjC0zSUG/EwYBir78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9ODZv7EcXX7GZb3pzRchFa+flJHBgMNROrgtNE/lthCCLPi+kvJAiwXOjdtJvo/BBxlGkQdmnLAHwzj9l8tB28+HR3/Ntuq3c/3hz7ZQ5spCZ2/HnRd/isHBIt1shPSaLo4mr1xMOek4B7pwJ2lTlkFE7+XCKuDX3oXGcM7bxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQvrZEMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQvrZEMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3715C4CED0;
	Mon, 14 Oct 2024 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917051;
	bh=bUjUGXoEUN+x82ZmNR68nBO9tfCjC0zSUG/EwYBir78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQvrZEMW//YzdkfBDMMB5/UgsH/G43HVLZFdo+2AvTPQUuJNMhw03fzh3NZBz1zpM
	 dvbtVrAMwAgf8SFhhGs9mjRx7L6LMrhLj7pfTm5u0ZxeNPju9z5VytqtA4L+7sePJm
	 HkaMtToCg52bMcfqNeLwm0h1g3GIvPS/2l+YvMTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/213] platform/x86/intel/tpmi: Add defines to get version information
Date: Mon, 14 Oct 2024 16:20:43 +0200
Message-ID: <20241014141048.317259176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 8874e414fe78718d0f2861fe511cecbd1cd73f4d ]

Add defines to get major and minor version from a TPMI version field
value. This will avoid code duplication to convert in every feature
driver. Also add define for invalid version field.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20231003184916.1860084-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 1d390923974c ("powercap: intel_rapl_tpmi: Ignore minor version change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/intel_tpmi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/intel_tpmi.h b/include/linux/intel_tpmi.h
index 04d937ad4dc4f..ee07393445f9f 100644
--- a/include/linux/intel_tpmi.h
+++ b/include/linux/intel_tpmi.h
@@ -6,6 +6,12 @@
 #ifndef _INTEL_TPMI_H_
 #define _INTEL_TPMI_H_
 
+#include <linux/bitfield.h>
+
+#define TPMI_VERSION_INVALID	0xff
+#define TPMI_MINOR_VERSION(val)	FIELD_GET(GENMASK(4, 0), val)
+#define TPMI_MAJOR_VERSION(val)	FIELD_GET(GENMASK(7, 5), val)
+
 /**
  * struct intel_tpmi_plat_info - Platform information for a TPMI device instance
  * @package_id:	CPU Package id
-- 
2.43.0



