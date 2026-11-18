Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050681;
	b=30LWU//cthy7GSJYxd2RabpE/SeI3vi6jUHJLwm9Uu2qMRLZZqOk53+OLZr0VP5WfEI5
	 h0NxANtq5j55R+pxKsbwrlM62HZhcaEoYkJTwBrkH22cQcl7OUD0PUZUCUaLxcHP4+kqY
	 wCS1vAOc4G6IBzvcyBZ9wzqmhwszJ35gVFaJ/ER5yvAU2fVub3Lhx6+2gxDZCEdhKMYiU
	 DY1g7wihIr2y11AeRw9ux3kPOpXuO+gDwKsXFd1ZNliG5imxrBmH6v4Vribdub7NXgbVG
	 YWV2+JcU8tRIJg4TjlFVQ4U4RV3z4qnZR9LFnMbDbQcH2cZZ4UD/PfsXNea2u1zjwqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OpZk/1hb9pkCLc7CsK9S42WuJjga0zrgCLK4SU6iijA=;
	b=EcAdGJDrWveCtAPJ/z61RiTzhZdV7qifPecKC6imkhx3yCK6ahniw6vxMsJar4LePbzd
	 9AilbjLFbpSISQjOi/mwdVNYlFD16eHelLolikUF684pGAXZu5Rag9yCpbwjiKep4woWm
	 JDzeg8u7P//PayXAGhsRnvvIq5n1eWyBUmTm/a0E05Jd501oZ/UFH36S41QvRvYlvRetB
	 0tZpARlhGqG9k8ooVRLi8IKiQs2BAYKSSvvl77/hzT2Cv+ZRtAnZ/Cli/2hZ39hwPdV0c
	 HAA1jKbh5KlaEwn4CXXs4mO80QgWeZx64MScBAW07nF3ogqqkwqFahWfd72Zvb4Z61w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APzS0k0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B6B606A31C;
	Thu, 19 Nov 2026 01:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APzS0k0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4FC1F000C4;
	Thu, 19 Nov 2026 01:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050681;
	bh=OpZk/1hb9pkCLc7CsK9S42WuJjga0zrgCLK4SU6iijA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APzS0k0spMxFGfdowOke88cSllNggL9w31YFsrQ/+RCywL8ZYOEFdcr/4zubZOPnY
	 HHp5JovFwvIrNJjCFvIUwHO0jQSJC+NP+Hh2F4/uV/c9qlTOhr0daX5EVC8lS5Kp4o
	 HWo5iN+qT40BL2fa8d5v/FpxHIZEX4kA5KLOd63Q=
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
Subject: [PATCH 6.1 2757/2857] perf mmap: Use the head selected by read_init
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150340.875626275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4dff881be39b..bbb1633ff0019 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -324,7 +324,7 @@ int mmap__mmap(struct mmap *map, struct mmap_params *mp, int fd, struct perf_cpu
 int perf_mmap__push(struct mmap *md, void *to,
 		    int push(struct mmap *map, void *to, void *buf, size_t size))
 {
-	u64 head = perf_mmap__read_head(&md->core);
+	u64 head;
 	unsigned char *data = md->core.base + page_size;
 	unsigned long size;
 	void *buf;
@@ -334,6 +334,7 @@ int perf_mmap__push(struct mmap *md, void *to,
 	if (rc < 0)
 		return (rc == -EAGAIN) ? 1 : -1;
 
+	head = md->core.overwrite ? md->core.start : md->core.end;
 	size = md->core.end - md->core.start;
 
 	if ((md->core.start & md->core.mask) + size != (md->core.end & md->core.mask)) {
-- 
2.53.0



