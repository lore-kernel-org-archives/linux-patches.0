Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061775;
	b=zsoXR50ofXzQIugt1oXd+k59FHTLT3NUMVabNGA6mIclIPRjQ3uURRw0y+QYOHHZQ5Jf
	 pfmwUwvsLxMc1a17DcgPKCEd4GwQlND8GSt/1PPH623rpn9MummwZc+oeWgmqeYlSO7zQ
	 wIRY3Br0gnMNY4eDQsxjDpT5b9F4TIpYap8RzNSHv+ZCuT/fxZAz43Fj2K5e1KpaPRbZJ
	 9O/OU2Vct1yQ7y4FGIABGNgXZ8Zmkojk1s74i74ZTQJCdSn4u3PG7fz2kVQS+IojH0yaU
	 Qap24rsASmaowz4H3UJLvngrq9Hkv3I18eDB9jz6L4uPjJlbjAZa0DMfOmCwCOn2Stg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+vzu9togNEo8D6iC3MsZshBjH8oPgGr5gVmQxnsLMfQ=;
	b=m5ZlEsPRBSsexnwWo/pgFUPbxw5fxs3pLNP8DlK4ajwKhv0Is5/i6OQCkDxd/D/m22e6
	 pFGmfMeXf4T1Nh10nMmbsNABB/ZGILldmUV7PmSGmF77ScdrN0vyZFwNX4jDxhbv0z/RF
	 9qJbHM0+8DYy8yMt3rW+gBZMUfoQ7pTKsVS0Fs0kkTMwQCXyetMsbA/XEpUXeLCmaehrb
	 EzTOmDESrS/Tl6fb82CY1M6oY3N+pBrR4yi8ukq8i9yDxCexvqmK7WfWFkcga5bVQXc+5
	 VJKpi4Arr/AX/ZvUwPn3gTy+I+WXQA2zeTGrKO8anTWt0OCP0QC6q7gJCQJRVGTo9GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8MzFhQz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69EC606A32A;
	Thu, 19 Nov 2026 04:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8MzFhQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434411F000C4;
	Thu, 19 Nov 2026 04:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061774;
	bh=+vzu9togNEo8D6iC3MsZshBjH8oPgGr5gVmQxnsLMfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8MzFhQz2giZP4Bp0PJVCPrt2RHTJisi1aejy8QFGYWD851byTb5rfx0uSQfroaX2
	 UHZFkAznfCDSQU/MI5cQBljOjQNhrOF7QlZy4INLWWlCtTZpqFy7FgR1o82zf8NIcd
	 86a1RH3X+Tt/PuVmPPUY3oXUvoOtELoT4KfUxcmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 1672/1848] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150029.825395965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 907d138279ee3747efedc9f7403d8b0edb52aca2 ]

The top-level all and install rules return failure only when every
selected target fails, which commit cad6f32665cb ("selftests: Deescalate
error reporting") deliberately kept as the default. They implement this
by multiplying the exit statuses of the targets:

  ret=$$((ret * $$?))

A failing recursive make exits with status 2, so eight failing targets
produce 256, and "exit 256" reports success. Building eight or more
targets that all fail therefore succeeds, and install goes on to
package an empty installation.

Record a successful target instead of multiplying statuses. The rules
still fail only when no target succeeds, and FORCE_TARGETS still stops
at the first failure.

Link: https://lore.kernel.org/r/20261014200115.1363363-2-sashal@kernel.org
Fixes: 5f70bde26a48 ("selftests: fix build behaviour on targets' failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 1d33d2d298dfc..7848b5a3e6479 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -172,7 +172,7 @@ all: khdr
 		mkdir $$BUILD_TARGET  -p;			\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -230,7 +230,7 @@ ifdef INSTALL_PATH
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install \
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



