Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E62236EB;
	Thu, 12 Dec 2024 17:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025523; cv=none; b=XknbDQFe9DxjHPmbgnFAq4owr0cNrriHY6xibFg69R7o6Ue3zQAuMV6ah0OZaZn9c6txtaGHO8yrZzho51FF0CwXpzkZie/mrSI69VSeExwQsjbb+1bMvoCCazSd6vcr4eXR5Ddpmi2Y/aiBlsbmZ1ETA7DOSTsoB6hTLAgSzZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025523; c=relaxed/simple;
	bh=GE3N/0bVl7rmaBfzOkJdF8UIn/X6f3KqXIo0252gj+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpL+dGvgoSxyHaHMxLGmo43YgVxn8jFVbk6ADyi65nMFd5X8V7EJqizLjiQXFoDmUzao1/69xZre4RsKEwMdciwvcHXqDM45f63kjcQ5LSQYsjH8f3sdBBaYmYZWKj4cXRNhsgikqT9KD4CL8NrhG/BDB5Ltu8Dp31mNkPfJI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3Z4YZ2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3Z4YZ2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3402EC4CED4;
	Thu, 12 Dec 2024 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025522;
	bh=GE3N/0bVl7rmaBfzOkJdF8UIn/X6f3KqXIo0252gj+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3Z4YZ2b+WJ0HGZ2z4haM/olPZ5e0fPrqAAODO/0Y/ZeB5Cf+6ardM/6QCN9I0lLl
	 kFlQ2ueqGlVQfkQyBAEfV/ZcF50ZjUQGkraTXEXTGP8sNaNOwRM1h/ldEmBBipTl9Y
	 7KgPiA3ILZnE1qKWdoLiuPUMbO9duDERscpvVCQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calum Mackay <calum.mackay@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/321] SUNRPC: correct error code comment in xs_tcp_setup_socket()
Date: Thu, 12 Dec 2024 16:01:55 +0100
Message-ID: <20241212144237.762108174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index e88b9e53dcb65..ffa9df8f16796 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2455,10 +2455,8 @@ static void xs_tcp_setup_socket(struct work_struct *work)
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



