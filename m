Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509581420B0;
	Tue, 27 Feb 2024 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042834; cv=none; b=d1HuraEeOWItQ5ynongo09eW4iGDEGe1xGnW2/1GfcDp+IzYr0/mfDvz2zLfdhVGvCW+sFNPXzGfNI0X3mK+pIRFB5AesNvZSQExxut2fP/ueRzsviccedoc7aSxAAiSqqhBGjXGU7zdLW33wqCAMbClBvZex7GiUd0behr9uTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042834; c=relaxed/simple;
	bh=83ssbvYwV3C3oN7ecZwzqNW73BFZn4eZbBpbl6s3EBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scRFQ+wValZJIhQL4K8BGYV0OuestFddj1ZSkUB/X3Sug34x4kMUfB3dP3QDV6T5gTMZa/xQH0nqopVZ5k8rwaeh04l88/6Gv62qFp3IIKd6fcfn80W5sAp5mIJ0LQvxyqX98ymYs5r2/HxnnfhIu1wv/A9GoZcCmN5XdPbc7/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckn1HX2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckn1HX2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB87C433F1;
	Tue, 27 Feb 2024 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042834;
	bh=83ssbvYwV3C3oN7ecZwzqNW73BFZn4eZbBpbl6s3EBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckn1HX2UiRRpz4egY8sLq+JvYQ7ov5kiYbSx0Rs+cSvnCp47Qq+Fsg7I/aKZaj2GG
	 0wgywQsp/Wy6bdeWzM58E3eWriJu6BN8eXJCq21Rd/y8DqxU+pxILYeLoTvEx7qD+2
	 kqhmREXuZOdl2knTXmxwW4MlgVbH31yCd9P8eDI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Florian Westphal <fw@strlen.de>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/245] perf beauty: Update copy of linux/socket.h with the kernel sources
Date: Tue, 27 Feb 2024 14:25:26 +0100
Message-ID: <20240227131619.697416306@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6da2a45e15af4f706fed211f8eb57a40cc7abfc7 ]

To pick the changes in:

  99ce45d5e7dbde39 ("mctp: Implement extended addressing")
  55c42fa7fa331f98 ("mptcp: add MPTCP_INFO getsockopt")

That don't result in any changes in the tables generated from that
header.

A table generator for setsockopt is needed, probably will be done in the
5.16 cycle.

This silences this perf build warning:

  Warning: Kernel ABI header at 'tools/perf/trace/beauty/include/linux/socket.h' differs from latest version at 'include/linux/socket.h'
  diff -u tools/perf/trace/beauty/include/linux/socket.h include/linux/socket.h

Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/trace/beauty/include/linux/socket.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index 041d6032a3489..8ef26d89ef495 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -364,6 +364,8 @@ struct ucred {
 #define SOL_KCM		281
 #define SOL_TLS		282
 #define SOL_XDP		283
+#define SOL_MPTCP	284
+#define SOL_MCTP	285
 
 /* IPX options */
 #define IPX_TYPE	1
-- 
2.43.0



