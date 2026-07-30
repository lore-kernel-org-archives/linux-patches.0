Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CF40963F;
	Thu, 30 Jul 2026 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422401; cv=none; b=RC3FJhXaAEGRzik698UI/gk8oqOvzMfytrrPkDsCqEyUMrBVtLROlWGPUDo3UAPdoIJ81TtPgDWwdCcIGD4t6zfilc9uZkxEv8+s2qOQt9049dT1XSWU2XAOm24H7Q55wkRslyQjwWLXGs6uGvO9A3jLosJZlJAi64wFx23zy+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422401; c=relaxed/simple;
	bh=wuXcvpMbGc//w+48ZUbp/BdZnxL72UCZrkEHi8UzqhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJt4agsWuAhQOHhpwchHl2EdCV1FfitZ8Xq8pQwwILqmDW46/rWGO2xU6w6WhztQsv0OgwwFmwvzrPPNnig44QGpccrRbubSWaoaGVkKUdYw3Rq3/TOKoVW+rFFZOLB11PvZDgfXcysQyBBHMCj5sU1GTvmBk1JcMHbq0+9x6zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVyH1D6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVyH1D6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B381F000E9;
	Thu, 30 Jul 2026 14:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422400;
	bh=BErgptXc3HTs+B+GRilAfUvZtf55H8sL8qwD5HH/QEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVyH1D6feDiq7np1UUaSG+JdIm1KM3l9mu2Xs1ksXlcEO+vKgpTWpn85UzGSI/De0
	 q9mX8GkIm1aIQuM4AcHB+08vN6oHCcs/pPptx7gx3l3ZQmOcQEJE7NcmHxAmoaAO36
	 t3EVYJW9LbiUTIfM81dG0w6RdDEtPyumSn29XbJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.1 426/744] drm/i915/hdcp: check streams[] bounds before overflow
Date: Thu, 30 Jul 2026 16:11:39 +0200
Message-ID: <20260730141453.351422170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit bbb15a6b042d02e5508a02b4847e02d2579ee7bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -132,6 +132,9 @@ intel_hdcp_required_content_stream(struc
 		if (conn_dig_port != dig_port)
 			continue;
 
+		if (drm_WARN_ON(display->drm, data->k >= INTEL_NUM_PIPES(display)))
+			return -EINVAL;
+
 		data->streams[data->k].stream_id =
 			intel_conn_to_vcpi(state, connector);
 		data->k++;
@@ -142,7 +145,7 @@ intel_hdcp_required_content_stream(struc
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (drm_WARN_ON(display->drm, data->k > INTEL_NUM_PIPES(display) || data->k == 0))
+	if (drm_WARN_ON(display->drm, !data->k))
 		return -EINVAL;
 
 	/*


