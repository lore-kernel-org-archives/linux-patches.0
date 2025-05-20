Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D552441A7;
	Tue, 20 May 2025 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749204; cv=none; b=PZSPfrzQX4xKrblPZLpTWSsrXfI4y9b/mr4dI/h7o3mkyJqIXPYaQ0a5f5Q8Tlkh6MrFhLIsS4N79/rXIPFIi5clTwS2naH/qw4W4Hnej4LNr5XO/VXSGpgruAadRdOVXSi5urBg45vl96uxhT26dSAHMwEm46TltFA+CadjUqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749204; c=relaxed/simple;
	bh=78jOoa2fkmrRUz5KI1WdselxFG/x5BR2FGcpW3S7IgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LplR7/rgK60b3oV10kqGs4JlgQEjNVveLxFRWoiQOSsJKTFLj/ZhQTIhalnjp6mbFZCM89dAbMFrXeUYAI+tTha3yBRJFcG5ESWplSp49StC9Y+9PIig4WYQZgVkk50ybTf7WKdJFZVghtDCBNL1ypMvJj38yEVenzUjDXNXjPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfPUSmUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfPUSmUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE21EC4CEEA;
	Tue, 20 May 2025 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749204;
	bh=78jOoa2fkmrRUz5KI1WdselxFG/x5BR2FGcpW3S7IgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfPUSmUheN/vBLFrTSzFgyOzuOYif9p/vFMPcKikwa3ACJEpZYjJ1L9UKJ/sDFmhr
	 SXd+pNkIKp16PsTa7Wm/6DU9dszvULNmEO/McYwymdQJcQjsWde/R499OPu/cO3YkS
	 CIns6duQwuepu8Vt7NT/Dlia8SEfAoECFnlBAEHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Dave Hansen <dave.hansen@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 28/59] x86/its: Fix build errors when CONFIG_MODULES=n
Date: Tue, 20 May 2025 15:50:19 +0200
Message-ID: <20250520125754.980239893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@google.com>

commit 9f35e33144ae5377d6a8de86dd3bd4d995c6ac65 upstream.

Fix several build errors when CONFIG_MODULES=n, including the following:

../arch/x86/kernel/alternative.c:195:25: error: incomplete definition of type 'struct module'
  195 |         for (int i = 0; i < mod->its_num_pages; i++) {

  [ pawan: backport: Bring ITS dynamic thunk code under CONFIG_MODULES ]

Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -399,6 +399,7 @@ static int emit_indirect(int op, int reg
 
 #ifdef CONFIG_MITIGATION_ITS
 
+#ifdef CONFIG_MODULES
 static struct module *its_mod;
 static void *its_page;
 static unsigned int its_offset;
@@ -519,6 +520,14 @@ static void *its_allocate_thunk(int reg)
 
 	return thunk;
 }
+#else /* CONFIG_MODULES */
+
+static void *its_allocate_thunk(int reg)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_MODULES */
 
 static int __emit_trampoline(void *addr, struct insn *insn, u8 *bytes,
 			     void *call_dest, void *jmp_dest)


