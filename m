Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F147ACC7;
	Fri,  7 Aug 2026 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114666; cv=none; b=M0eaJ9iHyPYti6O3QLnoe8pQaKYLxlIFSFNa+Xmtevoy2F4LYkQyApOkQdhChRJC3Jhj99c5y93xgUs/0tdxGfqSMLpoS+N2MQRkJZL1nY2kAXqlQ+ihUmEjE8nsZu+VugksD2LJrmQySBjjnPxrFzSsEeqJfrwVqHwYjj4PBOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114666; c=relaxed/simple;
	bh=rIrdEWTUB8YJ7PpoqcCJerD6nnu05w1X9GRYYcqz8EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaMcIdUNhQlkgVdx0GjAJ0egS5w+oYP267NO3gV5UywzX3yTfCp86fxYh+dc581dUJbxDHkh979ACkjdyCteggCNc5ARQp/4/dTrznXsu/jZ7jEREbkJca4Wj9FnO6uWzNaGT6KxR68PbJcGgERe2cnw1oLusL2nNMiaHcVmccw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBczjanb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBczjanb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F6F1F000E9;
	Fri,  7 Aug 2026 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114665;
	bh=MQFqIk1/6FsdMO3ZgwS8mzfxjC+YwigTYhZewv/qyt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBczjanbAOz1W8oTeTb/3RHWsqIn6xry8iPwK8QsCNoEweH3b5cVukkk9LVsJf3ra
	 chRzQSKqWDd0eSbln2IlR9jHDf5EPV6usKqiv+MCYiSqwM7x6W3O58rIqni8RSqcfW
	 ilDNEe3I2PudPsZbDhjn/k2EU0u9K2vtDnKvX2Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/337] drm/i915/vrr: require valid min/max vfreq for VRR
Date: Fri,  7 Aug 2026 16:38:42 +0200
Message-ID: <20260807143425.448207639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit f8a9262c7a6fc2de9802e14b0228114f0333869e ]

Ensure the EDID provided min/max vfreq are valid. Most scenarios are
already covered (by coincidence) through the checks in
intel_vrr_is_capable() and intel_vrr_is_in_range(), but be more explicit
about it. At worst, a zero min_vfreq could lead to a division by zero in
intel_vrr_compute_vmax().

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 117cd09ba528 ("drm/i915/display/dp: Compute VRR state in atomic_check")
Cc: stable@vger.kernel.org # v5.12+
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260625131040.1051272-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 1765cf59f517b02f3b0591fe5120930d08bddeb6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -46,6 +46,10 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
+	if (!info->monitor_range.min_vfreq || !info->monitor_range.max_vfreq ||
+	    info->monitor_range.min_vfreq > info->monitor_range.max_vfreq)
+		return false;
+
 	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 


