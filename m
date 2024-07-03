Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083A181B9D;
	Wed,  3 Jul 2024 11:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006170; cv=none; b=B/fEC7I2xBBkOs25cgNt71THUYeivhiaa3FCH7ugiZ5kkbDP0tS2RfJmKY4kY4pdLG8pfOti+yMga50xmRH1wU7nNdRO8x52aHpHXXO6hPA+H2RN62aZp0lMobQc8ZMveMGZ5tgU+vL41yggozPxJg1LlmBaDbggUGrAp15yJl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006170; c=relaxed/simple;
	bh=jwhC+EcKxa3uHmTg/N2xTMrKuYLNmW665vdptzOHy/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVCOvZ0eCkrt+7KWTTs/0VEEYoSajfwT82dTPTLV02DRuvtwfzX9J86WuCu5DV+bgWJ2o4iF9pWUP26uMa31TYj9UaM24nkxNnfZw5pcuSvRLk5ySnpTgtZCwFKTTtqbZXCltkDK6VE0JEgiJ4gtluHW4h7AtTnG0GmajWbi8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8wMQZ7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8wMQZ7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCBBC2BD10;
	Wed,  3 Jul 2024 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006169;
	bh=jwhC+EcKxa3uHmTg/N2xTMrKuYLNmW665vdptzOHy/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8wMQZ7fl15dsQQWE+wHKykMW8YYUBsxGXI+jw8W99poM9xX69GOGBMD8NqI5OFF8
	 RkbTPDABatnM47l6EVQ3YsoE93RYSbAzd+eNn7SrCLfF6gQkPYxTIbgFZUvB04HKIf
	 DFZhn2jhNn2GLY1ZFQ+0qLTUk85p/YHMptOs+LDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 324/356] tty: mcf: MCF54418 has 10 UARTS
Date: Wed,  3 Jul 2024 12:41:00 +0200
Message-ID: <20240703102925.372585648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -477,7 +477,7 @@ static const struct uart_ops mcf_uart_op
 	.verify_port	= mcf_verify_port,
 };
 
-static struct mcf_uart mcf_ports[4];
+static struct mcf_uart mcf_ports[10];
 
 #define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 


