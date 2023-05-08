Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169B7168D5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8905FC433EF;
	Mon,  8 May 2023 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545406;
	bh=h/ZZrZjIbcp/u86Xg+7tLyYUAglheWMJobuIUAFJ/ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNX0PiQ/k2Rz/fd5gBrzG2KCdHah6R+vfzhFkGSDo8baI3POmr5uUK4hckK3Ukp6W
	 Ljk5NiK+MdrJN9Jluc5AtNfYVm6MFbAqbbasEmjYH/2txAg2Q79rZIHpui4Jcf0id8
	 6o3bZ53srTqa2NHlkwrrOgT9pzodXDwbmJW0DNZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 029/371] MIPS: fw: Allow firmware to pass a empty env
Date: Mon,  8 May 2023 11:43:50 +0200
Message-Id: <20230508094813.276548738@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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
@@ -53,7 +53,7 @@ char *fw_getenv(char *envname)
 {
 	char *result = NULL;
 
-	if (_fw_envp != NULL) {
+	if (_fw_envp != NULL && fw_envp(0) != NULL) {
 		/*
 		 * Return a pointer to the given environment variable.
 		 * YAMON uses "name", "value" pairs, while U-Boot uses


