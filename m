Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95B911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0BCC433C8;
	Mon, 28 Aug 2023 10:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218192;
	bh=L932I2SPUfhu5cKo2yFi6bQJBkrvoE7Kry3Sl3ZxiUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auEHFdsAEviXXyX8AmmxTBv07GhgkSHoPDml+ZhSg+YNZmyTFsCrCpuFLUCqnfqdd
	 CkMOU0Z6vh7f7d5YXPvGNMjsuH0+/Prm0Ch/Ngnaxbvbwej5YPHABfK7xjd3X/4Umv
	 Wz3bW9yCOphWKy/xW82nmWUcwhRuO+LZqumDVN4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.4 128/129] TIOCSTI: Document CAP_SYS_ADMIN behaviour in Kconfig
Date: Mon, 28 Aug 2023 12:13:27 +0200
Message-ID: <20230828101201.736785943@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

commit 3f29d9ee323ae5cda59d144d1f8b0b10ea065be0 upstream.

Clarifies that the LEGACY_TIOCSTI setting is safe to turn off even
when running BRLTTY, as it was introduced in commit 690c8b804ad2
("TIOCSTI: always enable for CAP_SYS_ADMIN").

Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20230808201115.23993-1-gnoack3000@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -164,6 +164,9 @@ config LEGACY_TIOCSTI
 	  userspace depends on this functionality to continue operating
 	  normally.
 
+	  Processes which run with CAP_SYS_ADMIN, such as BRLTTY, can
+	  use TIOCSTI even when this is set to N.
+
 	  This functionality can be changed at runtime with the
 	  dev.tty.legacy_tiocsti sysctl. This configuration option sets
 	  the default value of the sysctl.


