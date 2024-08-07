Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4D374CC;
	Wed,  7 Aug 2024 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043740; cv=none; b=LwP2l5Xk1xNeB+gqHAuX5eejx2NX+3lb16yig6KMnigAuOyHjApmb2+SXPA7muo0zfeYja+QK5aee9nZRmAqD6EihjXk2KoCPgj9Atx0czAezEA/Od8vy/IFaEoY9cMbKl+tlh8Rs8Sm1fIR5mFYbH5gyEZThx9Sql6XkXWCQvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043740; c=relaxed/simple;
	bh=ETb6/VMCFLuMN4Z2o1+9kYr0afLZrGIJ2Jmc8v6IYVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2OuIU88M9Ed2izKcZCK9NGavZ3f7uHHkFXoIgp0DZWdOw94Ns2PLk3pXCj0cMeAVs07Er2WCnnVNBxKN9iwKOvn/B3Re2aW0ys7LoXupUHCQSE0ZRDruA58lHg73Kk6ma8OH0KqUcm0a+fUC9J0R+ibYuLmF6ThkiQoluBt0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFNqsTh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFNqsTh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB816C32781;
	Wed,  7 Aug 2024 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043740;
	bh=ETb6/VMCFLuMN4Z2o1+9kYr0afLZrGIJ2Jmc8v6IYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFNqsTh7uqLP0LjnHfY5rvF6jvGlLQm1iOrt88DHmjSJxWQVCvSoxL3tVDnZ75y3C
	 OeZXXcASMog8aKmieEUPmLC+UnbKlncvhMG6nFyQsrfyKHT6zx9c6VDFMfK/mgfGHi
	 HCKTVNOLA+BFpLeWqubu2oTHSASAXgm1Y/OR/FpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/86] drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro
Date: Wed,  7 Aug 2024 17:00:34 +0200
Message-ID: <20240807150041.053490558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a3733e8966c1..2702cc8c88d8d 100644
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



