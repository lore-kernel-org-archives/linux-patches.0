Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2979C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C04C433EF;
	Mon, 16 Jan 2023 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886280;
	bh=LTXeYNjfoeH0hkMRfd1kIlFfsqUDRKZjxUkLpDuRLww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt7Cj44j3DfS3yrAKS0DR47dbqi/aWw8Zx/bAu9mnbVXbnfPnC5ncZgCFDtJkF+zd
	 ma3HxlgDzte+xfd5RJlu564bdcbJzU9FyEqXtRLOq5ulst4d/+klkTnF2LwK8Vkr+r
	 TzOAjSCo5Ir5OOs0KxZn7jCT0vLIGQrvtwz3kUn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 370/658] nfsd: Define the file access mode enum for tracing
Date: Mon, 16 Jan 2023 16:47:38 +0100
Message-Id: <20230116154926.499053436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit c19285596de699e4602f9c89785e6b8c29422286 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Stable-dep-of: 3bc8edc98bd4 ("nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 127db5351d01..dc6aae4ef41d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -166,6 +166,12 @@ DEFINE_STATEID_EVENT(layout_recall_done);
 DEFINE_STATEID_EVENT(layout_recall_fail);
 DEFINE_STATEID_EVENT(layout_recall_release);
 
+TRACE_DEFINE_ENUM(NFSD_FILE_HASHED);
+TRACE_DEFINE_ENUM(NFSD_FILE_PENDING);
+TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_READ);
+TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_WRITE);
+TRACE_DEFINE_ENUM(NFSD_FILE_REFERENCED);
+
 #define show_nf_flags(val)						\
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
-- 
2.35.1



