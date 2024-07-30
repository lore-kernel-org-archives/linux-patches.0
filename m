Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8021A619E;
	Tue, 30 Jul 2024 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357766; cv=none; b=guXd8o1ywmM4RSXU5Av6IR8/aO+60qn/fpxuXbwQ43KIIuwIwvjw/6yDu+nYhykX4buVKSVV8pA8UIsE81vhG7dBaC4Sqvap6GtN/t6goeIyOxxQqBhPhYurBQCSbYIUhCr1ii6K9B4hp8SRKq4uDVAXX9PMrXqO20DKAUoA0cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357766; c=relaxed/simple;
	bh=ArQGZF2tc+bjuPtZ4NIHhCsjPPJxmO177d1xyAcS/dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vA5LFwXGo/+oOm7vK3n2LpTsUsw0cG3stbIpuCd/ACKM/n+wuxNa0mWuee3uN+RV9bz6wpFoteg2tt5DGNjGYAzEHAAMykhi70ufD2bvF4fHsErlpcEMbJzpn3xXuuwQkSRkXtwMaFmuMsD3kzRzepdqjHwV0Sw3GRbme/zGueI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=habBpcpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="habBpcpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F8C32782;
	Tue, 30 Jul 2024 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357765;
	bh=ArQGZF2tc+bjuPtZ4NIHhCsjPPJxmO177d1xyAcS/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=habBpcpzNqvHAQffvNARg0WiaddfrSVFGn96987zarlBCr/ogW8GhYUI998luR4CN
	 CiS9zc2u0KUMYkqKtkU/g7CDGxGFiPh4wLFwzVXRhJXbeAtS1ElgcKXN0FswIgHgi1
	 j664VE/P2pKf+TUObWaUA+dZfI0Wv6MGeQAb7ZnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 290/809] drm/i915/psr: Use enable boolean from intel_crtc_state for Early Transport
Date: Tue, 30 Jul 2024 17:42:46 +0200
Message-ID: <20240730151736.046660552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 0a8c581ce01c84214b8221fcc5d52b45c09d0007 ]

When enabling Early Transport use
intel_crtc_state->enable_psr2_su_region_et instead of
psr2_su_region_et_valid.

Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Fixes: 467e4e061c44 ("drm/i915/psr: Enable psr2 early transport as possible")
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240529093849.1016172-4-jouni.hogander@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index a2f7d998d3420..58769197a1277 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -659,7 +659,7 @@ void intel_psr_enable_sink(struct intel_dp *intel_dp,
 					   DP_ALPM_ENABLE |
 					   DP_ALPM_LOCK_ERROR_IRQ_HPD_ENABLE);
 
-			if (psr2_su_region_et_valid(intel_dp))
+			if (crtc_state->enable_psr2_su_region_et)
 				dpcd_val |= DP_PSR_ENABLE_SU_REGION_ET;
 		}
 
-- 
2.43.0



