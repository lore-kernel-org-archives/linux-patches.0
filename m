Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C727703A;
	Tue, 12 Aug 2025 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026344; cv=none; b=OVfWO4M1PcuO1jpyfp6z2cuG0iYblR8AdbS/jpNTA5BYCqTuHvBzu06D/Y1ziHiNTG4QI0syhNj+1/qEX0619BodS6w38MfmMHjy23OBcBSesnjfETkZ62FB99B2B+Z/PWWV5d+JbodP14+II16cGQ3aQwClDRM23/4DnT/jdPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026344; c=relaxed/simple;
	bh=c4kVMETZEPv9ievxJn4/kIUzgcwlgqAJwOKTz9+fkZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUK3NHR8SvrM24vDU10ZJwlkMlGs7WOW64kApdP2BwE12YXlCEOurJEKJ6wNOCocdD6N5MBf02HRIl564UdCWs1D5nJOZ4tMwW2IQioDjAfCRXJpczNj6n7EePLLXT9fsLpcwq/1MbQ+ebWwLs6hA1xfxhzPhEEpawBhsKLxH80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9UC23tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9UC23tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D63C4CEF0;
	Tue, 12 Aug 2025 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026344;
	bh=c4kVMETZEPv9ievxJn4/kIUzgcwlgqAJwOKTz9+fkZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9UC23tfMvmCdqakPWidF+0Ok2NGc6BafODTEtXOux0WslleM6CPoKbIUgZ/yx2jj
	 8yb3C2eL4UnuQhzxA/cHujQsZerWDzj4z1nwe7VP3BjirB/GLgcfcEdl2sbtIRND0e
	 vhIk3AAMkdJA6CwOUpe/XZCfk/2bNmNnx2dTvx6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 310/480] perf tools: Remove libtraceevent in .gitignore
Date: Tue, 12 Aug 2025 19:48:38 +0200
Message-ID: <20250812174410.216543376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit af470fb532fc803c4c582d15b4bd394682a77a15 ]

The libtraceevent has been removed from the source tree, and .gitignore
needs to be updated as well.

Fixes: 4171925aa9f3f7bf ("tools lib traceevent: Remove libtraceevent")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250726111532.8031-1-cp0613@linux.alibaba.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 5aaf73df6700..b64302a76144 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -48,8 +48,6 @@ libbpf/
 libperf/
 libsubcmd/
 libsymbol/
-libtraceevent/
-libtraceevent_plugins/
 fixdep
 Documentation/doc.dep
 python_ext_build/
-- 
2.39.5



