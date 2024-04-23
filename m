Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFA1420BE;
	Tue, 23 Apr 2024 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908706; cv=none; b=RXAwem3shV3Dc3Jo3UtIUuGNqwVrYOxfyPbxMIgyqC0QbVjH8T8NVNQz/Ymd6OOI32RdwN+skizKwd8JNLZTE0XhuAbWOTCIPyj008XoXPIsKzglYx+imSOUe5UlMqU6M//blN8P5/LBGFWXXpOmmq+C61qT48JMF6MNVQBVEAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908706; c=relaxed/simple;
	bh=4e1ZC0cP302gmIGUtbO5qi/rtqQgv58GLA3NySP4wrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5T4Qmx9E6mOAwYxixNv2Un19HYM6fQsOfP4iI+tmLUsCWZsvyFInqkLaTnfVIJkO4m8ixEAOijG3reIqwXTo5ZV3SofBGRRWORcyWZIPjBR37GfwnHZEKMW4FsURl5UfGr1NX4Dzq0Ndvly/LkqDqWHSILYdeWZ7okYb9CKJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9IK3lup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9IK3lup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4DBC116B1;
	Tue, 23 Apr 2024 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908706;
	bh=4e1ZC0cP302gmIGUtbO5qi/rtqQgv58GLA3NySP4wrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9IK3lupglwWyotmmvuCwwCTXWqGyQYVbfD7r/cJH8/bIrBnntotI23tSXjrxkWhc
	 Nzp2adESFnSYbDuV200Zw3L0n0tRvgAdfWleXcWJ9nR2PdhUBXXJ2tCIexzVjc2tT1
	 PDiUKgWJhnTg4KgrQOXOXwqhQmHjtHzALgMY6ihc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/141] thunderbolt: Log function name of the called quirk
Date: Tue, 23 Apr 2024 14:38:50 -0700
Message-ID: <20240423213855.261510671@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit f14d177e0be652ef7b265753f08f2a7d31935668 ]

This is useful when debugging whether a quirk has been matched or not.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index 638cb5fb22c11..13719a851c719 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -130,6 +130,7 @@ void tb_check_quirks(struct tb_switch *sw)
 		if (q->device && q->device != sw->device)
 			continue;
 
+		tb_sw_dbg(sw, "running %ps\n", q->hook);
 		q->hook(sw);
 	}
 }
-- 
2.43.0



