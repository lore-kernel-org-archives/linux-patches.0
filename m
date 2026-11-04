Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830838;
	b=xZVN3tkJQf8aCsnU/WzZOxxV2AMxT5Oi8hEIL121j42xJgezruG4S7MfoY+2ClbdRMTp
	 iU3qsC+eOQEUyJ80B6lUCvrKYXTGxCBbEuW7+Ko36xGD5MxVMTv6p1zhD0f51SSVZjFt2
	 hBhf/RuHGVccWOaENbpv62WiiZxXfS33C5XvNs1tvhLF/cIG6S1+9DYeItE0NsA5Ij7fF
	 4gMDXr7u5EMxCRNeZ2R2eN4C4KJge5yQ047sToTL/PCZ5O/QCaPEjpt2DgwfeJ/NNcDYC
	 140yzl2Iblmmc7Zx/MrdVNI79NKFVBj5UEmig3uZ9JP5cVlAtf2eoVxFnCajP1OEjRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B8K1QRzc18IFd46idDleoGRxlEJecHJgX9Ic0CnrXZ0=;
	b=ORqSraLOlj1pwsqM9oc7FrYOabT3jcxU8EApgodLj37+C7MJ9trBGlrQX7ncAE1zkw0/
	 xfTpiK7VGgGVy3TZ4IVtsQCQwHcOR67gxe0qthrW+nLaU5qHFJ2WCm+hQxKhorg0h+FUR
	 l1QOZXp4rOq7V9HVqe5Q0KXovlAQ9FmVIefphTvDnX1xYI/e6hFyWT1CIGtSIWzInx5up
	 pIzr2UeMfvEf49LbGOzUWconvQjQhij5jDhszgc/T4BrRWrBdMrMHDwtn0bnUlpoh2daf
	 r3xLr1F6LI3WMhG6SxkzPL+lrgq68IRZmZ4bzkNu3pwX84ryE5QmOAtMc2CXIW1+SIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoWaSkqH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3798606CA0F;
	Wed,  4 Nov 2026 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoWaSkqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7551F00919;
	Wed,  4 Nov 2026 22:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830837;
	bh=B8K1QRzc18IFd46idDleoGRxlEJecHJgX9Ic0CnrXZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UoWaSkqHjnFlotnVFpBqPiOr5m3iA7abUpi5JpynFq7aLYmo1GFgqJIwVB0DcYOB5
	 E4tqEixX6OmhiV3xY+i52EfnbIWh615vAnrFtZyNS0GZ2IjvE62xWtbMs1HmXGwFTv
	 JDISRExlbappf3MekcIb0ulawmTrSORjBDPEqyMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0344/1005] selftests/ftrace: Force C locale in ftracetest
Date: Wed,  4 Nov 2026 16:01:17 -0500
Message-ID: <20261104211053.602459230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit c13fcd3951dcc19524ce0b3e852844b16cd32b22 ]

Some ftracetest test cases parse command output by matching English
field names. Tools such as readelf may localize their output via
gettext, while ftracetest currently inherits the user locale from
the environment.

If a translated field name is printed, parsing can fail even though
the tested kernel behavior is unchanged. For example, add_remove_uprobe
can fail to find the ELF entry point and then write a uprobe event with
a missing offset.

Export LC_ALL=C in the top-level ftracetest runner so every test case
gets stable command output by default.

Link: https://lore.kernel.org/all/20260807081512.2974757-2-qirui.001@bytedance.com/

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index cce72f8b03dce..ee3b950e872f6 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -7,6 +7,9 @@
 #  Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
 #
 
+# Keep command output parsing stable regardless of the user's locale.
+export LC_ALL=C
+
 usage() { # errno [message]
 [ ! -z "$2" ] && echo $2
 echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
-- 
2.53.0



