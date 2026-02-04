Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A92BE7C0;
	Wed,  4 Feb 2026 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218255; cv=none; b=ajeWbFyIe7gHbGCxHAsXpThUhs86zrEEfiGDyxy0F0hq50dW1XIiNblntnKx1OSAWYipAckHNHeDNFoo1C7Ga8lySDbf7sXlgUSmIXlYVXxyWVWTZDP7xtRfhMPWLkcjTUTgMRDDGRJz89B78rqrcd+kjJMYQDX4IzCcqTcuRSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218255; c=relaxed/simple;
	bh=joBswCl1KWS8qnbJF+KMMH43MMd130MXa710CeP9YDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2TOUl3eVFkY24WcoMoe+4vIbxx4GNXPBdrNRxVrdIgBFGLHpW6g80O6BRWTSs8jpUV1rECQ2mBsvmmX+AaVau9StoGdeyANPg5r6JfNlilYwCDAhvcguptsEOxP+lD7u28zUlpMdHSjbOUwpvi9r08sy7bcqetIgPQjzZCWiAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxgxDgrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxgxDgrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D2CC4CEF7;
	Wed,  4 Feb 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218254;
	bh=joBswCl1KWS8qnbJF+KMMH43MMd130MXa710CeP9YDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxgxDgrCeqAvLsnwDolqTmWtXocrEA/Pu21w7Md/vsaDx9uVJybQJCt3HpCe/kPpL
	 b+vPO4thYXxDR8jVT2AUezh/nP8lYQMxAeGrpB+1Mbvir+ovlY/IDadFhKYO6IXKgr
	 kucsa8UERpuxD9vdyk74QwK7JvktBKFZi/sVWYVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 257/280] drm/amd/display: Check dce_hwseq before dereferencing it
Date: Wed,  4 Feb 2026 15:40:31 +0100
Message-ID: <20260204143918.941868148@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b669507b637eb6b1aaecf347f193efccc65d756e ]

[WHAT]

hws was checked for null earlier in dce110_blank_stream, indicating hws
can be null, and should be checked whenever it is used.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79db43611ff61280b6de58ce1305e0b2ecf675ad)
Cc: stable@vger.kernel.org
[ The context change is due to the commit 8e7b3f5435b3
("drm/amd/display: Add control flag to dc_stream_state to skip eDP BL off/link off")
and the commit a8728dbb4ba2 ("drm/amd/display: Refactor edp power
control") and the proper adoption is done. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1233,7 +1233,8 @@ void dce110_blank_stream(struct pipe_ctx
 	struct dce_hwseq *hws = link->dc->hwseq;
 
 	if (link->local_sink && link->local_sink->sink_signal == SIGNAL_TYPE_EDP) {
-		hws->funcs.edp_backlight_control(link, false);
+		if (hws)
+			hws->funcs.edp_backlight_control(link, false);
 		link->dc->hwss.set_abm_immediate_disable(pipe_ctx);
 	}
 


