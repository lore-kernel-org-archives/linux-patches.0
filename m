Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024294;
	b=svjs9qnREnjMrgE2xaRDQWr1cZX7DokxfvMYTcyhmw+EnzRQRxKOGHiKIU2rbGF9If4X
	 M73s1jeF0mZ3J3EU/SdPDSfbQv5NcoMKtBbO5NEFX+tx4bUs7IwIVm+oKA+ZNQkultHPU
	 NYKfnrBsuzrIbfv1j/rIOk9nKTPCPuw+c0D36LrsFMNQCg6c1NRcUx+GcYyaZjIbxWzIL
	 2fi9A9KUpiU0J0pbDuodXsDgHyEhDbQsnkc6oeVX/U7OIYHkImrvlqobmEcThOFZ07i1Q
	 X2IIRacN7JEHrAFtS7L5C9gA6jk1K6WZ4emwWmjKJwWotxDCI1cI6Pfwu9GEdfQ1Q9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QdkAf1q8si3lE1bmGr7n1VQ3BE15eIlZQ6huYi7Y2g4=;
	b=HSCLTZ6LFHX3RX/svIpHtSx+Dx9Pdck57acdiG2fGQkzzbyA3yyZQdhSLdo7yv0GT355
	 YCJLdBqT2SQyAu8uaTTY9bSvHTD1hco04RxPyvoSRjErVriVVENQreBl0KT6v7xXys4jP
	 P0tu1FDcnL5MMxCY68KL4xZJaHxARaqBp7ujZZDDPrKx+ZOue+0oysH+mCoyBGEhgNfss
	 j/HYTovrzbmG3Tj5UYpYwU63r0HqdCYuXa2lIEUmq/Jllne195G9aevqHJADtDPvgdoJN
	 IME35X428JWyeaazwlxgpM2HuepjAETCqIIMvcfd42TG6n/PnuGimswM1tIk7WFObNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eIZPV/jv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDDA606A330;
	Wed, 18 Nov 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIZPV/jv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF2E1F000C4;
	Wed, 18 Nov 2026 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024294;
	bh=QdkAf1q8si3lE1bmGr7n1VQ3BE15eIlZQ6huYi7Y2g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIZPV/jvaqGa7zdghAr5B7IZegPT5C1ZeK9gVTJTf+a4jFCj/U+ihXMQqCDsfe1Fa
	 gsc24YFTtpvSGc4FK8MyPDUIsYTqONJAeG5ypyLHu0oevQtvMR2VpnYJBcQFxbdNOc
	 s6qVGokxOlyua9MDbyf/PyGJgh/hjFx3Y0XeWiVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0674/2151] tools/nolibc: fix WIFSIGNALED() for status 0
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118150146.367606148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 368fae47c6cae28a312c5dc86e5bdb8f9369fd26 ]

WIFSIGNALED() needs the subtraction to wrap around for status 0, so that
only 1 to 0xff, a terminating signal with or without the core dump flag,
pass the check. But status is an int, and 0 - 1 is -1, which is less
than 0xff. A child that exits with 0 is therefore reported as both
exited and killed, and a caller that tests WIFSIGNALED() first sees
"killed by signal 0".

Make the subtraction unsigned, as musl does in the same macro.

Fixes: 8c934d4822c7 ("tools/nolibc: add helpers for wait() signal exits")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260923205622.1123270-2-danishkhateeb03@gmail.com
[Thomas: Drop stable@ Cc]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 16c6e9ec9451f..8fd3e81514da2 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -109,7 +109,7 @@
 #define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
 #define WIFEXITED(status)   (((status) & 0x7f) == 0)
 #define WTERMSIG(status)    ((status) & 0x7f)
-#define WIFSIGNALED(status) ((status) - 1 < 0xff)
+#define WIFSIGNALED(status) ((status) - 1U < 0xff)
 
 /* standard exit() codes */
 #define EXIT_SUCCESS 0
-- 
2.53.0



