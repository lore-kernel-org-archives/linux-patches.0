Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029835;
	b=xK4RZ4VT5Z5EAvitUsIp2P03nSD38pEX5n8lvXS+zHh+Gm7ZuU/1+lUD9sW+ctQMfI+7
	 w3uqdcd1rVZI02HeyZdt/ZgDjrHvzzbhpy0v/+nYmzTlj4rQUJJlhxTdDR4xCBbgLE4xO
	 Wx/l/2o1LlXl3o+E9lob3mITfyFZ8P5/6EY5UD0T/YyPw8ngPAvMWvvduSdLmLwMMQXsD
	 knm/git7UEYkQw8mwekbFvE5wlVuauskhd8QBMm6ZG25pnv6ov6fae9oTCruuIKfZyacc
	 q37Z17P6ZVfxQvWSz4ASxbNeo4NcUwm4Vfz1lGE8KHN7fM76P/9xBbvn8SA0WQeuMnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEaVL7saISnbVotlVyN9pRe4xJFFoLW5JFYBBMoSjnQ=;
	b=Xu79w9ooDZ3GPYkn0isVqtw5h3ku8RwCvXnQMVYhpspr2dZ9rpcRc53BSWlHN5FLpJAo
	 Mw7XRzMZe5M06XSDyWsJW20inq/X4Me/P6kx3RMsbBqy/2WLvlA7F9kgy/PAOS8z0dHNt
	 3GSztivnsG5eR06El2ND/obDwv9VRV6jlqtGrNCilJ8qVJuK+BzWuNVozmur8Loz8pIq9
	 lKtXpd1EqATFyH6IwAHMbOZ8zFF8MZRqmTt2pGgMkRmqarPAi14c9x2RuPFuR3kb63qB2
	 WZB7GwKruDdhtWgsfih9/82zjl4nQIiQDPvYGXD8hBxRum1N72XEg2RXHufS+IID16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhG5OWaw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E3606A31C;
	Wed, 18 Nov 2026 19:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhG5OWaw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4D01F000C4;
	Wed, 18 Nov 2026 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029835;
	bh=tEaVL7saISnbVotlVyN9pRe4xJFFoLW5JFYBBMoSjnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhG5OWawdxZh5d6owZ+whluJyLxYtTmsc1LbGq2nUD7T4i2W17LT5x7RUZG7CgxIp
	 6/0w0baH/dxM6HSp3SsVkC1t+XbEnl3D9TFmdMhBMhFV5/lhr38YU4K6SIWMqGFoaE
	 4GBrQKpEoJqUfOGcaTwH06pgei3D/d+ksVdUIkVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0491/1756] perf test: Fix a leaked map reference in the arch dwarf unwind tests
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150028.657965792@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 1622c9ae39e2882fcbbae7c9d27dda13f1880b93 ]

maps__find() has returned a reference to the map it finds since
commit 42fd623b58db ("perf maps: Get map before returning in
maps__find"), which updated arch/x86/tests/dwarf-unwind.c but missed
the arm, arm64 and powerpc copies. Release the map after reading its
end, as x86 does. All other callers of maps__find() already release
what they get.

Fixes: 42fd623b58dbcc48 ("perf maps: Get map before returning in maps__find")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c     | 1 +
 tools/perf/arch/arm64/tests/dwarf-unwind.c   | 1 +
 tools/perf/arch/powerpc/tests/dwarf-unwind.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
index 9bc304cb7762b..7b5330d77b00c 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/arm64/tests/dwarf-unwind.c b/tools/perf/arch/arm64/tests/dwarf-unwind.c
index b2603d0d3737a..4871041f72146 100644
--- a/tools/perf/arch/arm64/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm64/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/powerpc/tests/dwarf-unwind.c b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
index 5ecf82893b84d..f2c5e76590ebe 100644
--- a/tools/perf/arch/powerpc/tests/dwarf-unwind.c
+++ b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
-- 
2.53.0



