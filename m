Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020336;
	b=XMPaDF9r0JJ9rPisqiAWF0Msuy/EXPnJ9dn3ZEU74R21CDcSBGqWJq6M+x3IFWFkiMl6
	 EEbGnnprgxQbVYnCCawm6JC/dkKZKNj5I3ysCTs4u1ZC35gjoXD1VcJHHuE3Kwr5rKVlI
	 UVr06u3SUYQvQk21GW57fwy/YmeolC5e9wbzzuh5oUvOOnl5xz/xFKaNztQtv6gV3tKX7
	 saMw0Y/gFDaTJqrkAU0ewzf9ae/uagU5mIifbpvAZ2W7iU5QOCMy/FjXrobhSZthfk974
	 LU7iIlp2+8Ip2QeHN7CEbrPQmHhPA3m0w24b3vksKEV4KCDAbSMrrXeXw0CIiZuqlMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MINajGWPC1wxYL48U92ws+iB265O2uRQXxe/hJq5nEU=;
	b=n/T/Pck6EDbsxvKOYU3LoZWvxGFDxDX4d8R2wfOE/pAnb8hKZbw0t/a3CsjFI3SaSjKS
	 +bviLv/T1wB+fYeq/7E31ENNrbPw0dM8Kq51RA1BxjcldIy3gbV35YVpHgm7gbTP9UHPx
	 fIViMe/6JTBbPBeu9CfEcu0ZtDNUEi5urm+36TNehOs2MJWHAWNlrwgyp3BqlsXu0L+h5
	 kw4EeCY31lLRMAOP5QmkiZcPuq+lqRYz9lf8A/04LwSr59VwOCMkwvLQpvNb5iDztMDT+
	 t5/yp6bnhnSXfNXv23CBrRVMVptWxiA0LK1rCbx781aJQBHiNSQA08MwNH1+7UAPtDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ewn7MdS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5B5606A33B;
	Wed, 18 Nov 2026 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ewn7MdS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E041F000C4;
	Wed, 18 Nov 2026 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020336;
	bh=MINajGWPC1wxYL48U92ws+iB265O2uRQXxe/hJq5nEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ewn7MdS0wKseoBJPwkRKwPhrRGTETjFa/d29YbCuhL/mTsgn/qV9oqlGAWKYAyrCo
	 n3/KWaU6oTdSqckE32zFvl4KF6YVEGNQ7IEoutIU0JfxnQqdA5nmcND6i+93FXmz6A
	 1LpPUSBkw/RbMSHQGfGqe3dm5Kb4azR7UiZhrftM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 7.3 1914/2651] selftests/nolibc: use the configured kernel header directory
Date: Wed, 18 Nov 2026 15:52:34 +0100
Message-ID: <20261118150355.679922188@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit f9532b372e415e8198287ce010efa22f337857b5 ]

The freestanding build hardcodes the source tree's usr/include even when
selftests exports KHDR_INCLUDES for an output-directory build. Use the
exported header location while preserving -nostdlib, -nostdinc and static
linkage. GCC 14 and Clang 21 builds then find the generated UAPI headers.

Fixes: eb1353110831 ("selftests/nolibc: integrate with kselftests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261014200142.1364761-1-sashal@kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nolibc/Makefile b/tools/testing/selftests/nolibc/Makefile
index 6bace04227a74..6981c220eed76 100644
--- a/tools/testing/selftests/nolibc/Makefile
+++ b/tools/testing/selftests/nolibc/Makefile
@@ -10,7 +10,7 @@ cc-option = $(call __cc-option, $(CC),,$(1),$(2))
 include Makefile.include
 
 $(OUTPUT)/nolibc-test: CFLAGS = -nostdlib -nostdinc -static \
-	 -isystem $(top_srcdir)/tools/include/nolibc -isystem $(top_srcdir)/usr/include \
+	 -isystem $(top_srcdir)/tools/include/nolibc $(KHDR_INCLUDES) \
 	 $(CFLAGS_NOLIBC_TEST)
 $(OUTPUT)/nolibc-test: LDLIBS = $(if $(LLVM),,-lgcc)
 $(OUTPUT)/nolibc-test: $(NOLIBC_TEST_SOURCES) | headers
-- 
2.53.0



