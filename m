Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD52155CB3;
	Tue, 30 Jul 2024 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358278; cv=none; b=bQ+TKeMxEwadwjgJjlhkE2qRMXOUy/jBepTKX28Qv+qOKeYA9gN/mOEUubQF30dmkAQdptb22tGJDmhALjNx7W21bITRfi1zIpd9uayERQdv9ZBmHEpza7B+cb4RM9/A8mZEvs7FGjvUvFY7uFyDp71WMRetitkl/sI6wiE1cTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358278; c=relaxed/simple;
	bh=Q1SWv/bBBFtD6YaOUZgZz8DWIWGjRMWE+o/kzC7qSF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eT7H9hLoKQBYDttj9aBsg1/vauRwku0E7Ce+AIPp3ctbEpshem+ksS92w7VBBdDGu/syvR01a4pccUBzmqlA4/XQ0oul0Gl++U3dufs3iizJypZzq49ow25moD8wJ8tLYWFJX2A7Vhjdq598AIYScOUiEf/LCNVpS+7NeORIg+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuC17Mys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuC17Mys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70689C32782;
	Tue, 30 Jul 2024 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358277;
	bh=Q1SWv/bBBFtD6YaOUZgZz8DWIWGjRMWE+o/kzC7qSF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuC17MysMieCH/ILPpfwT07aWzdHjp+/Ias+pJSv4x1Y2ZoRlvgHIvOHNPYsKfAX+
	 0UKyRFcxiQrMTOUGlTdINXwb5tTh7I4qO2AIR2sOGBTPgko6DxHBX4Mx6QAyOZF0an
	 KUJ7YbfHu3fpNBS7c4GziH7PQep6Y68HdBrEhHQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 373/440] MIPS: ip30: ip30-console: Add missing include
Date: Tue, 30 Jul 2024 17:50:06 +0200
Message-ID: <20240730151630.382598472@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 8de4ed75bd14ed197119ac509c6902a8561e0c1c upstream.

Include linux/processor.h to fix build error:

arch/mips/sgi-ip30/ip30-console.c: In function ‘prom_putchar’:
arch/mips/sgi-ip30/ip30-console.c:21:17: error: implicit declaration of function ‘cpu_relax’ [-Werror=implicit-function-declaration]
   21 |                 cpu_relax();

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip30/ip30-console.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/sgi-ip30/ip30-console.c
+++ b/arch/mips/sgi-ip30/ip30-console.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/io.h>
+#include <linux/processor.h>
 
 #include <asm/sn/ioc3.h>
 


