Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41C53B5E1;
	Mon, 31 Aug 2026 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183939; cv=none; b=PSIPI+EMRQZLa+1diymc38v3RChpBv5WO6lcbsdrN8airEE6RgN+j4O/SsbctVkynaGhcEkhptNE55boDyb3AC9K3aN8v3hk4pRX/Y3I0bDlMpYP6nofm319S6d3jiMkv6I8I2bTmzH9CQ2XOmnDhQz3YWRydVWpZC7YzqgTWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183939; c=relaxed/simple;
	bh=n/Udyjt8mjyBpWXLrTaXaosM378HX+1fubE4lqYoBBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4TKkCFQ8cPtwLJ2DUiDwnNZdjRm0xfEDQIYXxbugsKwSlF6IiKnQ4ZWZ/Bfir/17iQy+hOMpTkx6WRkQkdVD8S64soavhUUWgINBm8wzTc7UL8wbGprmiIDqmspr5CdwODA4OJPouLat4Ksv0hdfxSXeHj8JxkxLSTCsyx8n5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX+LfFIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX+LfFIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721391F00ACF;
	Mon, 31 Aug 2026 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183936;
	bh=+ZrDhEmF8DUZxlNlL5yV3mYXP42xRdGkqYz51B1QWV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iX+LfFIe4ILNBeyJqrgReO6ao2z7QJf+3CBSq1pTchLLo/ATEF8kMVX9mHVZMAC1t
	 Y9zOk7sXItujlkC3b5Omh2hl2aW0WhfUhFzPHAfHoe6HzhoHUpj9Zig1nzA6xEqtAT
	 OAeJwewmWeJ3g2G5y28ilex1SEdT3q8a6Ygw7U1PwWXmWkuEOH3lDvI1kKoKqfizVK
	 91v1v6vzxZotC0BLeAe7d/7+Y7ddn7PNDqGuqIHDaSbMH4eHWUfQi9ZYxOrhSXYj9V
	 WgSlgjVaj0DznFPMaAgFHRAuRlqS33E1bDV0Qn7H4u/4scvKagLRUHrFDnYWRtyoly
	 TCMWq6C2TBS7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thunderbolt: Improve multi-display DisplayPort tunnel allocation
Date: Mon, 31 Aug 2026 09:26:59 -0400
Message-ID: <20260831133314.4125787-391-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit afe9021d63b46233f5c87d52b820fa26e7f562cd ]

When 3 monitors are connected through Thunderbolt dock to the system at
once, one of the monitors might fail to establish DisplayPort tunnel.
This happens during DP bandwidth negotiation - each monitor takes
maximum bandwidth that is supported and there might not be enough for
3rd display. In this case Thunderbolt driver drops DP tunnel and
'forgets' about it but with DP bandwidth allocation mode, that comes in
later, some bandwidth might be freed.

Make Thunderbolt driver check again if DP tunnel can be established
after DP bandwidth consumption changed.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The analysis is complete. A background `git log --all` search timed out
(as expected with that flag), but the review was finished using targeted
history lookups instead.

**Verdict for v6.18.44: YES**

This is a small, low-risk fix for a real multi-monitor Thunderbolt dock
bug: when three displays negotiate bandwidth, a failed third DP tunnel
is never retried after allocation mode frees bandwidth. The patch adds
`tb_tunnel_dp()` on the success path of
`tb_handle_dp_bandwidth_request()`, matching an existing pattern
elsewhere in `tb.c`, and applies cleanly to this tree.

 drivers/thunderbolt/tb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index b516b1ad83a19..c8dcb3ca45152 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2847,6 +2847,9 @@ static void tb_handle_dp_bandwidth_request(struct work_struct *work)
 
 		/* Update other clients about the allocation change */
 		tb_recalc_estimated_bandwidth(tb);
+
+		tb_dbg(tb, "checking if more DP tunnels can be established now\n");
+		tb_tunnel_dp(tb);
 	}
 
 put_sw:
-- 
2.53.0

