Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A31D6DB5;
	Tue, 11 Nov 2025 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822465; cv=none; b=IWjJhazhPHt400kEKeHraJX0yvfdWdB/DWNPN7X8IKXn+7ks2NLbgx2NRsgQbLUb7+rlBJlK1MuuRJJPZv9uUqakTRdEA1hPBToHUSdRDPmA7TxQUifabE05ESeDBht/Set7Vv8XWP6km0syzFzyk/0Nn+ug6TRHkzYr4shs66I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822465; c=relaxed/simple;
	bh=db/AwEpkCNfnTw8P/0YLETo9CGARNcuTTMb6Dx86CoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+Rf9fc10SliGX70hwwMnm+Ix4r+jRKP7ycPktf6qI8BpVCJ0/TRXsNubHdKFxXhM4AJrGSHeQxv55Rd6WS7yEopxTEhMjA6lbZlBbL2CpXEMZF5J6VeKrmDqF6FDJHF8x9yi4Rm+k27XtuZbQLAGI1Qbpou5sdjjswFvQrUJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip8gSeP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip8gSeP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93CC19421;
	Tue, 11 Nov 2025 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822465;
	bh=db/AwEpkCNfnTw8P/0YLETo9CGARNcuTTMb6Dx86CoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ip8gSeP9u3boTjtrXE6LK3dhrs0KJpJ0bimTjTD8r+oC3I4zIPMRGr56v29cJCG1m
	 PKFjUsCrBBixjPZ6/iwqHMKbOkwnhsA6QN4Lyt/jau2v5OHI5w66cUrQHAFlxhj/7V
	 9lNZp5fGCRRjBwjVrPET0tgfOLZu/QxWn+at2gZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/849] cpuidle: governors: menu: Select polling state in some more cases
Date: Tue, 11 Nov 2025 09:34:43 +0900
Message-ID: <20251111004539.128654010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit db86f55bf81a3a297be05ee8775ae9a8c6e3a599 ]

A throughput regression of 11% introduced by commit 779b1a1cb13a ("cpuidle:
governors: menu: Avoid selecting states with too much latency") has been
reported and it is related to the case when the menu governor checks if
selecting a proper idle state instead of a polling one makes sense.

In particular, it is questionable to do so if the exit latency of the
idle state in question exceeds the predicted idle duration, so add a
check for that, which is sufficient to make the reported regression go
away, and update the related code comment accordingly.

Fixes: 779b1a1cb13a ("cpuidle: governors: menu: Avoid selecting states with too much latency")
Closes: https://lore.kernel.org/linux-pm/004501dc43c9$ec8aa930$c59ffb90$@telus.net/
Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/12786727.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -318,10 +318,13 @@ static int menu_select(struct cpuidle_dr
 
 		/*
 		 * Use a physical idle state, not busy polling, unless a timer
-		 * is going to trigger soon enough.
+		 * is going to trigger soon enough or the exit latency of the
+		 * idle state in question is greater than the predicted idle
+		 * duration.
 		 */
 		if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
-		    s->target_residency_ns <= data->next_timer_ns) {
+		    s->target_residency_ns <= data->next_timer_ns &&
+		    s->exit_latency_ns <= predicted_ns) {
 			predicted_ns = s->target_residency_ns;
 			idx = i;
 			break;


