Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C1A352007;
	Tue, 16 Jun 2026 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632879; cv=none; b=lytgKOsBmOXojAVmP1SM+1EXWNaDSKxs5m4AAVHVsDtZQNOBBRJP1ClXAXuw/RVxqOHuQY3w8NT08OhUkJgXJxLfY2phxQdxRANzM+HACiLTPsxMFKO03alrdI5rj4Vg8hAZzFK/Yc+DLWRxQYcIv3ndrfY1AgPTBs054YtkPP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632879; c=relaxed/simple;
	bh=LATR7yHShRC9r4zu1DfKvqLdh/dm7+V9Ru7+aJi7ad4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqmV7tePQuz0Osq9eb8HUUXliaDIaEjJc+bExBEId+55tF/X2QphYoXWrND7mdCNpKHP5ES8fatrgB6lCs881sIwCQtRNlKuXdncC991Geakoi3/NhnUP94yd7KSBZebVi7jtZJTqc/2R+XkucZRcbN7QPwrSet53RkSd8DBocQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaADAACq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaADAACq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041B51F000E9;
	Tue, 16 Jun 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632878;
	bh=fG/zKhGdJ1bjkNKtNUqIjoOtlgH54RkLTpcTlhIu9/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaADAACqVhnvbN6xHg6tqqgNa5pqWcZbcfK7W3xCoSEGy3qpPs9NsRkyfxoVks6D8
	 0Nifi0mFeyh/G+afug5Atd4KZzyhCSE+6HRU4/PFS5jP6P/iw93x6BPbCwOAH+Wlnt
	 V/zuC2nGai7UemEneweIEoUYPzUso0MMwM84GhKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 495/522] perf build: Conditionally define NDEBUG
Date: Tue, 16 Jun 2026 20:30:42 +0530
Message-ID: <20260616145148.940932907@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit 616b14b47a86d880ba21a363440f20f82152d8f2 upstream

When a build is done without DEBUG=1 then define NDEBUG. This will
compile out asserts and other debug code.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230330183827.1412303-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -228,6 +228,7 @@ ifndef DEBUG
 endif
 
 ifeq ($(DEBUG),0)
+CORE_CFLAGS += -DNDEBUG=1
 ifeq ($(CC_NO_CLANG), 0)
   CORE_CFLAGS += -O3
 else


