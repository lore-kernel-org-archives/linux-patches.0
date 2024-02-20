Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C9612D7;
	Tue, 20 Feb 2024 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463574; cv=none; b=b+hfAzYPD067zfZ9Uk3y8taM7/5ZzHYlRRlRUmpgHaQP9RwHU8ZnccGVQ1wAzDv4d8/0ty89ypWx6BIvNuGTJ5ntuoxLqchu6ivmWhV8UPNZJo4CMvLHJe09gyryktCoOovUfQX8peUyKMoHk1HXZDPjwVYUZJt8vWq/5WzgEjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463574; c=relaxed/simple;
	bh=m+4ngGtWX9mcstZb311BplOQT7jhHoqybsVns+TLf3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up5HN03Boe17JNmUoWn/wMA081rZYT3lhmZOUYLctM5FpP55neuoSpFXvG15WB4VKN32HpbcXxSvnUWGTsb+JyLgtEcA9r/tLWlhj5GyGiJfciUJ0Ubxxuyos+tMjq+h1h2UZCD9eVGh4rJLDQsDs3pWAZgs6sRxYiruzpN4akU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoB8xfZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoB8xfZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E7FC433C7;
	Tue, 20 Feb 2024 21:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463573;
	bh=m+4ngGtWX9mcstZb311BplOQT7jhHoqybsVns+TLf3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoB8xfZKuiZJgnMMiLxE1hQQxe0URjRF6gNCCKLrKojwPeRKIG52PpQBVYvZUwc8D
	 BcxVn9iAg+0+ljd5JuFIanuWdhnnx96B3x4A3BqsITZ5WMXzfglq+FwtY1g9+Hbnoa
	 5B//XoZP9WhK8tAfBegvyzDfZ3ai8V12VlmQuI3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 057/331] scs: add CONFIG_MMU dependency for vfree_atomic()
Date: Tue, 20 Feb 2024 21:52:53 +0100
Message-ID: <20240220205639.382014817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit 6f9dc684cae638dda0570154509884ee78d0f75c upstream.

The shadow call stack implementation fails to build without CONFIG_MMU:

  ld.lld: error: undefined symbol: vfree_atomic
  >>> referenced by scs.c
  >>>               kernel/scs.o:(scs_free) in archive vmlinux.a

Link: https://lkml.kernel.org/r/20240122175204.2371009-1-samuel.holland@sifive.com
Fixes: a2abe7cbd8fe ("scs: switch to vmapped shadow stacks")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -681,6 +681,7 @@ config SHADOW_CALL_STACK
 	bool "Shadow Call Stack"
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	depends on DYNAMIC_FTRACE_WITH_ARGS || DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on MMU
 	help
 	  This option enables the compiler's Shadow Call Stack, which
 	  uses a shadow stack to protect function return addresses from


