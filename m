Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0191FA16B;
	Tue,  3 Dec 2024 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240790; cv=none; b=i9OkUGBd9r7IvvliEodFV37XcnCXT+siKYCnVnEpe4E749Jo0s6e52LcP+vYzT4ArQlB1p+DRc2SVcVH0DwHr857NG4yy5RDEdAuR1Gfd/mn6P6PgmwvywjjqDtt9X4BXN1ISsU6EdJ2D5LXIBIT9ajfNvmX4JKWV6ecr2NqH+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240790; c=relaxed/simple;
	bh=zBxLEB7n+JXIwu4m2tTtH1HsLgle8Iegu4SUp0IhVIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZ1Vjb+tHlTEdjalZXu0weJGMrVX59ezsBHzflom+lkIwcjJ1tTy0Nyh6y5AK8xHgyjsn6Ilk7V8Jfu4esvte5JioX5+Ltx3p5I0clu9uDBpsZ2Dmo4FaqNE7mxWEy9A5TpBGvVcxx6k9bAZh3OtaJiHSEEKJz2Uuh02fG129nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHNGDwbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHNGDwbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0F3C4CECF;
	Tue,  3 Dec 2024 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240790;
	bh=zBxLEB7n+JXIwu4m2tTtH1HsLgle8Iegu4SUp0IhVIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHNGDwbfN8wwq9kcHU6yCqDEpFeX/0+WJdWGLZachowWLsjl5MVS5r8lvvYrLYyyO
	 KyzoRAGgAxc1VSHWlqT7HDmE7WoyRN08hQV9yXhO0jZgyAHLv5lJymUBpjr1BcsRiZ
	 oFmrYPUO4BLyncChQw8CxonngJ2JPr5T3CHYJFIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/826] selftests/bpf: add missing header include for htons
Date: Tue,  3 Dec 2024 15:39:21 +0100
Message-ID: <20241203144752.880915503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

[ Upstream commit bc9b3fb827fceec4e05564d6e668280f4470ab5b ]

Including the network_helpers.h header in tests can lead to the following
build error:

./network_helpers.h: In function ‘csum_tcpudp_magic’:
./network_helpers.h:116:14: error: implicit declaration of function \
  ‘htons’ [-Werror=implicit-function-declaration]
  116 |         s += htons(proto + len);

The error is avoided in many cases thanks to some other headers included
earlier and bringing in arpa/inet.h (ie: test_progs.h).

Make sure that test_progs build success does not depend on header ordering
by adding the missing header include in network_helpers.h

Fixes: f6642de0c3e9 ("selftests/bpf: Add csum helpers")
Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/r/20241008-network_helpers_fix-v1-1-2c2ae03df7ef@bootlin.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index c72c16e1aff82..5764155b6d251 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NETWORK_HELPERS_H
 #define __NETWORK_HELPERS_H
+#include <arpa/inet.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <linux/types.h>
-- 
2.43.0



