Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEB51F130D;
	Tue,  3 Dec 2024 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238398; cv=none; b=JvRDXpWQdNbxk3ZPUo0h+ZtVod4ng1oHKIA65f0jrBhNMHeowfwtYdq8DXFruKWu0Kjz8vJni1jBGMwOjuhgGrDxbNFk+FCGoRoDb3STUQD+GSlCd2RJaQDMtjYTzCBJbw6cx/sILd02KMBFBeTQhcD8sba1ImvuaWqk4Ud7uE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238398; c=relaxed/simple;
	bh=ZEgsIZSmcZda1OnLNl3sp15rodN4WuMKWSL3Ivj+bVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dk/VGohMs9ctEWohQXF40bVhM54P/GDW+pWsjfImNd567DXkFQPp6BufQC07HyBsdwX8h4H13p/l8bKSmi8Xps41T0/BYx1XoR6ZSQobF/OrOLQm8vxs+WH7BUky3hCPOAmSwky0MdBUGT/jFnoZ6MXQSiVADHZpPUByfLQDY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIkDuaA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIkDuaA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE24EC4CECF;
	Tue,  3 Dec 2024 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238398;
	bh=ZEgsIZSmcZda1OnLNl3sp15rodN4WuMKWSL3Ivj+bVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIkDuaA4YdT90flIzum44+UcHJAw9bXNbU+qT4dLnBcQNeRAOZfg0RD8i4fJvrkIr
	 oWv3J30EKFag5N437ew+MDrz95iD31wcBO2HQAEaEMch57d7cksncuPNRPPSR1w2kc
	 TuQASmLtNBgExsDgsY7rE88qxq44ARUen8JzCBf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 263/817] selftests/bpf: add missing header include for htons
Date: Tue,  3 Dec 2024 15:37:15 +0100
Message-ID: <20241203144006.054994774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 91763fbe58d27..7b05fc3fedb06 100644
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



