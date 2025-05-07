Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B0628E60E;
	Wed,  7 May 2025 19:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644730; cv=none; b=MGwFUQ4a04uaVS9dkNCEL5RyS1IXysL8mt/XXLJrONyunUBDnOwmc/lhnvhxS8U5IvnqNd/qTrp+c5V2gMV5QvVjozq1dXj0VSiVvq9n+yEXigZAX+7WSYZpGaNnFXeCFzKmCel6c7PsbHT0y9gMXWdxcWlE1ECzdfAaf4u+wlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644730; c=relaxed/simple;
	bh=EvHApb6Mm+pYMx5HvYAvSZqKkuqAKWzR1QsZR6VbvpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGnu4EIonFoRHS3hltqPhucXiiJj8mkNorVpohyDDA29W+IW3zjx7IPBeNdE036DT4gQRGo84UXGiLeK1ebOUqblx2iuIVkig1nhBvb/dVYR9h49OJUup0OxY6oqlyttDMkHM/TM81ySqAb5cT2vh9SG+l7V5O7o+yKbbt8rk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/qFkoDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/qFkoDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D0C4CEE9;
	Wed,  7 May 2025 19:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644730;
	bh=EvHApb6Mm+pYMx5HvYAvSZqKkuqAKWzR1QsZR6VbvpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/qFkoDZFfsy+PTWD2YDCg9qjhBIHAgVAz4LY7ahg9GcuJM6hRihODbV1ousoqHti
	 VX+BZM0nEH9HmFH7QF06dT9ntYHAcrmQSxhFe7WLQceympeZXo++RuPrfgkQllLZa/
	 mgsZtCfJnEOLFgYlmU3RpMPxoornJvXpvvGNbhdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 139/164] net: Fix the devmem sock opts and msgs for parisc
Date: Wed,  7 May 2025 20:40:24 +0200
Message-ID: <20250507183826.600557992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

commit fd87b7783802b45cdd261b273e6b2b792823064d upstream.

The devmem socket options and socket control message definitions
introduced in the TCP devmem series[1] incorrectly continued the socket
definitions for arch/parisc.

The UAPI change seems safe as there are currently no drivers that
declare support for devmem TCP RX via PP_FLAG_ALLOW_UNREADABLE_NETMEM.
Hence, fixing this UAPI should be safe.

Fix the devmem socket options and socket control message definitions to
reflect the series followed by arch/parisc.

[1]
https://lore.kernel.org/lkml/20240910171458.219195-10-almasrymina@google.com/

Fixes: 8f0b3cc9a4c10 ("tcp: RX path for devmem TCP")
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250324074228.3139088-1-praan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/uapi/asm/socket.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -132,11 +132,15 @@
 #define SO_PASSPIDFD		0x404A
 #define SO_PEERPIDFD		0x404B
 
-#define SO_DEVMEM_LINEAR	78
+#define SCM_TS_OPT_ID		0x404C
+
+#define SO_RCVPRIORITY		0x404D
+
+#define SO_DEVMEM_LINEAR	0x404E
 #define SCM_DEVMEM_LINEAR	SO_DEVMEM_LINEAR
-#define SO_DEVMEM_DMABUF	79
+#define SO_DEVMEM_DMABUF	0x404F
 #define SCM_DEVMEM_DMABUF	SO_DEVMEM_DMABUF
-#define SO_DEVMEM_DONTNEED	80
+#define SO_DEVMEM_DONTNEED	0x4050
 
 #if !defined(__KERNEL__)
 


