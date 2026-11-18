Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018907;
	b=d8MFPvbTrsYQoDuDpEZ2zCNnfF1iryHMDism6vi3I+oPmGwLx+4ZRhjEIByUMgjMft6B
	 9nxSyEE/ERBdX0Vf2AX39N1dxJgiTfa9DzX7Rtsv9XXxcbAO0gMW8uxHwB58R+hXQx/F3
	 wPKFaAdBDzKkkBckyntRl46+4ZPa0KXST+J2j8YevuvCOdnNQDC8gx3JzEAbBJFDZflc6
	 zYmh81Csl0pol9E8cxBaR1lA5SLLJ2uyda2dmPIDRM7JOMcvuAua6df0WAzw+8Ei+EalX
	 gvFw2h37ZgoVCTy7fLjUabUK1KaAUCbzvyl+ruXGH9L5jREXk9eem26rRpN2qfF7uWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IX+AWxRQ37krY5ZIJbbiknhmTQ/+nbEaUPm7V/SMvZw=;
	b=OldWWBdyk3oscjVFtfD/6W2xtzwXnZWJPnOOZahWUlaZWJNB0z5WMHmryxbZJ88lBpH5
	 ve8amq/ovVfbv2dFJ4RoYUzcTxbE49GO9dxKrBrXrGQa/QIYS2tS90huQaxSUHmWHeS++
	 FLQFyOZpPtTzxmtir0ASYrDzFUr2wiWhJ+UMUN97NTqgMA1v2GYPPGYx/Nf5jhFdzM6FW
	 G9PwNBkuHnL7F/khoo1k9HMoEMAIUO1srFlMTospTeQvLFlV8Uf+ARRE4n2JqqnLlNWk9
	 llV1TjnxHrO3xfrIuBpeJ8E/gWA7wSbqXq8hCGEDXKEcfShJG/RKONTcLRVWS9oC7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvGN6oqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E547606A31C;
	Wed, 18 Nov 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvGN6oqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5081F000C4;
	Wed, 18 Nov 2026 16:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018907;
	bh=IX+AWxRQ37krY5ZIJbbiknhmTQ/+nbEaUPm7V/SMvZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvGN6oqs5mtekoTy/vfoMxxs3m+rlnRgD0gkjCX9fLcyY08ZDvxt6DcGvdWKT6o4y
	 ZOBkqkjZ082lP8qYxy2MaHPAC7ZxyImTmtdLZqR9QLIb5sVlNgMEjE2Ji96MUqsHXz
	 9H9Dzn3eHx+s5j+CdmxS3raLoSBp7Tjlz5Xji5HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1408/2651] perf test attr: Fix wrong size expectation for events
Date: Wed, 18 Nov 2026 15:44:08 +0100
Message-ID: <20261118150338.696968889@linuxfoundation.org>
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

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit 5c52bb65844426070edca789ae7896c56e314bcb ]

Although config4 and tee sample_simd_* fields has been added into
'struct perf_event_attr', the size expectation for the struct hasn't
been adjusted. This hasn't been noticed, since the testcase's return
value has been ignored after rewriting the testcase to python until
previous commit.

Fix that.

Fixes: eb89aef367e47010 ("perf headers: Sync perf_event.h/perf_regs.h with the kernel headers")
Fixes: 80cdf208117a36de ("tools headers UAPI: Sync linux/perf_event.h with the kernel sources")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ Updated it to take into account 80cdf208117a36de (sample_simd_* fields) 144 -> 176 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr/base-record          | 2 +-
 tools/perf/tests/shell/attr/base-stat            | 2 +-
 tools/perf/tests/shell/attr/system-wide-dummy    | 2 +-
 tools/perf/tests/shell/attr/test-record-dummy-C0 | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/shell/attr/base-record b/tools/perf/tests/shell/attr/base-record
index b44e4e6e44438..a4597d4c0cd12 100644
--- a/tools/perf/tests/shell/attr/base-record
+++ b/tools/perf/tests/shell/attr/base-record
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0|1
-size=136
+size=176
 config=0|1
 sample_period=*
 sample_type=263
diff --git a/tools/perf/tests/shell/attr/base-stat b/tools/perf/tests/shell/attr/base-stat
index fccd8ec4d1b02..67d6eea894703 100644
--- a/tools/perf/tests/shell/attr/base-stat
+++ b/tools/perf/tests/shell/attr/base-stat
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0
-size=136
+size=176
 config=0
 sample_period=0
 sample_type=65536
diff --git a/tools/perf/tests/shell/attr/system-wide-dummy b/tools/perf/tests/shell/attr/system-wide-dummy
index a1e1d6a263bf1..b062ad7f3c1c6 100644
--- a/tools/perf/tests/shell/attr/system-wide-dummy
+++ b/tools/perf/tests/shell/attr/system-wide-dummy
@@ -7,7 +7,7 @@ cpu=*
 pid=-1
 flags=8
 type=1
-size=136
+size=176
 config=9
 sample_period=1
 # PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
diff --git a/tools/perf/tests/shell/attr/test-record-dummy-C0 b/tools/perf/tests/shell/attr/test-record-dummy-C0
index 91499405fff4d..54adb835d203f 100644
--- a/tools/perf/tests/shell/attr/test-record-dummy-C0
+++ b/tools/perf/tests/shell/attr/test-record-dummy-C0
@@ -10,7 +10,7 @@ cpu=0
 pid=-1
 flags=8
 type=1
-size=136
+size=176
 config=9
 sample_period=4000
 # PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
-- 
2.53.0



