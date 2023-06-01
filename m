Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486C2FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D8BC433EF;
	Thu,  1 Jun 2023 13:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626147;
	bh=iHMZYPR+yHG9Gp5ExWkckF0p5lSq5Etp1m47Q6PE2tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBJQqs5MlPyRcaYxCDNCRKtA4i6pMLuCkhxB678PfWiUjf+WM61aW0GcvVzg0bmL0
	 qrVdamxQLw9QLDuCrg16lQVb4cKrA/NRbarNS4kF1sKl+Y7rcx1O3JoYlc5YHP6F+M
	 p13xhRrYnLtf/NArhVivYtX6JA85/UYYjPTOmjhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@loongson.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	loongson-kernel@lists.loongnix.cn,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.1 42/42] tools headers UAPI: Sync the linux/in.h with the kernel sources
Date: Thu,  1 Jun 2023 14:21:51 +0100
Message-Id: <20230601131940.948650518@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yanteng Si <siyanteng@loongson.cn>

commit 5d1ac59ff7445e51a0e4958fa39ac8aa23691698 upstream.

Picking the changes from:

  91d0b78c5177f3e4 ("inet: Add IP_LOCAL_PORT_RANGE socket option")

Silencing these perf build warnings:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/in.h' differs from latest version at 'include/uapi/linux/in.h'
  diff -u tools/include/uapi/linux/in.h include/uapi/linux/in.h

Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: loongson-kernel@lists.loongnix.cn
Link: https://lore.kernel.org/r/23aabc69956ac94fbf388b05c8be08a64e8c7ccc.1683712945.git.siyanteng@loongson.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/in.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -162,6 +162,7 @@ struct in_addr {
 #define MCAST_MSFILTER			48
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
+#define IP_LOCAL_PORT_RANGE		51
 
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1


