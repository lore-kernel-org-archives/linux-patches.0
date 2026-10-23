Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774484;
	b=IMZxJYMyNZf+um2ByoIYigW5fXa7HecwgJ8gUH+m3vdaZuOhsMO5h/niSYptxQmXLN4D
	 x/EkXQIdxWuYBM7nrBSSgdFPOWwf53I7pIHLiZS5ECP/X9Rt8V92pir61R4WwrUr7DfqC
	 hV8Xr9PQmseWvazi+vFSDxS0+DKabjipZkLhlVtPyEHC7GxkNyipxXUf/C/Zb7yTZpqfA
	 eXF+fLqB+cSwRaOq+eC+ppjfmQFHXxlaOYMrkt/yldtkmeP8EXsg4GgLvwtZjUEP2/xSo
	 owzBiS8ncY0+RL+zrCvXZclQuqvQTTbl/DPj8dUarrQ4YmCdr00Gc1tpsPVvBtrqWRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mrlxhOZDzV0CJJyyuA4yemeXIZZDOkH0bknLTH7I2og=;
	b=tzbLwPV8QDIiqno3rYMQhV4JwE2ARl3ME0fGlspQhsM5Q+bC+eE8P1Wvct2c6oi3HDW4
	 e/9CCbt6Ac5PTTBBYDpxmj2AtkY2Zbx3nW7Oiftrb5pr4b6HCiO3ODKElhjfYOZTGF6nM
	 kRf29/71xW6YwFX4zwioE+eXavJKiemMz99CS1O/3ENizFBSEah2OEpTYVlkP1c0RpEiA
	 PHgnCK5AQDYDUjd77HkUVNxnhDOR7HTBmHn1UcTAEvM1m2PalPwvHL3sm78+BUbjoE4pA
	 OwamcGgjLwnZ5Qc/X86TV3/287szzy4qz+WQqDg+bCG0WDkw5xhZ5l64xeTfQx5gmVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtsxbuQv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5301606A32A;
	Fri, 23 Oct 2026 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtsxbuQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30131F01829;
	Fri, 23 Oct 2026 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774484;
	bh=mrlxhOZDzV0CJJyyuA4yemeXIZZDOkH0bknLTH7I2og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtsxbuQvNixAsOpMDTSmjiu+0vXzpRNPBJLFeAKZ0xz6jlrQBnKbpGnzAJt4mT4G6
	 2bbKVA7JPA170oa8vDGhZaSlKkCJhlWveN2SVLDFe+COKrkzVrR0yi2voncdn9htw3
	 j3Aza765MpdMjS/DJOXl4CifTNnfTmez0lte2SDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 7.2 057/242] samples: pidfd: fix userprogs typo
Date: Fri, 23 Oct 2026 18:38:19 +0200
Message-ID: <20261023163715.128337879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit f1365f97fb7498d805981102eee22d362ae643f2 ]

The Makefile adds pidfd-metadata to "usertprogs-always-y", which kbuild
does not know, so the sample has not been built since the conversion to
userprogs, even with CONFIG_SAMPLE_PIDFD=y.

Fix the variable name. pidfd-metadata.c builds without warnings with
gcc and clang for x86_64 and arm64.

Fixes: 60fb0b1239719 ("samples: pidfd: build sample program for target architecture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-14-sashal@kernel.org
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pidfd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
index 9754e2d81f70d..d82409f7061f3 100644
--- a/samples/pidfd/Makefile
+++ b/samples/pidfd/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-usertprogs-always-y += pidfd-metadata
+userprogs-always-y += pidfd-metadata
 
 userccflags += -I usr/include
-- 
2.53.0



