Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C870145B0E;
	Thu, 11 Apr 2024 10:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830449; cv=none; b=GFYYP3wW3wONVoemX5DSiP7I2JYEsLRPG2BFQGnyX0GwD4uHtKfS6QKDiHTS8YiHKv9WfFMbE9oHJEjMC5oEdDibfWv8cFOoOKHhbOYa0TqnBM09W7hyP8mvBPSIG6Uw/lUqgS+H1RSyrH3DhmMptsF/zjiZuFejitCSDZ5bHxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830449; c=relaxed/simple;
	bh=ubdrJUNkFDSFUFFTw1mnZEvV9P1QRza1dyPgv7H/HDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoVOg6oUJsCCN7QsroB7GvGNYr8KsNvqYMS0ZFi46A9+mCs5gBVo0VRaf5SddWP9XIYin5snh6+4CH+vt+Z9eX2sk5kZzxdJXDb7f7lBoL8EdlZ26xuZ4q7ub76VMTeb6t6ZNWOiOJ1vPalZvE8PxMLyHebpIPa4qtW76wb6Llg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IapuUB3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IapuUB3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92440C433C7;
	Thu, 11 Apr 2024 10:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830449;
	bh=ubdrJUNkFDSFUFFTw1mnZEvV9P1QRza1dyPgv7H/HDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IapuUB3WTobfJCI5UwpFkNgR5uNbQQ+iUAJ/+wDZgdF64DCYwdlfV8QcJDmqpBzcq
	 nlCZZNBcPJlFayxTtoBTmLPkuxnjVIF48Fu5o+zQp/VirF0Q9ty/D2B/nAxE3z9IaW
	 VFIvDphRrDy7J5xbVylqHImX+iEmTEfTkCtPoKr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.8 142/143] x86/vdso: Fix rethunk patching for vdso-image-x32.o too
Date: Thu, 11 Apr 2024 11:56:50 +0200
Message-ID: <20240411095425.172877606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 4969d75dd9077e19e175e60f3c5a6c7653252e63 upstream.

In a similar fashion to

  b388e57d4628 ("x86/vdso: Fix rethunk patching for vdso-image-{32,64}.o")

annotate vdso-image-x32.o too for objtool so that it gets annotated
properly and the unused return thunk warning doesn't fire.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403251454.23df6278-lkp@intel.com
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/202403251454.23df6278-lkp@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vdso/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -37,6 +37,7 @@ KCSAN_SANITIZE_vma.o			:= y
 
 OBJECT_FILES_NON_STANDARD_extable.o		:= n
 OBJECT_FILES_NON_STANDARD_vdso-image-32.o 	:= n
+OBJECT_FILES_NON_STANDARD_vdso-image-x32.o	:= n
 OBJECT_FILES_NON_STANDARD_vdso-image-64.o 	:= n
 OBJECT_FILES_NON_STANDARD_vdso32-setup.o	:= n
 OBJECT_FILES_NON_STANDARD_vma.o			:= n


