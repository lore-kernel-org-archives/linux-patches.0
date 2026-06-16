Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C82F12AE;
	Tue, 16 Jun 2026 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633284; cv=none; b=TCafeH84bLw24GcrVxImzS97jEmCzrfmZJaaAlSPTryKcG0npJpZmbdTrAlE/hIvbEwD/ZhgE1Gba3ADllq40YSN4SWAKbulf4Chh5fm6f1p1OPXGdxTM4KGBzzwrJLmcJ2fw6ZbSKCUivc+NMELqUeUuRhgcvCj8p23lRPN0sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633284; c=relaxed/simple;
	bh=VcNAlS1zq6Rolxoic8cf6UZrlS+8SvI5mBRAdINonBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sV9l3xw3J28zhlakmR/VC6FEtWuhamnP6ru+YD7UQtwgA8h7BGY2RbES9AgxKdPzH4pcgiiNCLFe7C6ex66AexbEWoaa1sEP5+Kn+JJ8Et8huKG+2v2OaRW31c8n7tlfklo5HXoEy+hl2ReL7p1PohJfeHcrmYMGs6Fc3nuCqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+Wox4ko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+Wox4ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0221F000E9;
	Tue, 16 Jun 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633283;
	bh=ZhLg3T0tSAwTAO2LaAjDoT6ASwq1Gz8lwSOwQgOqQlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+Wox4ko0baltfiDjja6ARLeA7Dacq2vF4+bElsnS0m9us48RNPtCU4O5Oxbkh1vA
	 mhuNEl0jAcTlMAff2/CEDxF/s/zzgAEQwnu6cLG+xAAwooJrgdlhHVhAtFFiokl4oU
	 Anmt68ArbN0wDl4GslzR/2UBTmXBqZtzsbKQK3AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Ben Kao <ben.kao@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/411] drm/dp: Add eDP 1.5 bit definition
Date: Tue, 16 Jun 2026 20:24:46 +0530
Message-ID: <20260616145102.833289274@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 5dfc37a6b77bf6beedbd30d70184b54e1a08ccac upstream.

Add the eDP revision bit value for 1.5.

Spec: eDPv1.5 Table 16-5
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Tested-by: Ben Kao <ben.kao@intel.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250206063253.2827017-2-suraj.kandpal@intel.com
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_dp_helper.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index 9c7949ebc159eb..01422c2078f7db 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -942,6 +942,7 @@ struct drm_panel;
 # define DP_EDP_14			    0x03
 # define DP_EDP_14a                         0x04    /* eDP 1.4a */
 # define DP_EDP_14b                         0x05    /* eDP 1.4b */
+# define DP_EDP_15			    0x06    /* eDP 1.5 */
 
 #define DP_EDP_GENERAL_CAP_1		    0x701
 # define DP_EDP_TCON_BACKLIGHT_ADJUSTMENT_CAP		(1 << 0)
-- 
2.53.0



