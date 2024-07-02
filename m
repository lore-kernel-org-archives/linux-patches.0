Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1690015B0FE;
	Tue,  2 Jul 2024 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940465; cv=none; b=OWCkpPMVx3GlXr36gtI4OMUTwb8ez3ks8iFV4uQ0/2NMYWSfOf33b4HXOEWzqlwAMPGAsUf4fZ+NUMUREuAF6WjCz0/Y7ozR8Dw3e5Y6LlVuc4/nsw3a9a6y0Q2emVBC/iZ7i62CrbmczzoVLKx/A1UOs07kpuHolOIJx0jqZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940465; c=relaxed/simple;
	bh=sNicwKdJyLHuiWQmAYd/4mgyZLj4oIF775P16CaBxDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYBEvPwop3z2u6/Lt0aBtMEhK+z5uOg7BaFeGpEHrvfn91sGWgbD+Dq/HYFypqnDDU8Thc3KZdGdxAwd5XxNA4d+tFxmw+CsCGSIoUHRYEovuGSs0DohU+Y0luVlJfoI7+EHYxi5n9B8hSGu7PCgoZp+hK6/6+K9I9E8lTjUuyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3UtzOY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3UtzOY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774CFC116B1;
	Tue,  2 Jul 2024 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940465;
	bh=sNicwKdJyLHuiWQmAYd/4mgyZLj4oIF775P16CaBxDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3UtzOY0/abQFcHY5iDKT8pFVqlO0X+t3b1fQVk0faPu0ybusVJ15fqwUAA6SHmC4
	 0mmYM9g1Nc3ABSme3LEDDn1fyk1Nj6HtLSH3n1xXIKQ3bevwtDQxjjFab4ej++H/r1
	 2t85/F+X+/gu806YDqaQ+crhtyTc/VUyqJbVHLDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.9 163/222] tty: mcf: MCF54418 has 10 UARTS
Date: Tue,  2 Jul 2024 19:03:21 +0200
Message-ID: <20240702170250.207675158@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

commit 7c92a8bd53f24d50c8cf4aba53bb75505b382fed upstream.

Most of the colfires have up to 5 UARTs but MCF54418 has up-to 10 !
Change the maximum value authorized.

Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: stable <stable@kernel.org>
Fixes: 2545cf6e94b4 ("m68knommu: allow 4 coldfire serial ports")
Link: https://lore.kernel.org/r/20240620-upstream-uart-v1-1-a9d0d95fb19e@yoseli.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mcf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -462,7 +462,7 @@ static const struct uart_ops mcf_uart_op
 	.verify_port	= mcf_verify_port,
 };
 
-static struct mcf_uart mcf_ports[4];
+static struct mcf_uart mcf_ports[10];
 
 #define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 


