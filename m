Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F191FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEEAC433EF;
	Fri,  3 Feb 2023 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419362;
	bh=KQ9y8Mc7bgP2VUU9ZBrzR4RsNCqDtTOHRJ05YufIuPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjykXQyebLFIXVvmwmNJtaDo3a/6fTxYwWIxS76/no2oF4iNRLPQzpuIiXqViOZ1w
	 znuBpv5Zf8WwLRCLYrtcM9kdih6Wy5cP7dukrtg5gmusLnOcJw5SoWRJIyg1Zdyq6E
	 CI8tHsGMGbb1GnAgYMCEWRM8CIeWSIZHYV+O2x4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Borislav Petkov <bp@suse.de>,
	Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 4.14 44/62] x86/entry/64: Add instruction suffix to SYSRET
Date: Fri,  3 Feb 2023 11:12:40 +0100
Message-Id: <20230203101014.843236371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Beulich <jbeulich@suse.com>

commit b2b1d94cdfd4e906d3936dab2850096a4a0c2017 upstream.

ignore_sysret() contains an unsuffixed SYSRET instruction. gas correctly
interprets this as SYSRETL, but leaving it up to gas to guess when there
is no register operand that implies a size is bad practice, and upstream
gas is likely to warn about this in the future. Use SYSRETL explicitly.
This does not change the assembled output.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Link: https://lkml.kernel.org/r/038a7c35-062b-a285-c6d2-653b56585844@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1669,7 +1669,7 @@ END(nmi)
 ENTRY(ignore_sysret)
 	UNWIND_HINT_EMPTY
 	mov	$-ENOSYS, %eax
-	sysret
+	sysretl
 END(ignore_sysret)
 
 ENTRY(rewind_stack_do_exit)


