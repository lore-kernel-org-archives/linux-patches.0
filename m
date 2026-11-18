Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041916;
	b=Wwz9WjizjX8EHQygc3WEzAVAmyDZxk91PvGt2zR9ZVSzPAPsqJLz3BN3Pm+c6406dtjW
	 GrOVgBVTkzrwXEtwhNMsNUpWQ2FpZ2Ml2AdAZNzR0t6aWQjr2IbfjZMngD/S4sv0OEFt2
	 ZNckeNmvNb7K5Fo8RBTx1D24lg8YRwADuF5oC/QUAEHkBWQa2rjP0piXcFNJPbcSezha8
	 v6m2f6uYWPGlIeMledFTrzYjS3gwpvHn2absFUPxkhB83kKlJmQNezyuFk1gmljOe2avb
	 8kBbGqRd0kPPQM8MlZdeg6lgF+p6SGlXAuGdMGYfAC6ufHifzUxFTwCXLJqG/Z7nTqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0CKlMwzH5Qp+MjGe57TxD4ivCaS62pBLEko6oXGnlg=;
	b=u0yopPX1SZrgwbqSjHwIol3ck0spCr6RY+EAucgiclc2EL17qRw9WAO0OSJ0v8GjZ/S3
	 Y5hk3J40zhZx81B/nsyU3oFbUmIfrn2ey2OtuoMlidf6x3h0FOx1ktEjiVJkNZvv/ig7m
	 MhA0G6m0293MC9jBsbF2S1ipWm8xk6SpQMa+tq6eOIXu4F1g6sr++Fs0e3AgNZRt7eear
	 Z2OWwUdO5lrTzH8TGJh9dcNzlXyIEPzUUd0kwTQK0Wu+naOLcGGAl0kGZ9zs55+r2Jhjb
	 xddbrDBUmjs+dr+dhoowg4iQQjGVhr6v5VpChgEgNFYsJ6uvzVwbZyP5x+D6IuPRpJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7+rDqRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90365606A320;
	Wed, 18 Nov 2026 22:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7+rDqRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11BE1F000C4;
	Wed, 18 Nov 2026 22:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041916;
	bh=W0CKlMwzH5Qp+MjGe57TxD4ivCaS62pBLEko6oXGnlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7+rDqRe2vZTQLaD5Hh/tTQ8yet5eO/anS3VemnXInUwCki5K12TRbvlV2ILqv50X
	 pQudFaN8YdEbTPzdLu+kg4wxHJg4hcDYXASeANam771y0A6JzvxgCZOVEsydev4flF
	 LSDJ/kh+IkGwtnN25LC3hTHav2p1LZP4uc4pk3Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 2943/3318] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 15:59:25 +0100
Message-ID: <20261118150448.634758330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a670d5de302b9..5f4e8bebe0efc 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -177,7 +177,7 @@ all:
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -242,7 +242,7 @@ ifdef INSTALL_PATH
 				OBJ_PATH=$(INSTALL_PATH) \
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



