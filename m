Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A3F1DDF5
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa9Vez+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8B5C433C8;
	Tue, 31 Oct 2023 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698761714;
	bh=khGEn39FkvAPM0ASHtxtq/8OCG+nQQbqSlKOUDzMFzQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Xa9Vez+BVejz8noj+pxh5wXcQR93lIHaYfpK9mIUsRZSj+7FddLOXWet1K1WHvrgG
	 IbviM0NIqza8e/o7ku8o+Yqr3QgPfwbqWooqEs3IVYaAugB3HEUNIe8qdeWkULhV7E
	 FRB1Jv7tQio+y/nBaSNfGztVQhmEJsC8pvCelzyo=
Subject: Patch "objtool/x86: add missing embedded_insn check" has been added to the 5.15-stable tree
To: bp@alien8.de,gregkh@linuxfoundation.org,jpoimboe@kernel.org,jsperbeck@google.com,patches@lists.linux.dev,peterz@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Oct 2023 15:15:11 +0100
In-Reply-To: <20231028184131.2103810-1-jsperbeck@google.com>
Message-ID: <2023103109-pancake-jitters-c8b1@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    objtool/x86: add missing embedded_insn check

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     objtool-x86-add-missing-embedded_insn-check.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From jsperbeck@google.com  Tue Oct 31 15:13:57 2023
From: John Sperbeck <jsperbeck@google.com>
Date: Sat, 28 Oct 2023 18:41:31 +0000
Subject: objtool/x86: add missing embedded_insn check
To: gregkh@linuxfoundation.org
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, peterz@infradead.org, stable@vger.kernel.org, jsperbeck@google.com
Message-ID: <20231028184131.2103810-1-jsperbeck@google.com>

From: John Sperbeck <jsperbeck@google.com>

When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
was backported to some stable branches, the check for dest->embedded_insn
in is_special_call() was missed.  The result is that the warning it
was intended to suppress still appears.  For example on 6.1 (on kernels
before 6.1, the '-s' argument would instead be 'check'):

$ tools/objtool/objtool -s arch/x86/lib/retpoline.o
arch/x86/lib/retpoline.o: warning: objtool: srso_untrain_ret+0xd:
    call without frame pointer save/setup

With this patch, the warning is correctly suppressed, and the
kernel still passes the normal Google kernel developer tests.

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2202,7 +2202,7 @@ static bool is_special_call(struct instr
 		if (!dest)
 			return false;
 
-		if (dest->fentry)
+		if (dest->fentry || dest->embedded_insn)
 			return true;
 	}
 


Patches currently in stable-queue which might be from jsperbeck@google.com are

queue-5.15/objtool-x86-add-missing-embedded_insn-check.patch
