Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BFB1A76A5;
	Mon, 14 Oct 2024 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918700; cv=none; b=tBvvRtFyyKiV4YiduFm8p5wdSa16hYTbaViWT0JM4XazXscpW74uY8J8HVsbjlNcWbTDE/cHv+eAJiPF6n+J8N7ThNZLlaUuAGA0maShXu/VyrSZDN/zVPjlQ36sh6kNDepz3A+9RM+t1jajv5Ev22oxuLq9fSmdTyGnqph/oKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918700; c=relaxed/simple;
	bh=l4OKDOjK7mqsiNJLGQXZklkN8HPYEBR7u2peEy/vvtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU3CA8zqadHi9kGWVOpsD84Iy972YFYSTeJTsh0YqghOy14v8oPbrdAiv5tX2d4KI7iaPWHu39LkWi+QEsBJbbbryFq35r4uqssRDDwC2yXJ0LdWuxK3DToSxdnNGbjzQFfU3V05F62lnew/JQ5fKGaB951dWngwg7+LfD0H/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAIjSTxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAIjSTxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C20C4CEC3;
	Mon, 14 Oct 2024 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918700;
	bh=l4OKDOjK7mqsiNJLGQXZklkN8HPYEBR7u2peEy/vvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAIjSTxsca7x8gsqH3JIZxqzwQQ3VoLwkFgRzAXNbSXiPLUAV4efvIHbt29jtpjp3
	 /iUT3uyJAiO96Y4QGMjTHJCAYlLMNBD8Wtt7eDnWkGXxCUXvmcXJi7J/Vy5nd+Uoul
	 z0oFwdVdGkIlJP5h5CHcVY8/zKkMN2Ubr7vwLTTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.1 366/798] module: Fix KCOV-ignored file name
Date: Mon, 14 Oct 2024 16:15:20 +0200
Message-ID: <20241014141232.328187805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

commit f34d086fb7102fec895fd58b9e816b981b284c17 upstream.

module.c was renamed to main.c, but the Makefile directive was copy-pasted
verbatim with the old file name.  Fix up the file name.

Fixes: cfc1d277891e ("module: Move all into module/")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/bc0cf790b4839c5e38e2fafc64271f620568a39e.1718092070.git.dvyukov@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -5,7 +5,7 @@
 
 # These are called from save_stack_trace() on slub debug path,
 # and produce insane amounts of uninteresting coverage.
-KCOV_INSTRUMENT_module.o := n
+KCOV_INSTRUMENT_main.o := n
 
 obj-y += main.o strict_rwx.o
 obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o


