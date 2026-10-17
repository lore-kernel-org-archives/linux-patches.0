Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3743AF66D;
	Sat, 17 Oct 2026 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255874; cv=none; b=oAPl9JzrbufNZqwirTW16IvWgyYOB6E98MGE+s3qW0on2WA80c4bKaoEA3imuLJ9/+pNwKB4MwLMLjLPJstGwrxpewuklkTc67Ei07iNqIsFDnUgx3DsE/wYLB39od3AOY3eNY1v1vXIe9WeDeRIwOyCo0TmBrYgkhJPrGOgSmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255874; c=relaxed/simple;
	bh=GmMVmUN0axc8J2TIqohvBB/yxtEZPy3tTHwQ8ZrMMoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF+CffmURUPRpZ2T1ALFjH2YgevyPytOe3D878hmKewHLYKDtLNIM8WgIiL6TilEUkt96M42LGtrqedtPL1h/Tq9TQ+gTgt+xGqkdBok9nz7+oFHpk5t4ytMi898u4RBeE3SOJ1LEaMntFs5wd7nsuTjVIIC80H3oqnxRH6/Ya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbNhGRfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbNhGRfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D18C1F000C4;
	Sat, 17 Oct 2026 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255872;
	bh=I+9XxJPJYtwoTXILhFhN+LLr27YzR9e1ceYdIdTFw20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbNhGRfbAladK9xHNWYd+I9wqcPWg/382bgyBw5m+DqipKWoQeRogowgRfVZAuyQT
	 ku+QfwtUR0Q7ABqwNFy2aWHyz1vvY+fOQVp4W8wk8lwfDnMS8KI10k6jUxEQd56IPV
	 d+mFEVWl4coHYpNC2TzPoe4KOPJlAq+P9yApJ+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0049/1674] drm/i915/hdcp: Add encoder check in hdcp2_get_capability
Date: Sat, 17 Oct 2026 17:38:41 +0200
Message-ID: <20261017160432.397721052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit d34f4f058edf1235c103ca9c921dc54820d14d40 ]

Add encoder check in intel_hdcp2_get_capability to avoid
null pointer error.

[ Backport to 6.6.y: this tree predates the later intel_connector
  conversion, so the unsafe intel_attached_dig_port() call is still in
  intel_hdcp2_capable() rather than the DP and HDMI shims.
  Put the same encoder guard before that common dereference and return
  false through the bool API when no encoder is attached. ]

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-3-suraj.kandpal@intel.com
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index f7987fb90bb1a..89e378f71d677 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -168,11 +168,16 @@ bool intel_hdcp_capable(struct intel_connector *connector)
 /* Is HDCP2.2 capable on Platform and Sink */
 bool intel_hdcp2_capable(struct intel_connector *connector)
 {
-	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
+	struct intel_digital_port *dig_port;
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	bool capable = false;
 
+	if (!intel_attached_encoder(connector))
+		return capable;
+
+	dig_port = intel_attached_dig_port(connector);
+
 	/* I915 support for HDCP2.2 */
 	if (!hdcp->hdcp2_supported)
 		return false;
-- 
2.53.0



