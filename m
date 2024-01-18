Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2F1774B;
	Thu, 18 Jan 2024 10:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575519; cv=none; b=A4K3g2td+6LjPpVVzMbcPbgpBn7cE4WTaA7WvaDOoNvr/nILRrjMUbIiW1Hl47M2433Tv5pLZaJNwP+XH/Kp8WQZpNgpIbWttlaM7v2jYrNeRRH5Q0ei60PkNjcWjWJl7l5qZgCSgnlq4L2rJi8ASaZWIeg2qWTtq5AM+dc3rfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575519; c=relaxed/simple;
	bh=9Oso+WsbQiZMQ3VHcHy13nSf0aERGX/q8RJixopuYzc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=sGjGoKGTDL4WzjZezHGUm7OGrmKnuHwuLRuqDHuguFw7t5ijYEmR2AFBJMoHsm1dD9TjZYPnb3+gUel1VsgGJsyl/R7MNUumPlqs+ZSDJ68Ki8Jfdx0MK777ZysyrkxbkOS23Xr8FHH7me5cddaPcgQ6eXK4ZCC0BlL5OdjURfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fd5gmBvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fd5gmBvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A58C433C7;
	Thu, 18 Jan 2024 10:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575518;
	bh=9Oso+WsbQiZMQ3VHcHy13nSf0aERGX/q8RJixopuYzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fd5gmBvq+xAiXAoXX3Ga+qTaok1omSYLltY1PIkJs9n2Yo52rXK+ki1yJAZSjp5ya
	 l2DSZAOxVdXSmqy4JwMJMEgg/rj1fr9KRDe9Wh2MQP4JOryIjLwOGz4+vo5D3QViGl
	 nIkl7vNx0aA2wa3Gx8AIh6hvXE/kQQnopepoBe60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/100] drm/amd/display: update dcn315 lpddr pstate latency
Date: Thu, 18 Jan 2024 11:48:19 +0100
Message-ID: <20240118104311.366737826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit c92da0403d373c03ea5c65c0260c7db6762013b0 ]

[WHY/HOW]
Increase the pstate latency to improve ac/dc transition

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index 893991a0eb97..28b83133db91 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -324,7 +324,7 @@ static struct wm_table lpddr5_wm_table = {
 		{
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 11.65333,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -332,7 +332,7 @@ static struct wm_table lpddr5_wm_table = {
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 11.65333,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -340,7 +340,7 @@ static struct wm_table lpddr5_wm_table = {
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 11.65333,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -348,7 +348,7 @@ static struct wm_table lpddr5_wm_table = {
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 11.65333,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
-- 
2.43.0



