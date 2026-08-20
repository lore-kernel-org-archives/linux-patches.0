Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FD847D932;
	Thu, 20 Aug 2026 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243690; cv=none; b=LUiokIgCxOPyy+zvFVxTM2eCYxAPNW38w7EffdQ+Y1WHq866S12HwiVzso8sPf/SfPfYJ5DPJRh0dXzzSRU0CFDkD0tbaO3rh0aGX9QC6JRrS4ZvRlH0w3sn4thXB3pd6wV4o1DaNnbVK54JT9puzEPB7DxKzkwA7jaWg7OT2FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243690; c=relaxed/simple;
	bh=xocHPQqGFjN+BpwDOdfznsqTAhFPEAbpNHsElSKlaa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyPORc2Jm/eiosfml6+JZZ0zoBozsmf4Em6Yd1jN6KlaPQx8Cmz50bltDwtxkSABSa2IgNnQltp2axtUHd0FIMB+Y+4z81HHriOUBwQkgEdp+g65LRS/Swv2Z3zGXeAa9YXj+TKdSlyyuJjavU+98BmqIR2XAu4FU3/wNCqLMjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMwuALtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMwuALtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3751F00A3A;
	Thu, 20 Aug 2026 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243687;
	bh=JbWitFQaabnlCzP6OC7wkcME9FypTpzPmOqBTjImH5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMwuALtxaNqdcJwZgEKY1cSlx5YZBwCA2VnnFWMb+QyFJZnS8opTOX84PvmXZIgCJ
	 uCEPsKKc8+6BMNsAe9+gCURsGBD3zeoJjGklf+b9LkGqYtgC1GInyYNtbPHEeiC6hZ
	 KFYar3HSJqR/Pkz0n0yZoSRLq7WkQB7urkSUV9fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/272] drm/i915/hdcp: check streams[] bounds before overflow
Date: Thu, 20 Aug 2026 16:56:05 +0200
Message-ID: <20260820145236.895224260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit bbb15a6b042d02e5508a02b4847e02d2579ee7bc ]

The data->streams[] overflow check is done after the buffer overflow has
already happened. Move the overflow check before the write.

Side note, emitting a warning splat with a backtrace might be overkill
here, but prefer not changing the behaviour other than not doing the
overrun.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: e03187e12cae ("drm/i915/hdcp: MST streams support in hdcp port_data")
Cc: stable@vger.kernel.org # v5.12+
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260625170304.1104723-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 9284ab3b6e776c315883ac2611283d263c9460fd)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -89,6 +89,9 @@ intel_hdcp_required_content_stream(struc
 		if (!enforce_type0 && !intel_streams_type1_capable(connector))
 			enforce_type0 = true;
 
+		if (drm_WARN_ON(&i915->drm, data->k >= INTEL_NUM_PIPES(i915)))
+			return -EINVAL;
+
 		data->streams[data->k].stream_id = intel_conn_to_vcpi(connector);
 		data->k++;
 
@@ -98,7 +101,7 @@ intel_hdcp_required_content_stream(struc
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (drm_WARN_ON(&i915->drm, data->k > INTEL_NUM_PIPES(i915) || data->k == 0))
+	if (drm_WARN_ON(&i915->drm, !data->k))
 		return -EINVAL;
 
 	/*


