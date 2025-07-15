Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDD2E7F1D;
	Tue, 15 Jul 2025 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587942; cv=none; b=ciC3N1jY/n31ETh4+e8jRZPYJL8v8xidkQx9ZRLBgZwawgdBvzSDY8VtL9a7zOieLZ4R/sYlSTBWH+ILiWPVfdLnQ/lImKaZlEdyqodAERfsMcfc3FZe3G87fV8qDUNtoenaHpyFF/RuNoo5rQiCNEBgJEXFnv/ASdGcU0RDjsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587942; c=relaxed/simple;
	bh=ugv4f2NURxPHzeTylyGyC1xqGMnZseQbg5wNLib4tgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksTJEFpt8eXxw/Kx1dwyZrgB6UKWMYcyMryotgXn9kMQUWtN1nm/NSgO3xXgIgPSwIWigm43NT5R/Y1xtHxNN4AEFiPSp17LaKG5y8387umAy5r9+kJJsykIBgtOhA9kTrsMHBdOX21/Qimux0yvAEDV0BayjHfo6NqAcK7+Hq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuzT33RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuzT33RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDD6C4CEE3;
	Tue, 15 Jul 2025 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587942;
	bh=ugv4f2NURxPHzeTylyGyC1xqGMnZseQbg5wNLib4tgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuzT33RAzufjGXTaOj7w9WZ1EdybbOdg7IFKUDb7PAEggd+5RuoAz+VhP+bsGk0Sz
	 BPZoNuYBciRTStQ4IgcEqSKjTPRfz8uES246Z7GTTlJtGKLLLHywJ4E6oZQmQxaCWM
	 De+EdM55tkqsZjoQOn0IevlKHixQSJRlzP22nOpo=
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
Subject: [PATCH 5.10 169/208] x86/its: Fix build errors when CONFIG_MODULES=n
Date: Tue, 15 Jul 2025 15:14:38 +0200
Message-ID: <20250715130817.751028440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -554,6 +554,7 @@ static int emit_indirect(int op, int reg
 
 #ifdef CONFIG_MITIGATION_ITS
 
+#ifdef CONFIG_MODULES
 static struct module *its_mod;
 static void *its_page;
 static unsigned int its_offset;
@@ -674,6 +675,14 @@ static void *its_allocate_thunk(int reg)
 
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


