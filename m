Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E5A577E2E;
	Wed,  9 Sep 2026 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963019; cv=none; b=S9XwLFmbdvPWgeMyH8wcJLhWRBeabwvA4gWmYxZpSS7QozI0WvKidYTznJmm/gjqsy888YTlORAh6EZBgPr30tMfbscJDrEEErhej5F4VikU+cBktvP1aDdgxm925EJvJvtpkSZclGRWiG4NVq2c3AnqU6nWsVyylgy8UlkXQ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963019; c=relaxed/simple;
	bh=5zrQFuhh1BX2UkSOUjtpLUAO2lMhwh7HP3YFUuGAjMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXuvLBGWG0qiHXKu6doLikgxvbyMULGMlPTkZKAlLSl+BqgJIiiYyKtFg4iZn61+ZAMCZmhAdmF9vPVsAmeYC3E3LfA9HqnO25T3IDih8ZXJMQBSs/1U5qT2G+we1apMpKY63G99EAWUkXbbPe+9oZ8sCdWyzjGdthePi/NVgwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgolo/au; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgolo/au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2021F00A3D;
	Wed,  9 Sep 2026 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963017;
	bh=2lAFL/rRtb+VEvKUS4Epm9rJEGjjrPiyj78VRlQcznQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgolo/auw/agvnu66MB9IKj9GvMu2Wkshhl9XRvRi/TstDFy4MF19rP3yZ3BhUy0x
	 4UIvzFjG+K525pKnMekvVrWURoNL4BCAym5LhL+t6T9Kpf6fmOEZLtU5k/vlSYC6AD
	 q9A4d3QHJEwVC25ekIXKW6snWp3IYaeyG5XVQMSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 492/556] drm/amd/display: Remove const Qualifier From Non-Pointer Fields
Date: Wed,  9 Sep 2026 15:42:52 +0200
Message-ID: <20260909134247.795100384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

commit 93a77d353cb26772ae2fba50ae7321ae996b7f00 upstream.

[WHY/HOW]
Integer values for
dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_params
should not have the const qualifier.
This prevents using different values of the inputs when the
function is called again.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 342280aae4f33816e8d07c15cb538a3b375a7f8f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_shared_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -1748,8 +1748,8 @@ struct dml2_core_calcs_CalculateWatermar
 	bool UnboundedRequestEnabled;
 	unsigned int CompressedBufferSizeInkByte;
 	bool max_outstanding_when_urgent_expected;
-	const unsigned int max_outstanding_requests;
-	const unsigned int max_request_size_bytes;
+	unsigned int max_outstanding_requests;
+	unsigned int max_request_size_bytes;
 	const unsigned int *meta_row_height_l;
 	const unsigned int *meta_row_height_c;
 	const enum dml2_pstate_method *uclk_pstate_switch_modes;


