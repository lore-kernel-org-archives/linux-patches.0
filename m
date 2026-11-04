Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831260;
	b=vslYR1fESNI6CJ/cpiWY6JseporJsyezEMSQ84cNNvK8rgMTV6UVM2IeZrBVtJDJjJQt
	 yekiALzYy/0dc82d0jBmCPt9Wo0zYWW/ap35F6sMvYQRp/2GKAm+nZgmDPbf33emBxe3R
	 uJAme1fxwvJ22Uz5NlcNgXtcM807OBzEwwc0IV21w0kFN/mlMIVmE3sqxVV3RZbMOOgwX
	 0Qy6sII9iyCMy0jdVH3bzkkvubTIw0QLFxn/0yK3uqIgjtaBLPUY0B8geiVT7u8OenJPX
	 JiIRUtSZ3gN3pQO8wSeJCi5DOJTOnoTD/OtGL2dm8+5pYAzqoDpfed2URqNEMZ96rSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lyAnKR8PDODo0crG5tGUx+iEQBs4Ca7NnrXsM4Km+hk=;
	b=eGO08AMeu7wetWP7XcYG3q9cFqAnWcZlvbYEkOCMnovWTlZdluDxsi19ZucnzIgUiBIz
	 nxZIxOtEeJSg6o8ne4A5gKgwkDHYE5AzzLSOg7XThM18rhHQApdl+R0SaosvQNUykADYD
	 YL/ulkX3zuuTRnVm7LYdvuBNp3wqC3hC4JEbH6i6km/zYQ6Lnzr6C14wjfVS92BOHqfj7
	 W2GeEsafhF7DsQygXKIaAay9A6vDn/bbZQfLhG4qR/wqNtdresoMRwiOEzMOXorhkvlZ3
	 rckwTgDkD1T5wS1IjprkDjCbpntpGgc9n3+IufJNxfLpYGVtE1Cvni/P3DNUv//kDEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WK8NG0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B4606A33E;
	Wed,  4 Nov 2026 22:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WK8NG0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8251F000C1;
	Wed,  4 Nov 2026 22:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831260;
	bh=lyAnKR8PDODo0crG5tGUx+iEQBs4Ca7NnrXsM4Km+hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WK8NG0NPyBC21tOsiHZRB6NJnytFMnF4+jxsrCGqVaALppqSagrP8KxtnRriHOg7
	 cHezXMy/XoIIVtBDAtzT3kpkjEsBIPpzHQHfGkR/5XzEeaBwlt/3mWkScpEwwwIrc4
	 o+zP5suLhCtW4d6S/TegAx8kHzqWcSy7o/+mU1Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0598/1005] serial: abort TIOCMIWAIT on hangup
Date: Wed,  4 Nov 2026 16:05:31 -0500
Message-ID: <20261104211100.605021073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit eb35b73e133686e5b999eb7130c4e3d22fe03089 ]

Add the missing hangup check to the TIOCMIWAIT wait loop to avoid going
back to sleep (indefinitely) after being woken on hangup.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 94da7977f6774..80d1a1b0ba9c1 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1251,6 +1251,11 @@ static int uart_wait_modem_status(struct tty_struct *tty, struct uart_state *sta
 			break;
 		}
 
+		if (tty_io_error(tty)) {
+			ret = -EIO;
+			break;
+		}
+
 		schedule();
 
 		/* see if a signal did it */
-- 
2.53.0



