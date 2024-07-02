Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE815218A;
	Tue,  2 Jul 2024 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941075; cv=none; b=s7lPEHLN5N7Cm7ikZaZNNcj7xJ+rRBmderTELQa+R0zA91JjtadSWYW2LwZi4xb8JFVe1cI7McV/pns8ySEnoslTiKAhaIFkyClqySDj4iiboKmVmvddB7ZasEqF5rwyW/7VlJXkS4nRBy5ukXWkwyOJ9AvdJrYRoyT9NabHx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941075; c=relaxed/simple;
	bh=F99BS3cEpkrByMkG4SajQFWcQFdd3sIT6QWC0yHR/V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zvygs0KvbFVcbcGeNps2XHuJl/9VgKuu+sqeKxcWpLnJgFv5fbfkfl9c77/lVgxYm8c/fkgygE1lVvuDg011TXoImthWBqHFn8CeUIB1KIPU99RPSMYPTBLCRi153UjCBXmC7yiEsBsTd1ARSqUGXEmQFlXGmEsVNYbdHkklLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgBkF8f5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgBkF8f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953B1C116B1;
	Tue,  2 Jul 2024 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941075;
	bh=F99BS3cEpkrByMkG4SajQFWcQFdd3sIT6QWC0yHR/V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgBkF8f5CFY3jBguJe1kla+N2+j1+XqKTqS3r6LyY+CZuTy0J0hX0qEtNErIP1z7F
	 uCs37DeHCXq++kx68BzxY2YQbLgnxm8QNARIWlFFsWf98tTA6kyO3JqSGnDp5dKGRF
	 0aURnoCRiYK+ja7AZwaij+yojNOmxzaKP7cbfeA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 121/163] tty: mcf: MCF54418 has 10 UARTS
Date: Tue,  2 Jul 2024 19:03:55 +0200
Message-ID: <20240702170237.632547459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


