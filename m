Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D905DFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C64FC4339B;
	Mon, 15 May 2023 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168375;
	bh=i7tkikb9B/v3/qphQrzliupINYsQvih68KkHmePpApY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhPHwu63NdaY4QMIWYaqiaI12hdgqErc6z6fEEG0JZN9smKG/v8ngaAcHLoaoVhrm
	 hcmdVU76j/jhNiijDAtHzamAeWd9HwGczVuNvG8qnq/skLRNliAOG/3mcbncBpc9Fy
	 UFUA2+yv6DFF4YSQcQh+/hOe1bDDJlGpezYeXHgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 009/116] MIPS: fw: Allow firmware to pass a empty env
Date: Mon, 15 May 2023 18:25:06 +0200
Message-Id: <20230515161658.592355692@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit ee1809ed7bc456a72dc8410b475b73021a3a68d5 upstream.

fw_getenv will use env entry to determine style of env,
however it is legal for firmware to just pass a empty list.

Check if first entry exist before running strchr to avoid
null pointer dereference.

Cc: stable@vger.kernel.org
Link: https://github.com/clbr/n64bootloader/issues/5
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/fw/lib/cmdline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/fw/lib/cmdline.c
+++ b/arch/mips/fw/lib/cmdline.c
@@ -51,7 +51,7 @@ char *fw_getenv(char *envname)
 {
 	char *result = NULL;
 
-	if (_fw_envp != NULL) {
+	if (_fw_envp != NULL && fw_envp(0) != NULL) {
 		/*
 		 * Return a pointer to the given environment variable.
 		 * YAMON uses "name", "value" pairs, while U-Boot uses


