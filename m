Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A81E17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB7C433C7;
	Wed,  9 Aug 2023 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580999;
	bh=4gG4HTtJq5GYW2t85PgjXF5Oe/7U9QFro0wtt+5Xqok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFnbYovgaU8KGYCrymq/5WYBM6Im6vLamY7W/4GpRCB4B3zL/7m8a4HCJRWX68H6b
	 jxXjby3CU5HTy8r8ql9p50wtAARCrMy0wE9tyXGE0ZPE1TEAKFRyeQkkw2VznNh+fw
	 d2evgahITSf0BK99vXsFgbfxinKOpcQq0E9seQTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH 5.10 069/201] serial: sifive: Fix sifive_serial_console_setup() section
Date: Wed,  9 Aug 2023 12:41:11 +0200
Message-ID: <20230809103646.139547153@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel.holland@sifive.com>

commit 9b8fef6345d5487137d4193bb0a0eae2203c284e upstream.

This function is called indirectly from the platform driver probe
function. Even if the driver is built in, it may be probed after
free_initmem() due to deferral or unbinding/binding via sysfs.
Thus the function cannot be marked as __init.

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Cc: stable <stable@kernel.org>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20230624060159.3401369-1-samuel.holland@sifive.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sifive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -844,7 +844,7 @@ static void sifive_serial_console_write(
 	local_irq_restore(flags);
 }
 
-static int __init sifive_serial_console_setup(struct console *co, char *options)
+static int sifive_serial_console_setup(struct console *co, char *options)
 {
 	struct sifive_serial_port *ssp;
 	int baud = SIFIVE_DEFAULT_BAUD_RATE;


