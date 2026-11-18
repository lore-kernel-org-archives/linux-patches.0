Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056407;
	b=1AyS3dsAwckBzs0aqKEeet5igKYvKsYpOAlRe/grCwD+sfjwc9nWsepf4gx9IXX2devB
	 3NRQ4/15BmQGQc9244O9ywo831gx6wQeoflje//62VrtxVg409VM6/Qop2kx+JOA+kMIJ
	 7N7tl5GhSIs8fGSVOnRqc2BJdtYT99WmJasDyTNwVp4gU+8Ba03uCN8nNl5GR/NL1Hoju
	 IqHtDpwqGJUQ40dc4jdCZVBtSKXMLNm9Xey4eSUIhPYbZG+yjBBQi1+jDvt3DeConCn7J
	 WZcKb0WcKrH+SQ/FOzqevCJFTymOIkh4d4Z4FerqnIVo+S8Q3zeAXqG1RhPSPE4NctA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=56ZWEezXokrOE04uAVR8l+hhJqbAT/8dbI+3RqIGMGM=;
	b=31rqN15r8nTNKPJ3kIAwqOSZBLvY9HiSkMZ80E75itYmXKK2aiakQnwxshtSa6ohrQSg
	 ojt+7XDGBNJPAceKHTmA4tlL1qcIF1yLBhS5D9LU+d8NVL5BN3zIZUHtR7rc4HvuY8JhF
	 PESeTUnW9VKnnei+pw2d6/s6yjSd9t148moELLfHijW9jo2Q+lzmwQ2OXCprJJOCuvRKd
	 VI6ZSqpPWoG16gx4g6vlWXfcqsthIacIUEWJbV1BbwmCQ9hAM7XeepGUZyxJ27hgyc0cP
	 mkiCSuCOOOHn2y02hDIGkVnews+s4x7K/Z8gcoMwMW94kwBlkMiF6AUY+vNH3ZIIl4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9gerHFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4C606A31C;
	Thu, 19 Nov 2026 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9gerHFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A8A1F000C4;
	Thu, 19 Nov 2026 02:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056407;
	bh=56ZWEezXokrOE04uAVR8l+hhJqbAT/8dbI+3RqIGMGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9gerHFR08hjEjowSImgn6IeKOpmuGDOTfBvvtld24LX8lVSuu3jydreHNT7xwir2
	 cLZ9JGpm5GZw3aKlHQR+mEkpO6Lc17S6zJG6ViYeWtqQATpdpJ4CHhUSAXSsNCF8tU
	 CK0DbCypPP5TeHgP2/EnG7XEqGT0v/JU093qEiF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 1976/2214] selftests: keep the build status from wrapping to success
Date: Wed, 18 Nov 2026 16:00:52 +0100
Message-ID: <20261118150129.936985773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b71b7958effc..1f4c0bca25a76 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -175,7 +175,7 @@ all: khdr
 		mkdir $$BUILD_TARGET  -p;			\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));				\
+		[ $$? -eq 0 ] && ret=0;				\
 	done; exit $$ret;
 
 run_tests: all
@@ -233,7 +233,7 @@ ifdef INSTALL_PATH
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install \
 				$(if $(FORCE_TARGETS),|| exit);	\
-		ret=$$((ret * $$?));		\
+		[ $$? -eq 0 ] && ret=0;		\
 	done; exit $$ret;
 
 
-- 
2.53.0



