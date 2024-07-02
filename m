Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7AE1BD005;
	Tue,  2 Jul 2024 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941539; cv=none; b=Dhuxkc6WsfX0diYEooGiS3imcGoCkHFYFgsYtJyoW4/0g/JPjMa6GMtDJNylKFg9nA7sp+dwEtPbH3qejxFeUG9e5rhQAPAjiIlSKyJRtLn27M0whAdivf+s8d3CiYQ0RQxg0nSw2iwudkhr5Lx6/jmFHnIGTOgGuJrzO7WTLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941539; c=relaxed/simple;
	bh=Qa5fa6xJnKU3DxyMMmvznxd0V/fxpfDuZdEsnJcGT+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTrkQ1cWWMc0RtzlTRP3tssz9THusNS0VzVvTwCU7mdzcwY6cYQEbBqgrhJMZX+xFHHh6GrvEHiB7ztu1GIJBHoA32A8YUjlW2chR2Nxpw2P1EEVlnL+CDzVO1I2LoC9Mr8/zxGRQ3y6NSYWVQnfGER5iGAFRH80cWvv98zSFjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYm/ZDjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYm/ZDjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D6EC116B1;
	Tue,  2 Jul 2024 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941538;
	bh=Qa5fa6xJnKU3DxyMMmvznxd0V/fxpfDuZdEsnJcGT+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYm/ZDjboM11PlhA003idypNbKz/gvIWNkBfF1MlBBPOS7krRazj0JdHD9rOyYakz
	 Y8PjPx69azc0cH8T0d8Inm1SXbTqSBLhCSmntsjC1P+zc7Rc8TP/WZn0fYBea1WIgd
	 GSrGYnVTQKDZwqF53c5+70ejmDmaC3YmwRqduJc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 093/128] tty: mcf: MCF54418 has 10 UARTS
Date: Tue,  2 Jul 2024 19:04:54 +0200
Message-ID: <20240702170229.737376967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
@@ -480,7 +480,7 @@ static const struct uart_ops mcf_uart_op
 	.verify_port	= mcf_verify_port,
 };
 
-static struct mcf_uart mcf_ports[4];
+static struct mcf_uart mcf_ports[10];
 
 #define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 


