Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064863;
	b=xgFlGxxYP5hk/1hdnNL3JdrwMzinGOQ5fjm9kHOnn7maRYfdpW1mnK3DIxAHLk7mqMjK
	 +6cBk2IJ2bk4LwoMRT+wrKU72e+Eom5U5XfRd80EcgbVmY+DTeVHSQan+96zN9gsmXo/h
	 c/ysEG2guiqMpGFxdVzyGhZDPVrrB5dUk+i4eCjI+TZtEbiESsWCFFqE0DYvf65OHALh6
	 TyFJ5Xc3eiOwCLpOANtH6nYtf5nXEINvJNqHawTr+TiN/wOenZ9omw65ntEnunD+Y7GdN
	 k5y7hH0OH6Tjc894y6MO/N6sasoxQXEEJzqda0OGKlgRPLaY6te4EhNpsenVIbYmrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oY1lQqhBByLaQoBXbxQBGR68FSkM1+sar84ywbFzjdE=;
	b=zjrHpx8Wi1G8QsajJyylIZ98JJrjErQjBuls0+cU6muvGcGZnph74v8sBV3bpBD4nlxz
	 bbL1DDpBUqfoxm/5xEK4LIbpKoU5rx8c1yp45DDGldUiYoUPgB3xDQHf8DektMgTf8vXE
	 js3xzMtoF4f+S5S242CH5vKVrF0E9/hRT+BLR7UFKMa3JWyh4KycHnLYIh+b3Bw3GLjqj
	 VjFJQ8dsG3X1voOZyK3B4e/URlX4zHkwsuhOta76mhgH+g6+CQqKd2uvtmiwzlJ97P4Qp
	 vbhGd5D/HX55We6c73GiwHUTIvDE/NgfV5J6HEhkqMT46+vMKvSTQbaH609SrqzDAmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4rNMBdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98A606A9C1;
	Sat,  7 Nov 2026 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4rNMBdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AFF1F0089F;
	Sat,  7 Nov 2026 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064863;
	bh=oY1lQqhBByLaQoBXbxQBGR68FSkM1+sar84ywbFzjdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4rNMBdW8uLJnvvgulgeExUxnD03xN1hp0rpH9Zjg7d77osW/R7n9NuJVL7/Xi0IO
	 bzjJsKUcbG7W0xhwOymeuuRQBdaL2Dj/SX83aE5tpvVH2zMJY5eSepl4hWnJe2t57B
	 QWY+6wf7gjP7RWNaDRSOQ9iyCmhvqdMSWS1KimbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0781/1257] kbuild: AutoFDO: Update split machine function argument for upstream rename
Date: Sat,  7 Nov 2026 08:51:17 -0500
Message-ID: <20261107135000.878890495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2b358510d5cc56164f83110ca1499c95a5a352cd ]

A recent LLVM commit [1] renamed the internal LLVM plugin option
'-split-machine-functions' to '-function-splitting=all', breaking the
AutoFDO + ThinLTO build with:

  ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument '-split-machine-functions'.  Try: 'ld.lld --help'

The plugin option is needed for in-process ThinLTO, so handle the rename
accordingly using ld-option.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2186
Fixes: 2fd65f7afd5a ("AutoFDO: Enable machine function split optimization for AutoFDO")
Link: https://github.com/llvm/llvm-project/commit/3e6acc87c58843e551d6e8e4bf06c26712b04622 [1]
Link: https://patch.msgid.link/20261014-update-autofdo-split-machine-function-option-v1-1-5c71b3005e89@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.autofdo | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.autofdo b/scripts/Makefile.autofdo
index 1442043da1391..57a3aba6ffc23 100644
--- a/scripts/Makefile.autofdo
+++ b/scripts/Makefile.autofdo
@@ -22,7 +22,7 @@ ifdef CONFIG_LTO_CLANG_THIN
     KBUILD_LDFLAGS += --lto-sample-profile=$(CLANG_AUTOFDO_PROFILE)
   endif
   KBUILD_LDFLAGS += --mllvm=-enable-fs-discriminator=true --mllvm=-improved-fs-discriminator=true -plugin-opt=thinlto
-  KBUILD_LDFLAGS += -plugin-opt=-split-machine-functions
+  KBUILD_LDFLAGS += $(call ld-option,-plugin-opt=-function-splitting=all,-plugin-opt=-split-machine-functions)
 endif
 
 export CFLAGS_AUTOFDO_CLANG RUSTFLAGS_AUTOFDO_CLANG
-- 
2.53.0



