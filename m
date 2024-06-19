Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E74D9EA;
	Wed, 19 Jun 2024 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803424; cv=none; b=BZ/RDDfcaR5xO52r1BiHEhaphPGQG+dL9YTe/oOvPzqQXm9Lo2EKDKpYca57lqcpzegqdYs5wDr+Uxz0sOdGYOitE+5jx0UF0xYkx7S+vOh6yICLL5lsw35ulKMlq7UDMz00jSgiqv2yNMSaPBtPbmZc+dwsZtKKW28MjF2+QTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803424; c=relaxed/simple;
	bh=r+mhcUL0/IaQgJX3DX+BfGuOPtX+7qTWD9qT8TP5qq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvJc3rLSj33KcgOlR7KwE/Ggo7oi/kBy3wCyoOrr7e6Kc4QSr6Bi6igRNvykvPtXhZBulvYBHongq4NIG1V3HKaRooL2Jl3+bgXzRkaOkdts48evvzsMPCByVnmyxVLO5xOuDO48QKDgK8YB+PzqO5ZMHKc2UB625Iz8bXX9/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krUEA1Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krUEA1Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE096C2BBFC;
	Wed, 19 Jun 2024 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803424;
	bh=r+mhcUL0/IaQgJX3DX+BfGuOPtX+7qTWD9qT8TP5qq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krUEA1Nt5lU1xDdX0l8up36l1gAcIijXzfNTsRNFJxnVW6YUxDaeHHJfoOXa8tRy+
	 g6RFZzN3vwXdCc2ktHvjbJvNyZzD6Mi4fIp3rIctX+RT/ogq+jrMUbZBYyDX8DQgF1
	 w0oLiD2vR42wOhEbt2sI0P7DZYgYCLYXyjN34NiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	stable <stable@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.9 245/281] drm/bridge: aux-hpd-bridge: correct devm_drm_dp_hpd_bridge_add() stub
Date: Wed, 19 Jun 2024 14:56:44 +0200
Message-ID: <20240619125619.391242954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 51474ab44abf907023a8a875e799b07de461e466 upstream.

If CONFIG_DRM_AUX_HPD_BRIDGE is not enabled, the aux-bridge.h header
provides a stub for the bridge's functions. Correct the arguments list
of one of those stubs to match the argument list of the non-stubbed
function.

Fixes: e5ca263508f7 ("drm/bridge: aux-hpd: separate allocation and registration")
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/oe-kbuild-all/202405110428.TMCfb1Ut-lkp@intel.com/
Cc: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240511-fix-aux-hpd-stubs-v1-1-98dae71dfaec@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/bridge/aux-bridge.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/bridge/aux-bridge.h
+++ b/include/drm/bridge/aux-bridge.h
@@ -33,7 +33,7 @@ static inline struct auxiliary_device *d
 	return NULL;
 }
 
-static inline int devm_drm_dp_hpd_bridge_add(struct auxiliary_device *adev)
+static inline int devm_drm_dp_hpd_bridge_add(struct device *dev, struct auxiliary_device *adev)
 {
 	return 0;
 }


