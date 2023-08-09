Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A8617744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1C5C433C8;
	Wed,  9 Aug 2023 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580605;
	bh=yhoxksJWk4aBYa84/5d32DUaqbwrJI//j6niLjHpYVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1IuTnO16mntkdMGyHSRi04tjAszXd+RD/FxP/3HMZr3ICI7NcAn8MMyo5gM+q8zL
	 ii3Wc1Bd4K2TQRZa6EpfQfi8A19IEAux9WpiZurJ17fzgj1ei2sERdiEy+l34pXlcQ
	 5yGz/AbBG/sOuj+HrB14ySy8nYB82XiS4SVvcn8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH 5.4 056/154] serial: sifive: Fix sifive_serial_console_setup() section
Date: Wed,  9 Aug 2023 12:41:27 +0200
Message-ID: <20230809103638.862992415@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
@@ -821,7 +821,7 @@ static void sifive_serial_console_write(
 	local_irq_restore(flags);
 }
 
-static int __init sifive_serial_console_setup(struct console *co, char *options)
+static int sifive_serial_console_setup(struct console *co, char *options)
 {
 	struct sifive_serial_port *ssp;
 	int baud = SIFIVE_DEFAULT_BAUD_RATE;


