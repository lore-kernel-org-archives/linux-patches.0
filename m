Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4790F13774A;
	Wed,  7 Aug 2024 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042989; cv=none; b=PIBCZtQcYehtWr66LT32HXXkq8Y/8p1MzOx6KB6pgAAy712lFBg+8f9HgJ4Du8ysEI/srG5qLePvZCcKVTCISC1Md8F4Z9gB1KlCvlDb3HP+Vfwv2/TVyrpHeVS1xTvQ6k08ergyHAavrFaFeouZhDLR8S70L7ms5fUmYf+0isc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042989; c=relaxed/simple;
	bh=K9DxUFq1FbMdKQ4eQE6EE3JuEAa6ZahqOSgHbtb53Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXr6qi5RNIe0MFbFDIdpambbqtcit/KOTlxdgCLOvWXinHeGDLQkcJFmjWFBlEakvObZubQ18PRAGfK62YtCPg8haEqzGfSBFcDRmbOGrIerozjFZwjbFyC2+tmTbaNiZmSxy7zeZZ44xqa4XbXb+XJAysqIcfJ/XyXYMNTzPJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNwn1AES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNwn1AES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88072C4AF0B;
	Wed,  7 Aug 2024 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042988;
	bh=K9DxUFq1FbMdKQ4eQE6EE3JuEAa6ZahqOSgHbtb53Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNwn1AES2r+s9PGdO46c74yIAsHTHHxBFi9Sp5/tbA+AgWU7RUjwQz+AIQN55JtvZ
	 TQQd+Tn44HCZJZX0aY7Cvt5UsFbPWjrzPVGBS5S13nNguW05BTbQXbjqt3LUCdBmpC
	 4mowCmII9+ChWMF9qZVzDJcmoLOjnlbVmowc/cok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 050/123] drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro
Date: Wed,  7 Aug 2024 16:59:29 +0200
Message-ID: <20240807150022.443694192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a568a457e5326..f590d7f48ba74 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_hdcp_regs.h
@@ -251,7 +251,7 @@
 #define HDCP2_STREAM_STATUS(dev_priv, trans, port) \
 					(TRANS_HDCP(dev_priv) ? \
 					 TRANS_HDCP2_STREAM_STATUS(trans) : \
-					 PIPE_HDCP2_STREAM_STATUS(pipe))
+					 PIPE_HDCP2_STREAM_STATUS(port))
 
 #define _PORTA_HDCP2_AUTH_STREAM		0x66F00
 #define _PORTB_HDCP2_AUTH_STREAM		0x66F04
-- 
2.43.0



