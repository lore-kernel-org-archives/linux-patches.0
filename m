Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017499;
	b=pzUbRhv3Z0YzhENfsL2mVPTtrYFcUGbS7llPv6VMk4Z7y8G7xb45Q9/IFv+GA66B7Vcn
	 vy8+dvbrRXcXkuIwq1DTj8T4ineWKO5ifK+72en7hWf3ppE/2+oGfXklbeOsMpEHmPOFS
	 bqENA4ruAqKWpTgK3+dNMkpgvgl+gBstTNmXxADmFzBz9NJh0hmtn3+KEUXeoZwXzFGS2
	 JVzGqg6dgqgFlASmwayk5Vsty08Proy+/tFH+tRaYQhjAuaDra6mkNOLqJBmVWaAtl1RF
	 rMZMK+liBZkwP/bNzO/sCWS1i0KbCk8DBAAsY50PBD+OCu9op0gDRSjNm30IpegRXAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+XNeIGMA9S8t7wkCL02LMcz6nkyTDdWT0ZIvp6izTrI=;
	b=fn0wjobGK2lLegLTMqzbjAzEV9S1fP6R/y3Axlr9YuVpNYqX40Ywc0ankVkig5XihXKA
	 7UNTvUfUK+cT9b8Y/2s6kdw7DoDJB/bnjzXHQffAbxMRqN+Ip87JFiYY2X9pqSbEP28oy
	 p6NgnDBM/ZF+/wDDaxflGiQrD8zCx55pDU55gW9hiqVgV3c/sE9fMcpUcAgD0+MgHWWD9
	 e1GkZvuJ6QgHNxPx27N0Tc7li9eP1BTVVbzUiulA2E4LHSOioivsRYiMdviY2e1RVPG5H
	 kFtehhWBuy9kFdgQh4Q+InD5c9tz+WmBTsQT3rbgqHRZJtZCkq0IKdcHUFOUg45AXog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OO8U2aDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77168606A31C;
	Wed, 18 Nov 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OO8U2aDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D5B1F000C5;
	Wed, 18 Nov 2026 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017499;
	bh=+XNeIGMA9S8t7wkCL02LMcz6nkyTDdWT0ZIvp6izTrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OO8U2aDOpTiDxm5qI6P0UzbZg5YtaYKVlkzoTbfwWBPH5eYOAewrjWQufs75mncYK
	 avpkMa6pRXIJtzv9HFkCSKnUPmc2QJ+oBw7Kqh0mCAbY7/HWllMtXT8ztAXFPw/aXz
	 jkmakY/GfRfDx6FdQCRZuyylIWFot7mJNsqc7pBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0905/2651] perf synthetic-events: Check schedstat domain allocation failure
Date: Wed, 18 Nov 2026 15:35:45 +0100
Message-ID: <20261118150320.456092965@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit bac027175ada974b3fde9eb0690ca5d698e0a6d1 ]

__synthesize_schedstat_domain() uses event after zalloc() without
checking for allocation failure, unlike __synthesize_schedstat_cpu().

If zalloc() fails and returns NULL, dereferencing ds->header.type
immediately crashes with a segmentation fault:

  Program received signal SIGSEGV, Segmentation fault.
  0x00005555558aed8a in __synthesize_schedstat_domain ()
  #0  0x00005555558aed8a in __synthesize_schedstat_domain ()
  #1  0x00005555558b889a in perf_event__synthesize_schedstat ()
  #2  0x000055555563c397 in cmd_sched ()
  #3  0x00005555556583a1 in handle_internal_command ()
  #4  0x00005555555bf739 in main ()

perf_event__synthesize_schedstat() already treats a NULL event as an
error and cleans up, so return NULL when the allocation fails.

After this fix, an allocation failure returns NULL safely, allowing the
caller to exit gracefully without crashing:

  [ perf sched stats: Failed !! ]

Fixes: c3030995f23b3d35 ("perf sched stats: Add record and rawdump support")
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Swapnil Sapkal <swapnil.sapkal@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 2eac2310a01da..f5c90d4f4262f 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -2776,6 +2776,8 @@ static union perf_event *__synthesize_schedstat_domain(struct io *io, __u16 vers
 	size = sizeof(*ds);
 	size = PERF_ALIGN(size, sizeof(u64));
 	event = zalloc(size);
+	if (!event)
+		return NULL;
 
 	ds = &event->schedstat_domain;
 	ds->header.type = PERF_RECORD_SCHEDSTAT_DOMAIN;
-- 
2.53.0



