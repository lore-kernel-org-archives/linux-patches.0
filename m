Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041358;
	b=S3tP2AS4HMpZBP8nt/v2ckTAlbGbouc3O0/VyniWic2jDmOD8PDc7ziiMOlhf34zzDWk
	 YceIci5DcoS4dCT/oNtc2FiecVyInujwm1J45S9eDvSlalhCgrdkZcoKExLkRPwqw3iRu
	 an2OIZALEzDZ9Wf4d2OHXtOiDJf7/sVLfaxIg9BsEjwOeqfthETW+KIz4pvDqZwRb4+WT
	 JgoJulrRiWNkQ1MHrWPcJPhYzT/GjZsPGs3YbekuPRWxXw1ITJVlLRE+PHIzLr/4+P6nE
	 aKEpfnNq2mjxP+8Pqx8B7d+xOglKSCDYdxS0VH2NtZNhEW+zjVlPAEhSe5ifFtB6m3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yf4Pp0mM9dPHbbpRtwvz0ZhxkhkEXl0zsrHoZIE3Qcw=;
	b=Voh3edf1ejP0iNv3ssHiyYHPxczHnzqauL/deGvxbdVk0YXy2JF9MTIYfrEzdHRj9VmK
	 4KHjRLAZ2Z3V765tv2iCq5ccW+D7Vx+/cK3Jc9Xb7ILOA4WdV8ZZG5mGVDaLitKoxgu2o
	 uriE178TmiHfhXFA8zhchfucB38/tZctnGmYhF3t/sDuksYxNEwyqERDXr3aAV9VN6/9x
	 A70QrDNrUIdlePvgiCrp0X6aGF40YDTz/tPP+aX4vGYTuVdlslUR3+K8RCEJHjVsH9j6X
	 hRkZUQ7GrlFOb6WNnXDqP4nG1dTtNgx5NSapSTUgbqsReFXM64ygaixbI1JKQmLUNsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWS7AaCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5407E606A32A;
	Wed, 18 Nov 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWS7AaCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D631F000C5;
	Wed, 18 Nov 2026 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041358;
	bh=Yf4Pp0mM9dPHbbpRtwvz0ZhxkhkEXl0zsrHoZIE3Qcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWS7AaCq8FqsIoj2Gm4Ltxkx825Pv9yw5//BBBDppmtmyRNH3IXkO0D4l6fQwHIPs
	 HSQoXJWNjsysZB3vVc+sG3hJKKlB6YsELCC5twWsqy85YyHPqFDG1GaLaua8hMJ8x8
	 Js8Mzi6sxHPyC9wKGWqi8ksYrYoscIls9oYjMUfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2785/3318] serial: max310x: simplify probe() and remove() error handling
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150444.242832504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 5d888f1c32e2281843d58eef963e3ebd625b77a9 ]

Simplify error handling and only call uart_remove_one_port() if line bit
is set, instead of having to manually set s->p[i].port.dev to NULL.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-10-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 123a81976ee8f..ee754f23d91c2 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1451,10 +1451,9 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 		/* Register port */
 		ret = uart_add_one_port(&max310x_uart, &s->p[i].port);
-		if (ret) {
-			s->p[i].port.dev = NULL;
+		if (ret)
 			goto out_uart;
-		}
+
 		set_bit(line, max310x_lines);
 
 		/* Go to suspend mode */
@@ -1490,10 +1489,8 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 out_uart:
 	for (i = 0; i < devtype->nr; i++) {
-		if (s->p[i].port.dev) {
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
 			uart_remove_one_port(&max310x_uart, &s->p[i].port);
-			clear_bit(s->p[i].port.line, max310x_lines);
-		}
 	}
 
 out_clk:
@@ -1511,8 +1508,10 @@ static void max310x_remove(struct device *dev)
 		cancel_work_sync(&s->p[i].tx_work);
 		cancel_work_sync(&s->p[i].md_work);
 		cancel_work_sync(&s->p[i].rs_work);
-		uart_remove_one_port(&max310x_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, max310x_lines);
+
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
+			uart_remove_one_port(&max310x_uart, &s->p[i].port);
+
 		s->devtype->power(&s->p[i].port, 0);
 	}
 
-- 
2.53.0



