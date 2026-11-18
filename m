Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032091;
	b=vQizU6M2Dzis+EWbOha7sw+R8aNGWEpFxpIpePPzU5/SuyDCQi/ceI27UtYbn7LiSVkl
	 YxVfku5dDpDh+n5Db6/sknGf/dG7mwzIMjhq/WieLqek8iMxeZiQCZ3iaU0FyLMgdWyZT
	 R7XD8ANLpcGqFoPp2yfAZ8hW2TAd97Qb5/xcmXSZoHdfr0e0A11U2FEJUwrTH/R61NPID
	 SDYf+5f1g6DjJBm8HpknopU98cIBX1SpQa15L+1krGYeNqQMQDroZXYuaWH/Yt4EhIV+v
	 HKQTEvEHd4kvgNnRNZ3F332EjyrhDG0w2MoZI19I4zEdo+Y0v42JCdFIfRQ11im6SiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=idR/4W1wU/Yi5KWm4TyeLbJYT42lWfl5o8GWOgPInEc=;
	b=Ih0OmZJyj50U9MFNzPun7ih41y0hWbwpkA6zEvOSzieqPgHJxBVBTP8zg5u9pagOCo76
	 YwsSf6wvdFhB0PxDxrQVELEmt1nkk5UT+8HxYNdD7odUaCgCzcpd3xz6Kuotp9m6k9MlM
	 JX2Ywvg50atzIEnbxuOhHyCO/IVmkHPo82IEQiDrUAotOFfeqBfu2jnH+PQ4nv5otTkZC
	 Ks3fmKuloO4ObD7ZIvop42UNArNK0yfvUIUBP3b51/WnFqmZFOe2p2/Q1slwEYvuKwAbt
	 pd/s7Ni0yyESjm6cp1eIqXbBvsOjaJpn/nDpccUX81ZkmC9uuX48DA0Qr1zdA3Hk8zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wn5j+iVW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623B606A31C;
	Wed, 18 Nov 2026 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wn5j+iVW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9A71F000C4;
	Wed, 18 Nov 2026 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032091;
	bh=idR/4W1wU/Yi5KWm4TyeLbJYT42lWfl5o8GWOgPInEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wn5j+iVWfhN/HFz0x3yr5MpFa2IXPZQl7lupeVLe0tnUoPYmoUmbectG+QXGndjjs
	 5qU4lIMvYKg5X/PI9Hiufn1Byh/RjbIBrDVIKRsj99zbvn2vXZmGdbFVQA/Vu+QtgW
	 I7wbTLLfDBXviBqL9vOYVdbuvIXCIboWyUQShPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 1290/1756] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 15:56:57 +0100
Message-ID: <20261118150100.907061232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9e363b7f489f..310fb9cfe014a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -202,7 +202,7 @@ all:
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -269,7 +269,7 @@ ifdef INSTALL_PATH
 				OBJ_PATH=$(INSTALL_PATH) \
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



