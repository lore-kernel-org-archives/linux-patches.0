Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94467138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC33C433D2;
	Tue,  3 Jan 2023 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733712;
	bh=aqT0K3Yhg1Khi8nfpCkMU2vySz60QhXWT201+JJD1Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPZqJcHhZVeZ54LcuaQq0jDngouSU5SY3G4ug/A7flNUa4bjzTEdgCyFXyTkSigad
	 XdagqrM/HSssdS0avbwY4RJ1fJuRWB4By4XUlIrGCgM9zWhgcNxTSRSOKw+9snsTsx
	 3YvicFDs2RzoY+LOL/ZCBhqgyVfzY4T/6vWGVXHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 08/63] tools headers UAPI: Sync openat2.h with the kernel sources
Date: Tue,  3 Jan 2023 09:13:38 +0100
Message-Id: <20230103081309.064401565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1e61463cfcd0b3e7a19ba36b8a98c64ebaac5c6e ]

To pick the changes in:

  99668f618062816c ("fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED")

That don't result in any change in tooling, only silences this perf
build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/openat2.h' differs from latest version at 'include/uapi/linux/openat2.h'
  diff -u tools/include/uapi/linux/openat2.h include/uapi/linux/openat2.h

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/openat2.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/include/uapi/linux/openat2.h
+++ b/tools/include/uapi/linux/openat2.h
@@ -35,5 +35,9 @@ struct open_how {
 #define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
 					be scoped inside the dirfd
 					(similar to chroot(2)). */
+#define RESOLVE_CACHED		0x20 /* Only complete if resolution can be
+					completed through cached lookup. May
+					return -EAGAIN if that's not
+					possible. */
 
 #endif /* _UAPI_LINUX_OPENAT2_H */


