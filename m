Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D31216E3B;
	Thu, 12 Dec 2024 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024466; cv=none; b=gCmzKmcIuEY8BmNeYZyRNGnj4eVEHrBZBeirGwQxKOsKCBVHheGpVQVEZftAelwSZ1/avgZm1x01l6qZj5Sr9Wd6j7Kb0L5laJnlhObMriIBoV7KXZ2Mp3M20qLsnSUJr8xb7+NivbI4wXlzuDmZjrZZgy7YevC3tM470qhAw10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024466; c=relaxed/simple;
	bh=BsW7Y5/8o866zgUA2jyE8X7hpq7die8MrvZxfnmANY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9iwmv6/T/MlOVR5So+qrSyI9GDW36ODmuL39WyR59uKJGHP7mtORD+gE4kb1HSfpmRnD0mlqHE7xlQq4b9uCNHDqCPjpow3X1GXRoNqZKL06gnR9YYhcQgJyBrf1NwOemInhhiSU4AaTyvDwQOgzBnB0MPIDCzFbN9txKCdCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgK9OmJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgK9OmJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F0EC4CEDD;
	Thu, 12 Dec 2024 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024466;
	bh=BsW7Y5/8o866zgUA2jyE8X7hpq7die8MrvZxfnmANY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgK9OmJt+Ed5bksgGxuBjBrF5L9Wsuj27pH8YIsZ4s5wXM2ub70enpl86aZX2MRUK
	 rz2g6fIhaeujL7BifTAXj1QQnhkMFbdwaQpvEyAs67d9qGFiDKeWMV88AcCkNZvJHb
	 4n0Py1ZNx95ZSRVlw8VCc0x2fkuP/3Ot76E/ZXbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calum Mackay <calum.mackay@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/459] SUNRPC: correct error code comment in xs_tcp_setup_socket()
Date: Thu, 12 Dec 2024 16:00:43 +0100
Message-ID: <20241212144305.693084228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calum Mackay <calum.mackay@oracle.com>

[ Upstream commit 8c71139d9f84c1963b0a416941244502a20a7e52 ]

This comment was introduced by commit 6ea44adce915
("SUNRPC: ensure correct error is reported by xs_tcp_setup_socket()").

I believe EIO was a typo at the time: it should have been EAGAIN.

Subsequently, commit 0445f92c5d53 ("SUNRPC: Fix disconnection races")
changed that to ENOTCONN.

Rather than trying to keep the comment here in sync with the code in
xprt_force_disconnect(), make the point in a non-specific way.

Fixes: 6ea44adce915 ("SUNRPC: ensure correct error is reported by xs_tcp_setup_socket()")
Signed-off-by: Calum Mackay <calum.mackay@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 4db9ad82a6c8 ("sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e0cd6d7350533..93e59d5a363d0 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2332,10 +2332,8 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	case -EHOSTUNREACH:
 	case -EADDRINUSE:
 	case -ENOBUFS:
-		/*
-		 * xs_tcp_force_close() wakes tasks with -EIO.
-		 * We need to wake them first to ensure the
-		 * correct error code.
+		/* xs_tcp_force_close() wakes tasks with a fixed error code.
+		 * We need to wake them first to ensure the correct error code.
 		 */
 		xprt_wake_pending_tasks(xprt, status);
 		xs_tcp_force_close(xprt);
-- 
2.43.0



