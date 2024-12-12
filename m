Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12BA2144C4;
	Thu, 12 Dec 2024 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019217; cv=none; b=OmJqySyaf1uGXpiKXjZ7LrGYXOr8+CQsFKXRd/vVUBSIVn5FP5Hd5804V0dSnfR6CuQ5J3Qg1VRTJOF7/1a8cSb/M0a+CmX7d665MHrRGWcU/I8/lLpgldqvyan0RiWrL0iB2+GUY7vxjfBd3U725IIUz/QFIxb6g3+U6+uzJQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019217; c=relaxed/simple;
	bh=t19Esap7OtOgaIOfpLYKbuAokMaphQUVqP/y6pWrBgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NutCf5HlBeODjAOgTDgW+zVdBa1ZFO5+ccdA+T7dcJEW/CPJLctF/OdVLQ16p4CMbmpwbNSo21RBPYrRseZAh+KGcIHUPXCA+FLAaat9KpSHH85ej2HXzOyGALdQGc9P3C85c/ojAzKw3XACGDpRoe54y7tHqCak2JLtjDd33Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Awl2tjTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Awl2tjTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E2C4CED0;
	Thu, 12 Dec 2024 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019217;
	bh=t19Esap7OtOgaIOfpLYKbuAokMaphQUVqP/y6pWrBgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Awl2tjTNxwnwWiyU+75taO2oPNr5KP5RDE7aIdWR7G49cgIGbb1ueKeEIk7S6HJAP
	 DgCeTVCSjOVWoKhyMRYde6gwhxHfyjYRZk+xjjH5kZv2D2h/2iLMv2xyApqISOno61
	 9ynugoNQZsalOdl2Qtl5DCsvAKhjJH8dAPjdlLiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/772] selftests/bpf: add missing header include for htons
Date: Thu, 12 Dec 2024 15:51:34 +0100
Message-ID: <20241212144356.095368441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 2582ec56dcc50..535b72623dd4b 100644
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



