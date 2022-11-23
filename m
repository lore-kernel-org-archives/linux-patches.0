Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B031C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC07C433C1;
	Wed, 23 Nov 2022 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197472;
	bh=Pi1Rh5BKUq7UdB7u38NCY0wqfSGxl9jsX0lMoXfqTOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jr5XRcyoGs2WB8WlDHj6hh1oP956jlvnQFXOcAT5qQjQsbiEvWKgmUhQMiN5XdDZA
	 W43AOF7Kuj3NX/3SH8Jae0Vk02+R44SYuueUNgOXgZvZ+cKa+PPUhA6D7PdjKgi35S
	 PN7XjVdJzpdnMOB+CpdVPUxWfiABEjUW5Fy2EWFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.0 273/314] docs/driver-api/miscellaneous: Remove kernel-doc of serial_core.c
Date: Wed, 23 Nov 2022 09:51:58 +0100
Message-Id: <20221123084637.902950494@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akira Yokosawa <akiyks@gmail.com>

commit 3ec17cb325ac731c2211e13f7eaa4b812694e218 upstream.

Since merge of tty-6.0-rc1, "make htmldocs" with Sphinx >=3.1 emits
a bunch of warnings indicating duplicate kernel-doc comments from
drivers/tty/serial/serial_core.c.

This is due to the kernel-doc directive for serial_core.c in
serial/drivers.rst added in the merge. It conflicts with an existing
kernel-doc directive in miscellaneous.rst.

Remove the latter directive and resolve the duplicates.

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 607ca0f742b7 ("Merge tag 'tty-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty")
Cc: stable@vger.kernel.org # 6.0
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/4e54c76a-138a-07e0-985a-dd83cb622208@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/miscellaneous.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/miscellaneous.rst b/Documentation/driver-api/miscellaneous.rst
index 304ffb146cf9..4a5104a368ac 100644
--- a/Documentation/driver-api/miscellaneous.rst
+++ b/Documentation/driver-api/miscellaneous.rst
@@ -16,12 +16,11 @@ Parallel Port Devices
 16x50 UART Driver
 =================
 
-.. kernel-doc:: drivers/tty/serial/serial_core.c
-   :export:
-
 .. kernel-doc:: drivers/tty/serial/8250/8250_core.c
    :export:
 
+See serial/driver.rst for related APIs.
+
 Pulse-Width Modulation (PWM)
 ============================
 
-- 
2.38.1



