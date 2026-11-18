Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016751;
	b=TF1DwGzewO7lv+6mPrYyHFh7K1b+4xh6T++1/BP3kkqMAR0fOx6UvFXsp8Hvqp7j5FfA
	 S6tpUQNCAcqRPw/aGqhG40uS8QNCG2QSAsuo/q+SVurNH+57hZmfpIzo4DDSmlhbS7uEL
	 LnZ2ffJ96aEf807xuta0aft/x8iDBxr1LG2LjvdShTYvVXEoX8gB0ZiFk92dLBqP92Kkh
	 S+mq5SuGxlFeHmYUD3Rgbh3GnF9PZawY4v/CpRdwSP34JOEgcTqEA9hm5gBDQ45SkAezF
	 OC8jIl/hAt/4oi0fVTsYfTQHza7HWp+sZp4dmZg7k0AcMZfaqESwwe4iP1Voa7za99g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/OeemPeTiWTThPYzSsEhCtQN9POxzoiK45DOHpFCEI=;
	b=xPPiY4KP9ULhJX6PzGWpcSSDF49Y8KZb5J104uMf8Z1CD82wiQJYOqSLCzTuAiWS5cMO
	 AqW43ykotnmmVhHtwWjXHBRHy/05iemlB6vARifCcb21H03ezoqJbHOPvrj+hGEr8+YuZ
	 NU/FAjraZAu1AVbhPbmlgvkYsWvPqLaTDfXWZw/SlwVfEPUoov2CShGfvbQncOjeamKas
	 6qnl4ldLIOXHt40lI1e6f9aLkA9TPIC7IIuUmcS/viG5Dx+KzxI7cfAv7bdncGQsVPlM4
	 YKUMV/3LIs0BGm/AKWoPrOfacVRGuBaY/de7zlJU3mkWcskFp+idVOj9ccTkDogqjNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tykxHyIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57EE606A31C;
	Wed, 18 Nov 2026 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tykxHyIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0270C1F000C5;
	Wed, 18 Nov 2026 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016751;
	bh=X/OeemPeTiWTThPYzSsEhCtQN9POxzoiK45DOHpFCEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tykxHyIYR3vpZ5asJIH/JJ9h+6GbfXy2Bupo1awnQ6R9uIGnx7fLVkTr6AQy7EvZU
	 SW6iScfLs4SNTJu/8neB75dXY2chKg5BjhjOg3A5iy2WKLrrXZ7oIF+MJU0MOnhioA
	 Hi+eqqALb+JFp3j49XmLvQL4TB467CNrh+Wew4pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0639/2651] perf test: Fix a leaked map reference in the arch dwarf unwind tests
Date: Wed, 18 Nov 2026 15:31:19 +0100
Message-ID: <20261118150310.690306775@linuxfoundation.org>
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
index f421910e07097..d4707e9ffd2a8 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/arm64/tests/dwarf-unwind.c b/tools/perf/arch/arm64/tests/dwarf-unwind.c
index 440d00f0de141..fbc161a493697 100644
--- a/tools/perf/arch/arm64/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm64/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/powerpc/tests/dwarf-unwind.c b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
index 66af884baa660..b4bade5d59e24 100644
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



