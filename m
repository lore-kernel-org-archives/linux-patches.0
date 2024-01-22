Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F702371;
	Tue, 23 Jan 2024 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968195; cv=none; b=C45bns/bQ6bouhwOhoUQZ/Y9yd/uOYR9ilBa/IjoVqqVgCteO71zzmhDjwSKFaYSM6YdeQkh10xhwLW/QEe56BmnlGFGsEKY1cgB66teTYxIAOv3Z83i4uvsjD0L5Q5lhvYw+Tz8SYz3w/Qb5h+jt2WPClw5rl9TALAdu8COJFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968195; c=relaxed/simple;
	bh=rRi9vNZ3QsGLLIqGCjYYJzIj8trGWgxOacGZM1W3bHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEWeaS3nm6//yn6MXZ+/1JIc1T9hTo49ccAHAwOTfBDZJPq5Q1Cf4+x/1fKYk4w4f6wW4UIymORbcDhRV+Q8m6gFQFSkOHTc91G4chiBJRQy7E0oq1KtquX66cl9y0egcqoxYMGmwHhxNqycPATflSBuXVu89QvUXFBwyklKfZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoRN4oCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoRN4oCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11701C433C7;
	Tue, 23 Jan 2024 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968195;
	bh=rRi9vNZ3QsGLLIqGCjYYJzIj8trGWgxOacGZM1W3bHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoRN4oCA5sMPLFisGwEgJysb0BzMSoXYmhdTgXi5pg5CYl11HHdW7yU2w8HncF9/z
	 x4dY1EIi5vT5cZ/29kOvuY5TA1vyl0SWQ+IYjH5NlO4XcvseG5YE9jRTlg0gtfV8by
	 Nt5VXDovaK271fo+2YIZfXkQV1qNjKDFDsknLocw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/148] net: netlabel: Fix kerneldoc warnings
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235714.036043807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 294ea29113104487a905d0f81c00dfd64121b3d9 ]

net/netlabel/netlabel_calipso.c:376: warning: Function parameter or member 'ops' not described in 'netlbl_calipso_ops_register'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20201028005350.930299-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ec4e9d630a64 ("calipso: fix memory leak in netlbl_calipso_add_pass()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_calipso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 4d748975117d..5ae9b0f18a7e 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -379,6 +379,7 @@ static const struct netlbl_calipso_ops *calipso_ops;
 
 /**
  * netlbl_calipso_ops_register - Register the CALIPSO operations
+ * @ops: ops to register
  *
  * Description:
  * Register the CALIPSO packet engine operations.
-- 
2.43.0



