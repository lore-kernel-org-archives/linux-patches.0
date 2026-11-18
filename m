Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016848;
	b=kY1cBVpBRNXnzYaL9JI7D++zx3XJ6PZ3KydcrNDJygkFhG22cNtJS6WrFTDyPx+gLzKE
	 VWrnH9nXCdIQ6FYD33oD/LU6K01VXTlSMYMvZkOGWTj4CNZEuW6T5JWVZl2EAwyHpqiWT
	 Y7nPe+G9hlFdcpykC8GYE9xjLgr3V5hJp67agqja50VAXbDO+UB6UGjw+d4jUV9KDF+te
	 qf1YfRFGqFqMJ7HUiH+A0dauXKzXfrDLzRvC7bV5eGiIlhjitQQRCRWah1jcbmyxxfqmA
	 eYuA9c1iZEfanI5YZU6zSMLLFAH2EeWa+2PbhClCOeg4ta/QKzOEw9TKy3Pz2+AxIIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qV8QvziTnHooQCI4dl70f5cWoAHFMzQyhHfGQh9S48Y=;
	b=PE7CoUWfItR1hgzLZ3EwcJkEwpj6nZzZlneGUrLTPd6LDoIKlDd5rasQoGMPP2GZ9+ay
	 fwv03MYs6v8P0q4ufGs3sFmHLcPsbIH0pmK511yqSinAVSrV0E1sbglG2O6JMpb7i67Vt
	 p7hjNVV3kcd5n6lZ7Zn1EWeBEgeTuL1LRl3aiyP2eVb38RHUT8phU1F019lMN9309kFPt
	 U24vXTf9McBRjVevAnBNe57caOBoJbtM5Xx576ITq3ZOeEPMLLmQWKc42ASyLrp2I5jug
	 My1UHNx4lIhLX2dk0cIBRaSCKN1Jv/e6mss2pSVvo2L1/wvdu23eZ5kjWEyoZkeLnVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxdrQs5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C1B606A325;
	Wed, 18 Nov 2026 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxdrQs5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EC11F000C5;
	Wed, 18 Nov 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016848;
	bh=qV8QvziTnHooQCI4dl70f5cWoAHFMzQyhHfGQh9S48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxdrQs5O3JbGHBoikYiQ99sz2RAzKJxwdeJwA/UyNnV5171DGcdzOIRJev8p+3gjZ
	 RRKiAmPDDK76Ut9BqJHAD1rnkVYp/N8hN8oe1RDjuj0YtNRpfr5yOSuiJ0CTxPs+vz
	 w0foIIz8H4q/HfZ1vm0CysZJu1Y98tkFFoNfNs/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Hisam Mehboob <hisamshar@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0674/2651] vfio: selftests: Include <libgen.h> for basename() on non-glibc builds
Date: Wed, 18 Nov 2026 15:31:54 +0100
Message-ID: <20261118150312.136562323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hisam Mehboob <hisamshar@gmail.com>

[ Upstream commit e11a07856ba06867a4c0c8aa91770e1b209dea98 ]

sysfs.c calls basename() but does not include its declaration.
Glibc exposes basename() through <string.h> with _GNU_SOURCE, while
musl declares it in <libgen.h>.

With musl, this results in an implicit-function-declaration error and
subsequent type-mismatch errors at the callers.

Include <libgen.h> so the declaration is available on both glibc and
musl. This is safe at both call sites: the arguments are local writable
char[PATH_MAX] buffers filled by readlink_safe().

Link: https://lore.kernel.org/kvm/CALzav=fs4bqMM7BXNPXqhtbqGzA+LW5fgx2-1Q5=sTN5+krYhw@mail.gmail.com/
Fixes: a262fc49e0aa ("KVM: selftests: Build and link selftests/vfio/lib into KVM selftests")
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Hisam Mehboob <hisamshar@gmail.com>
Link: https://lore.kernel.org/r/20260824222845.459181-3-hisamshar@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vfio/lib/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
index 98a46a2543cd9..d88e348a1e0d4 100644
--- a/tools/testing/selftests/vfio/lib/sysfs.c
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <fcntl.h>
+#include <libgen.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
-- 
2.53.0



