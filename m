Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8091922C4;
	Wed,  3 Jul 2024 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004249; cv=none; b=B7zehIPX3anpWQ121HdT+ZsyqswglLL865dFDy5vaSlUSfiub5agCxRMTjh1QlxSV/39czsbIZ0HA+VTjvX7iMei+eDLDf66cba3mTMbJM9zCPVgPfPZMabmq+c8kCq6CbnfZHkEtaDrfXDNed3kanPacWsBgKsPsft0l8v1nAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004249; c=relaxed/simple;
	bh=ZqM91dZhzYCsLQmh8gE9aNmNb3kcj3P1EKlztoHF3Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZsa0dvVZo5luVc/S1O9S1BX5yCElPOswq81OL9esELxVU3xhW9nf1pkfF8RAIxApcCF1hPv/jAHXTrJEDxispUuIpLds3h2nGGAPYGrSPXkdPlGlu6cU1FPp1qqcZO6V23ZCcGlwJPvyZ5piJdqd32Clha0t50px/mjBdu6afk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIAh3uP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIAh3uP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EE9C4AF0B;
	Wed,  3 Jul 2024 10:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004249;
	bh=ZqM91dZhzYCsLQmh8gE9aNmNb3kcj3P1EKlztoHF3Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIAh3uP3R3T7MktxG5slk3Exu5dt18mWzC8FnxKa+2vUEjunipFZgo+tTBV755UB7
	 25zxGdRFD/Lx6lOCzx5RbpASLi+FmLfvOwWeaaVX8kYMILJzjYxJlkYelbeKAJDQjy
	 S6TqYW3cvkDOSiUlrv8y2cYbMzYXv2ZBoh2an0/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 170/189] tty: mcf: MCF54418 has 10 UARTS
Date: Wed,  3 Jul 2024 12:40:31 +0200
Message-ID: <20240703102847.884236126@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
@@ -479,7 +479,7 @@ static const struct uart_ops mcf_uart_op
 	.verify_port	= mcf_verify_port,
 };
 
-static struct mcf_uart mcf_ports[4];
+static struct mcf_uart mcf_ports[10];
 
 #define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 


