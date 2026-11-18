Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062105;
	b=YbsyVxJ/IpWCuafkKoh1ZTv5i6p1SzgyKDaDevmK7Ws4iS8tSrvCRCyZVCCJZfeCgfTz
	 qEFWlzWaYoQmY3a0tm+p0sCYx2f1NrdSEcCy7oOXMZDR5+QpooVRy8myIQkxqP6aeyf3K
	 VOscR/7nwSl4NXGysrxR5odLb0LvdPUPXEcqZqoM9YyDVWzZ46WxSU2pesabPIA9Igh08
	 uuv9XTB5hIXEjhbyQSF+cSoOnT1k5lfIHHmLdWs6XjinLB4u3tBYZdiO1BNFFndcUtkiC
	 swI8oDi/x3B9AzvkbBHA6DwQmLty2qZxhQLIdVANrfoBW5JNJ+V7AnBsgZCnATQwR4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m/9TIv6ENk4f2RKfLeZxeEXc0YT78TplBeSj84oOJjw=;
	b=Dwd+6EJjJc5VynEl0UiDPRvJ+zJe25X92ph9wdsJUEHVssf2vErzcY9vMB80XuAhdUEg
	 tpLopI4a0k72zhIbpuhg+57EKoZyCgPBICOV37CVh4Og8Ex17YsAmbbQvqv/t0HYT7cCO
	 ZzJJV/vHQq5GvsNsigdiFToi2nRKaJ9ksu8aA51pDaTVYlfaKlV7StSSH+V4jD6bS/0uB
	 fv7H9J6zF8il2ssafMX+KxDsCmSD0eTS5F6yuR2SCbHJsAV0mc9o0w7iWI91/FiveorhZ
	 sqbEGH3eMxz7OoL9peQWX0R7S5xVNLBOKGqWrDe8K5m0OhEYMns05TGu0ZCxCHxq5/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXnc2IuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B40B606A326;
	Thu, 19 Nov 2026 04:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXnc2IuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AFE1F000C4;
	Thu, 19 Nov 2026 04:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062105;
	bh=m/9TIv6ENk4f2RKfLeZxeEXc0YT78TplBeSj84oOJjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXnc2IuSii0+GhjosO3KKX56fjxdHXiw3/iWnt4zKXdPWJgQR5UyfmOiAj8b6U3+p
	 I4VVjLjoriJoNzvEc3HHEu08LGbcqTpzIt5iBHHY6o2wCn1iglDExHoYW1GsPS5Adw
	 m48WioVgO4HmdZz7xq/rLbySQFpOFkeaZ9JXax4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1792/1848] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150034.314615730@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

[ Upstream commit 022c64992af554cfd8c564bff86100fb5ed98678 ]

perf_mmap__push() reads the producer head before calling
perf_mmap__read_init(), which reads it again to select the range to
copy.

If the producer advances between those reads, push() copies through the
newer head but stores the earlier head in prev. The next drain starts at
that earlier position and can write the same records to perf.data again.

Use the head selected by read_init(): end for forward buffers and start
for overwrite buffers. Save it before the copy loop advances start so
prev matches the range that was copied.

Fixes: 8872481bd04850b1 ("perf mmap: Introduce perf_mmap__read_init()")
Signed-off-by: Paul Moses <p@1g4.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
index ab7108d22428b..495439887311d 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -313,7 +313,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, int cpu)
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -323,6 +323,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



