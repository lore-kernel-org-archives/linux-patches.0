Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0DE1428FC;
	Thu, 13 Jun 2024 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280000; cv=none; b=rCb0pqwz4HAovi+aIGMaZstsSFFOFEqxc4dF0zZExNU2keEgXOe9NRLzFXicSo//PFVqIcZXEMQqHf8MhR8Ah/71r/mkXQ3cgF1xzy5it9r98arloC+DOIhb4BABKYDBBWKws/QZ5tpBPj9oGqDnQu4A6qRynq0SslvEX7iQMh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280000; c=relaxed/simple;
	bh=3SE9+E00d8f9kBWxMVeWSXR9WBbFyamWOpzZOKY8RFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxqTJ9MnrSosjikT23/QZUXZknL66C+61eVWyVDbeqksvpe/fdXiCICVTV0RzdqEybKRHJok4J3x8RWY8gv6FVLUOZT3XQlCGxS6wOK2rlDAAPApFTl2ZGdnUll1zaIphCSsEFVN+4cLOIZ/R3IQqB/dQ3QdspG5P3oGwYQ4KhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6E6hC4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6E6hC4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9DDC2BBFC;
	Thu, 13 Jun 2024 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280000;
	bh=3SE9+E00d8f9kBWxMVeWSXR9WBbFyamWOpzZOKY8RFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6E6hC4Uw5VCpyFvffZ2LqN2Hn6V1mDT9cckdIA5H2tzsTrdvpr/mNcY0kpAkPy6L
	 1ztbRKY9qvqMZffrR5RrFbiksIJzMAHilnID2QYut8oCKUuhEhIo7nhdOgTenNYFY9
	 13Bp44Y4BaOUnwSPCQ/3A7mUKm9Ii02Jsx/2O+Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/202] microblaze: Remove gcc flag for non existing early_printk.c file
Date: Thu, 13 Jun 2024 13:33:26 +0200
Message-ID: <20240613113231.931465293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit edc66cf0c4164aa3daf6cc55e970bb94383a6a57 ]

early_printk support for removed long time ago but compilation flag for
ftrace still points to already removed file that's why remove that line
too.

Fixes: 96f0e6fcc9ad ("microblaze: remove redundant early_printk support")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/5493467419cd2510a32854e2807bcd263de981a0.1712823702.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index dd71637437f4f..8b9d52b194cb4 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -7,7 +7,6 @@ ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code and low level code
 CFLAGS_REMOVE_timer.o = -pg
 CFLAGS_REMOVE_intc.o = -pg
-CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_process.o = -pg
 endif
-- 
2.43.0



