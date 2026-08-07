Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87F371D1F;
	Fri,  7 Aug 2026 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116538; cv=none; b=fJTOEmctRs0j2dmF5licFMXz14QnD/BJ08RCdEThVzRe9xXUl2M77jpPg/qURyOMgSeJ0X2li3fqBXc5SZnEP9aFJfw5bIDiu4qFvEenEsZTHV/wmvL5VwzfZQEz2jln7yJbBDMthp6NzTzHcyXeAiJq0b91qEM4EFmkTh8E8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116538; c=relaxed/simple;
	bh=9vwNDbw1U0Tq/cpzi79nCBtDUZDIn3FUeLgJdXeC9Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua3U91N3pRT+9ojwd34D6AlkgpHRkA0XueyJX/zMZu4uIVx1mpbYc9JRSaEQF1pjtWJ5pG2Jkm5gX30xqdlKVWCjYZkTWGHqIgWpx+MzqWa6fHuDb60bshuxZg8DiW88Nb7ve/XknDSVcrtuoxrkLroijyeB/GJg38ekbHOTxTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEC/HwvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEC/HwvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371FB1F000E9;
	Fri,  7 Aug 2026 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116536;
	bh=VEugMFFn5KzKB21WFq8HRJAffm+eswfSEzNXewzz06Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEC/HwvCZBKdjJSJ+62dGtUPOVrE0hxCkONrk9vF5MCNPISC0Y1rPEM9PvSHgb00+
	 3YU/gyglFFOv0n4UP6dOcs6WSsEGDebE6wC24/5psasoVRr+9+e9WEPLeMXNQKbeTR
	 5lSdk8J47Qofpe3OdAHb9o1uuh2BXt7s87db/g+Q=
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
Subject: [PATCH 6.6 258/261] drm/i915/hdcp: check streams[] bounds before overflow
Date: Fri,  7 Aug 2026 16:40:15 +0200
Message-ID: <20260807143420.985512671@linuxfoundation.org>
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
@@ -2321,6 +2321,9 @@ intel_hdcp_set_streams(struct intel_digi
 		if (conn_dig_port != dig_port)
 			continue;
 
+		if (drm_WARN_ON(&i915->drm, data->k >= INTEL_NUM_PIPES(i915)))
+			return -EINVAL;
+
 		data->streams[data->k].stream_id =
 			intel_conn_to_vcpi(&state->base, connector);
 		data->k++;
@@ -2331,7 +2334,7 @@ intel_hdcp_set_streams(struct intel_digi
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (drm_WARN_ON(&i915->drm, data->k > INTEL_NUM_PIPES(i915) || data->k == 0))
+	if (drm_WARN_ON(&i915->drm, !data->k))
 		return -EINVAL;
 
 	return 0;


