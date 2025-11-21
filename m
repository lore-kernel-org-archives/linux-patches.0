Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A72750FB;
	Fri, 21 Nov 2025 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731662; cv=none; b=b12ysx15YQijGQkvTVZgeDW15GNBzn584zvKLjOQtCHXzeCZ+hy0uVGM05lPo1trxNifHM+TLC0L7VzUR2QRXFhVpJrlqbQSnjQHP2L0oQvqRhoXDTLm5JzToXYSSHsBvnDJQxUPXfgaE097VaT0Pjew/2oeC6ObPf1sHVipV9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731662; c=relaxed/simple;
	bh=BZRcHfvn1khg/jCw56qUuap7cVsVnWJ+41toUrJqYow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWgJoRTNEPNc8N4/WxmcVfy6QhNXKCetj1Uv1n1FWa5ELs8qDjPrjcjI8Wag59VXn0hmveQ7a8iKf3p+hEEn6IES8A4Xy/TPG3emj2nj0qENDyN/me8RHHu8h2SaPcY1Xzz13sXJpNy1lqc27i+UZH+N/jbeuV5O1TpHEEeSkj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzOBOwsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzOBOwsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9675FC4CEF1;
	Fri, 21 Nov 2025 13:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731662;
	bh=BZRcHfvn1khg/jCw56qUuap7cVsVnWJ+41toUrJqYow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzOBOwsxKwhkXaq2kQhLw9qPjgqknVLarRnJcOxUjbPwgyN0y0e02SgCwpKdS8hLL
	 E0JYbMNrOHsj/4bBtaq0QK4CU2JL1S9nzQzg/hayy1Q1FcQy5QLBbgdR+NKna4k4tZ
	 kved2RjdVKKtp/AlWNnS60XhqJt+qBI2JF8UQvuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Mingcong Bai <jeffbai@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/185] rust: Add -fno-isolate-erroneous-paths-dereference to bindgen_skip_c_flags
Date: Fri, 21 Nov 2025 14:11:04 +0100
Message-ID: <20251121130145.217081214@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit fe4b3a34e9a9654d98d274218dac0270779db0ae ]

It's used to work around an objtool issue since commit abb2a5572264
("LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference"), but
it's then passed to bindgen and cause an error because Clang does not
have this option.

Fixes: abb2a5572264 ("LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference")
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Mingcong Bai <jeffbai@aosc.io>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 07c13100000cd..c68c147205ed8 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -249,7 +249,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
 	-fzero-init-padding-bits=% -mno-fdpic \
-	--param=% --param asan-%
+	--param=% --param asan-% -fno-isolate-erroneous-paths-dereference
 
 # Derived from `scripts/Makefile.clang`.
 BINDGEN_TARGET_x86	:= x86_64-linux-gnu
-- 
2.51.0



