Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ECC78C67;
	Wed,  7 Aug 2024 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043394; cv=none; b=MBWLxQbMHXayrgn/TeCtCRbPNXBjOyO4dWHn3Ub0JQN4Jn1phRWSZbnv6X9EzGEOTz9poOWVPa+GJvhFYZRYcwhu07xIDncyofVe4COwrwuBByKXtxfgPyQP6ObBge5OZ3b5YaRqnixqj3JdyBpnOmgzv19KV6l8DYO/XSCXS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043394; c=relaxed/simple;
	bh=3emXs9g3qLZ5oBCxqDhuyllD0aqGXHSO/Aky3frNW9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC42Zt6sM0Ekt5a4oN5kXVHzPMAHO2C+iBAfQl8Ahtrs+I+fgO1VBdwAU2v28A82lGl5TR5gwOHNNTnXv/9gwQBeqN7/M3SnIqk3HWiFW8vli6oI6YyCyaOaCAYZX+m2KeuKF/OfKY1cc6nsKf8UHKM04zJlr3BfNIR8fBS1VrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I32oCxzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I32oCxzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AA4C32781;
	Wed,  7 Aug 2024 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043394;
	bh=3emXs9g3qLZ5oBCxqDhuyllD0aqGXHSO/Aky3frNW9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I32oCxzy9ao9CFyQuAbPYbfsx2HfD5HIajsetY47mFHvQJFspRUa2bOegItIPcAot
	 V1I5bp/4h32T6cffEVB7x28uXgFUvZ9k7qoASzfFs3h8eRllZONdENsxScva0iWXdH
	 2V2eowYyQS/pCJU6MTnhE1AyaTCRlLWt94evxITk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/121] drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro
Date: Wed,  7 Aug 2024 17:00:06 +0200
Message-ID: <20240807150021.829804716@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 555069117390a5d581863bc797fb546bb4417c31 ]

Fix HDCP2_STREAM_STATUS macro, it called pipe instead of port never
threw a compile error as no one used it.

--v2
-Add Fixes [Jani]

Fixes: d631b984cc90 ("drm/i915/hdcp: Add HDCP 2.2 stream register")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240730035505.3759899-1-suraj.kandpal@intel.com
(cherry picked from commit 73d7cd542bbd0a7c6881ea0df5255f190a1e7236)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp_regs.h b/drivers/gpu/drm/i915/display/intel_hdcp_regs.h
index 8023c85c7fa0e..74059384892af 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_hdcp_regs.h
@@ -249,7 +249,7 @@
 #define HDCP2_STREAM_STATUS(dev_priv, trans, port) \
 					(GRAPHICS_VER(dev_priv) >= 12 ? \
 					 TRANS_HDCP2_STREAM_STATUS(trans) : \
-					 PIPE_HDCP2_STREAM_STATUS(pipe))
+					 PIPE_HDCP2_STREAM_STATUS(port))
 
 #define _PORTA_HDCP2_AUTH_STREAM		0x66F00
 #define _PORTB_HDCP2_AUTH_STREAM		0x66F04
-- 
2.43.0



