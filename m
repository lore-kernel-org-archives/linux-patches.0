Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026960;
	b=UWzfMqQY66vwNcbz937md0yvmk+A/f9niWSYRbMOEO+ow5wp8mqNeZmJabEfKXT1XBrX
	 5RAKGRnWEi+nDWcelH8j6xfvvB1jm+P1KW4jwnS8+QSI2DtaTjbpt1nkJXBuJfOZk0YUL
	 qu/bp5ht1UxF/20Cmwe8KQbbDtGgEbJGGA/gnf+FlJIkZlKv72ZKTHAw9+HsHY3zz8wGQ
	 pcT9voTqXFsM75jc1swJg32fiYghfjsyS6q8eyjVg9ZwjNyqbEm5poZYI2E9Khp5N4uZq
	 bAu147XllM5TNKf1JU+IabfkHpvtdn7PH1xw7GB7PRLUbIMNSPxkUM8DZ42VkI04Myw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=41SMMzLhBiigqeGXicqOBOafe8IE99/ZqGci0jMAgyU=;
	b=HS8pRzXiP72IxysXskaKxwV22qzKUTNlVoaUcALbHDbVNVyMClZPNM4ZagWo063Z7FGn
	 KO0k+wYaXdxPoJEUwdP8Mbfnz55tGTcGnf6r12PNp9L/71DfZydtvKRYUSjXImKbeQJoP
	 CMW1o1IVGzbd6apJeoplNIt6Phfjx5/jEb1PbqwOZ6QfGAPOPd9+T/pHf7Oh1ofgUtUqe
	 Wc6Ii4zeGvAwTUkf098gGWGkby9BYiWDde2O1F5xZ5hfFmUhtsh7I1/ReaYyjZS2+9Cjs
	 wnY4jQhyZCkg/QTPxvDQcjWBaPxLf8eXAzKzgFLMIanot+tLkf9DItsxfHrKpSM8jYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbHa824T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49552606A333;
	Wed, 18 Nov 2026 18:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbHa824T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995471F000CA;
	Wed, 18 Nov 2026 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026960;
	bh=41SMMzLhBiigqeGXicqOBOafe8IE99/ZqGci0jMAgyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbHa824TX1ew8qnUEFPs0GYlVhLZTiqPYRjosfhPEqvb65WhEJO19h7F0IagkyOKV
	 L48CCLd/eSH2O6JVSPP96llEundUdZ1deG5i7N6nDDWUAIdWWxmG7VrYTEsiBoxcFA
	 fLD2DxdGQ3KXwJRNMjF61n3cBZYaA2ad2ehZUW4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.18 1620/2151] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150220.894297292@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dbf81e9a7785a..bad20cfb37563 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -214,7 +214,7 @@ all:
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -281,7 +281,7 @@ ifdef INSTALL_PATH
 				OBJ_PATH=$(INSTALL_PATH) \
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



