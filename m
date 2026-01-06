Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0312868A7;
	Tue,  6 Jan 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722611; cv=none; b=U9zNXTqhzgdepUb5f9+gPGdDwiQDrayL4ts3KnMwDMw0e/aOEMPrEp1OcFqrSp+QWkQ1xzVPgJ7/ElOBGt2CD3JqkYEx6Z9v2pGS2Cl6VcxX19UWqix/GdvSF0B3d4P7QKTInxkaetgNDutM/OKyRkkyfE17Zt48NmferUWXr98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722611; c=relaxed/simple;
	bh=CbC48C8ifEuE3rT20Z8/5U8LRcgBgxRxeSHKOEsq4Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMwDEwWyL+QDwcCda5rq2g4LClCP5zBlL3IjPhwe+waHDPqlyXbec7jvC0Ga5TB2s4jCIXc9vG3I2LdK9IqvcUnbd4u800nRRaboKhV1lDVZ3MfTJ3qFTP5Kf8Sg91d9fgG4ZDa3aR0atXo3IjJ2ZHXob3UIOgiYCIRGDpDQO64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdwMwVmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdwMwVmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733EBC116C6;
	Tue,  6 Jan 2026 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722610;
	bh=CbC48C8ifEuE3rT20Z8/5U8LRcgBgxRxeSHKOEsq4Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdwMwVmBdX0/L5mP/Pm0W9hlWSyQDSZyUNS8nXB2Z9LdruRmvUP6rNSaFc0If3ZBY
	 lBzcLtTSRLSVFygdxFmlBCkUlsh0WTkD3+I7EXRiRMcfjjXON6iGdKszNi2waK2Ait
	 nNmPRzxcjmlNLljR4TMNHrpxWFQy3EBay/ARoCY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 307/312] powercap: intel_rapl: Add support for Wildcat Lake platform
Date: Tue,  6 Jan 2026 18:06:21 +0100
Message-ID: <20260106170558.966493898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 39f421f2e301f995c17c35b783e2863155b3f647 upstream.

Add Wildcat Lake to the list of supported processors for RAPL.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20251023174532.1882008-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c |    1 +
 drivers/powercap/intel_rapl_msr.c    |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1284,6 +1284,7 @@ static const struct x86_cpu_id rapl_ids[
 	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&rapl_defaults_spr_server),
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_PANTHERLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_WILDCATLAKE_L,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE,		&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_U,	&rapl_defaults_core),
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -151,6 +151,7 @@ static const struct x86_cpu_id pl4_suppo
 	X86_MATCH_VFM(INTEL_ARROWLAKE_U, NULL),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H, NULL),
 	X86_MATCH_VFM(INTEL_PANTHERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_WILDCATLAKE_L, NULL),
 	{}
 };
 


