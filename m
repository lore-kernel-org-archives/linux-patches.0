Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6295E47F2FA;
	Thu, 20 Aug 2026 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248456; cv=none; b=TkjWRVpSqC7uzZ+kvfpOQM8OtzYp8KL3G2T+jwU0CEUaBEeYD07y2LEDClZcF9Lp4fi1cRp+gxTUpJVZYDBmqOm6pgT3owfhuSw3MHqzctwbXsFwBfoRC1jQA1B1Pk1TL9UnWutU6D2YvGVg1TSkFC8GV4LG3CHR4284yCaBYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248456; c=relaxed/simple;
	bh=3enS90YRkL0a1uOlpXEicLwJ+4aQ1Eobxax5LITYm7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSmLBv3Z/NboeKMPeUca7Wpv4s9ZOT0DVfdVzQnS89XQHCdAT7bngD2b3EV+xe3ZtKAjFXLhigo9J26aw6fJIsIqkjOPPcTNRXTu/P74yKg8rqF6r1TTzxwr9Dvid0uNFACyhv5ObZ3LeaxND7ohNmHbAgDJjRyMbq479Cr4fKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMqznHm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMqznHm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F891F00A3A;
	Thu, 20 Aug 2026 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248454;
	bh=Ikdl4JV6Ie2bPj5XRk+enJU+NfCj2PWdWh6BWdkrYhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMqznHm20qIggW6sOV3FXZ7UZi9x+YuwMVEJynglM27N2XnEPcQGTu4IN8Qu6n3cI
	 Pc9D9S8khKRfoh3UPySfmvqUyupY/0Y8Bwj2Fs7VCNRyxZ+vNlCYom3yZ/i0dB9En/
	 bAAqwEPIv/lR7H7/amdwYKQCoqcfqc3MG1fssC/I=
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
Subject: [PATCH 6.1 194/303] drm/i915/hdcp: check streams[] bounds before overflow
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145259.213476327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -98,6 +98,9 @@ intel_hdcp_required_content_stream(struc
 		if (!enforce_type0 && !dig_port->hdcp_mst_type1_capable)
 			enforce_type0 = true;
 
+		if (drm_WARN_ON(&i915->drm, data->k >= INTEL_NUM_PIPES(i915)))
+			return -EINVAL;
+
 		data->streams[data->k].stream_id = intel_conn_to_vcpi(connector);
 		data->k++;
 
@@ -107,7 +110,7 @@ intel_hdcp_required_content_stream(struc
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (drm_WARN_ON(&i915->drm, data->k > INTEL_NUM_PIPES(i915) || data->k == 0))
+	if (drm_WARN_ON(&i915->drm, !data->k))
 		return -EINVAL;
 
 	/*


