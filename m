Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A526135F184;
	Fri,  7 Aug 2026 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116420; cv=none; b=jxsZhSAt3xtCAOzGBxDydQ88VvP2sisipztMNBLfv+RcX/4G3AIhErVqvdbWKxXcMg63OzWaUFr0fTXkY3Wbxw4KtjPFAHIaTtAAvXPTD6nlrMPdXOB/b9hamfPPuamtFg0WAZpjyENqAkh+5QY4Ux8aL27PL+uHf5BbLxb0cos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116420; c=relaxed/simple;
	bh=3ECmom7/A19c5xO5lZMQq1Jtjc2TGV5b9QgJiV3lXfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5bCbmdMJyYGPLz4LGrOlLqfLUiy+Sa4Qw/YXZUqhpwMGhm9Ec9vip9DyM2QcFfjxaPfZ3vTa7diwWTnfrd2ZlwhqbAgi+dgj8m6GsdeE9Tog4LWQqKQKQvJfy57DbEdcQvxXpKjMMYTBUpx5j3RfBG1Zvhi9GAUTahUoN2SdHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5YZnUbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5YZnUbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989E31F000E9;
	Fri,  7 Aug 2026 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116419;
	bh=9K3dH3pYWR3LnAGLSnCO2L9gjxo6JBp2GwNt5o9BLeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5YZnUbeXWPpTUNFfg7QChFLIECkvsELHaa5h2oBbnhIXkoqzx7kJ4CCtQoUvDh63
	 zkXWML1Yv++c3sMASlnxNdIqbRAMmE0knjLrnh9c5WlFfGZf9PNZLU9sQ62b3sBeZ4
	 MNv2KFcK+A28lHTgobIySd6pUZHds2J64PfT5A3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/261] drm/i915/vrr: require valid min/max vfreq for VRR
Date: Fri,  7 Aug 2026 16:39:43 +0200
Message-ID: <20260807143420.246522324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -41,6 +41,10 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
+	if (!info->monitor_range.min_vfreq || !info->monitor_range.max_vfreq ||
+	    info->monitor_range.min_vfreq > info->monitor_range.max_vfreq)
+		return false;
+
 	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 


