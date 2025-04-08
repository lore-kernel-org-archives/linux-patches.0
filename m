Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4740374C4;
	Tue,  8 Apr 2025 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110969; cv=none; b=QJP7B5lVIFD5HgJLc3bsWXXXRCrFnq/sUGjvK3LD4MBEeAbZXm3DgWwZhQ8gBj0UP/jUgb7S0HB50QCViCyG66PcKPTp2QgWk5Hw6n7ObL17r2kf/v9jCpHCCVew/bRYHz7a3vcCf7LfaIdIzvtukFmhvvFVAQgEXc6QhlQrESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110969; c=relaxed/simple;
	bh=fZLXLKrAvsxYOY5gr29OkaGgeDM30r+PO7kCSc74hfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPNFys3ponFYmIhy8jf+tlAS9BK+NDPuEWHj63kzWYFXKziEH8LoGVYpAjrDnUDuk9ax89o3jrdBfaKk3l8eWrpgmSGYFVwt+x5gvZDjDiZr7f4urD0A4jRk6JNaK4TVECKMblMsGYSEmJrSIe9K0wmbiEJaAbe2Tsaf7rlg28Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw4Nz6Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw4Nz6Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BCFC4CEE5;
	Tue,  8 Apr 2025 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110969;
	bh=fZLXLKrAvsxYOY5gr29OkaGgeDM30r+PO7kCSc74hfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw4Nz6TlXzG+LC5ZZ3luIT5+0DzgPUyM8Oz3Yl3T6plq9TBsgfFshqoANENbDKMe2
	 qID1kpsaTDBywTgFehL401fBIYSogejfkXdlV/16EIt1SVUwAk68BbuaDBO4BEbTDc
	 iHN8Rwu6e7IZPU9k4WwqTxL9vGmupgvX10ZVu3t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 262/731] net: Fix the devmem sock opts and msgs for parisc
Date: Tue,  8 Apr 2025 12:42:39 +0200
Message-ID: <20250408104920.377011819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit fd87b7783802b45cdd261b273e6b2b792823064d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/uapi/asm/socket.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index aa9cd4b951fe5..96831c9886065 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -132,16 +132,16 @@
 #define SO_PASSPIDFD		0x404A
 #define SO_PEERPIDFD		0x404B
 
-#define SO_DEVMEM_LINEAR	78
-#define SCM_DEVMEM_LINEAR	SO_DEVMEM_LINEAR
-#define SO_DEVMEM_DMABUF	79
-#define SCM_DEVMEM_DMABUF	SO_DEVMEM_DMABUF
-#define SO_DEVMEM_DONTNEED	80
-
 #define SCM_TS_OPT_ID		0x404C
 
 #define SO_RCVPRIORITY		0x404D
 
+#define SO_DEVMEM_LINEAR	0x404E
+#define SCM_DEVMEM_LINEAR	SO_DEVMEM_LINEAR
+#define SO_DEVMEM_DMABUF	0x404F
+#define SCM_DEVMEM_DMABUF	SO_DEVMEM_DMABUF
+#define SO_DEVMEM_DONTNEED	0x4050
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
-- 
2.39.5



