Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216C1D61B5;
	Wed, 19 Feb 2025 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954543; cv=none; b=qlvxEeD1fqZo4NwHNcvtAtYUlqOpsZgGlG8mu7+dDZNcsQlCimPgL3WNkxvuJJ03GtwgAeqN+s7yXBzBbtmA5biWzukqZsSezWLZrkpYWKlCVvYJb3RoFoHVsazwXa8JAZLv+bJIkKXaUjIONAqZ47BjTGFfkypyaAihFobAurs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954543; c=relaxed/simple;
	bh=+UkydMG6S0Dqpzrzmjeb+fTpWVW6I6+gCb4njAVEeR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7lE+/A2A9eicJkQTKoVeMRvupIk2CVkRNRML1w2kmua1msk5BWDIpd+WzgTc4TjxhK6LgdC6sXwDMaOY0Knf2Q6h/K33On+5LkzD4Gc3Wk95Sg8I/aUQ0Q6euzWv1yXl9/hMk1z5oKP1Nxu1glhCg2VXHEsf+KTtia2lGZ6fl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFdGUcym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFdGUcym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F085C4CEE6;
	Wed, 19 Feb 2025 08:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954542;
	bh=+UkydMG6S0Dqpzrzmjeb+fTpWVW6I6+gCb4njAVEeR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFdGUcymt7mGK4VjWD9XBDHQjNdnVuuEY4oIKSNQtYgujkbHK27hcVp59db9Vhc9u
	 WOMVQe6HbXFSDcJI99qJf6k1W5tXWJXuunishRcyYlmFYD+VFr7FFoIFhujuOHeQ8i
	 uGbmxp+shyNLV+f5qboVKpS7OKsbTV6wrf3qJfp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Kees Cook <kees@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 208/274] rust: kbuild: add -fzero-init-padding-bits to bindgen_skip_cflags
Date: Wed, 19 Feb 2025 09:27:42 +0100
Message-ID: <20250219082617.719741047@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index a40a3936126d6..43cd7f845a9a3 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -238,6 +238,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fzero-call-used-regs=% -fno-stack-clash-protection \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
+	-fzero-init-padding-bits=% \
 	--param=% --param asan-%
 
 # Derived from `scripts/Makefile.clang`.
-- 
2.39.5



