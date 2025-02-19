Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F01E2842;
	Wed, 19 Feb 2025 08:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955236; cv=none; b=drvY2dN8B5T1a81aAnCLrmoxqEFYe5TJ6JGXFPtfWVW6WZu0p1Fju0zwSUIyy1RaexbGy2Twhke4G2p4mSgkwXCnUIpkHi5ONiL74QzHrHfmQJBzh8+JD7+Czl4Bjj3YzufFaxkUzczdoHjUBjCjn2OqBPyzEszpfy/9bzKWeOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955236; c=relaxed/simple;
	bh=YJbg8wGqZvzLCdnR9d+5AAlCrrxs6v9iqGLrvnHNbLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA9UTtqHkkYuvFR727oVWstdFS8w3fVndqSMB0Vz86b/YTfQIIZsoasm/onwz/Xn+NmdN/q27WMZjdCZb9AzkyfESdEYWRrkyC7F2ZE4VrkhA9XP+jZl8pvzcHfIAHkPbB7atxTErzHZFkac4A2pHAoe0IG4GbBI4vE66edzwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDhkWkA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDhkWkA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F156C4CED1;
	Wed, 19 Feb 2025 08:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955235;
	bh=YJbg8wGqZvzLCdnR9d+5AAlCrrxs6v9iqGLrvnHNbLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDhkWkA7LSFpOdyxeWZu653cXb4/9hHCvbt0qLNJxzRfQ8gchALzRqU73ShOtMmJM
	 RRKt7AhPI0a9PHWjmesFVZkRGYocBHTYwS3u0hMIUcmuQRhLnJXuX+ZimO+gX2C4Me
	 8vXaVyKYqY3x67s5G6yJVhA/hjjUoMqH4cWIKOWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Kees Cook <kees@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/230] rust: kbuild: add -fzero-init-padding-bits to bindgen_skip_cflags
Date: Wed, 19 Feb 2025 09:28:11 +0100
Message-ID: <20250219082608.514386885@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Justin M. Forbes <jforbes@fedoraproject.org>

[ Upstream commit a9c621a217128eb3fb7522cf763992d9437fd5ba ]

This seems to break the build when building with gcc15:

    Unable to generate bindings: ClangDiagnostic("error: unknown
    argument: '-fzero-init-padding-bits=all'\n")

Thus skip that flag.

Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
Fixes: dce4aab8441d ("kbuild: Use -fzero-init-padding-bits=all")
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250129215003.1736127-1-jforbes@fedoraproject.org
[ Slightly reworded commit. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/Makefile b/rust/Makefile
index 9f59baacaf773..45779a064fa4f 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -229,6 +229,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fzero-call-used-regs=% -fno-stack-clash-protection \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
+	-fzero-init-padding-bits=% \
 	--param=% --param asan-%
 
 # Derived from `scripts/Makefile.clang`.
-- 
2.39.5



