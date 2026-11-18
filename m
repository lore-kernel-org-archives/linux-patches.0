Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020524;
	b=RXbULxrbLt/l3/Ct7c5nfdPqwMkgaqsQZQl4B+dUSdo0y6qZrP2cu/F5WBxb0YVy7BLr
	 IhPB4SeecF67XVnko+74AbEphRlqK435CaAXo5q6VNd2s0a4Yq79bzPH5NnEZQDLjkPK/
	 JcxxrttHD1zptTE9BCijbILAnWitn5HPc9TYxWDGHmwVWTKbA40jBLMKrBpcG8xpcjXn+
	 hx8aZnnfVK3i+YnbGngVJMVPi3mM8O7E29iKy1/PLDnpEUupkjcI5n32l72B3OMtwaoij
	 bJ0Qmsf3xAf/ItYxK94qObFnpC97NuNKimlkFphphrw4KIUgrYRu8ErM22pmayj391A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q9IItLIEbMnYP6dU4HjidN8jf8ToHHqGO5mUhn4HIM8=;
	b=4DDS8bvI1IyBeJ3CXvoBfP0VeUdFnABxoK8gMQKAvWLl+TkQA0jg6B2ehVeRgP7lQez7
	 sfA16uNQdWfJ9WAZ/lmh+U8laoPkxDDqqNuyM+DHHZDdMrQgBD/8JEbFjhYKYD42XaVeh
	 z97+m2TYyDRXu0P3FeCLX7PgK+hipABqLC8P1eMa7LB8J6vlXLb5LGa6KKvGQ3vs6VRrR
	 miHvxXrqDYMXCGOD1tJkDG+280SeW+dk6UnB+exhpCgUK1VOVF5NqDH+vU1Atp+hSyZA1
	 GmLkKnjS6sTuXrE1NwSE/WxrH/cec4KPWtQ+4NCP0mFFfK7eSvS2GL6Una36sZgiQtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBqHvoX8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB138606A31C;
	Wed, 18 Nov 2026 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBqHvoX8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303D91F000C4;
	Wed, 18 Nov 2026 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020524;
	bh=q9IItLIEbMnYP6dU4HjidN8jf8ToHHqGO5mUhn4HIM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBqHvoX8L1ThrSBkBRc+pHXstieKRuS0mocy7zycM1skoLSjUZVYAdHsGUnZvZww6
	 eLTrSqo3hSMTn50K2weevnp+PAeiE3/SdqRFbgQCHedWXre2/hXJ7MCRza6Zx3yRxw
	 /88uPiKyikWjKydSvLfl++Scxy+dhCTz30SbBtD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7.3 1983/2651] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 15:53:43 +0100
Message-ID: <20261118150357.791012940@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bc4fdb6f53375..45ab2d8eacffe 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -232,7 +232,7 @@ all:
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -299,7 +299,7 @@ ifdef INSTALL_PATH
 				OBJ_PATH=$(INSTALL_PATH) \
 				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



