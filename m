Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051363;
	b=krYeztUB9UGKUNG80D/1JMCY2kHZF/yuZMiONiEcGSUXAEh2CEeEHVbvp4F8gSrXoTtL
	 UNEhcQzk8aNzY6isw80f5MKiQWRpuVmhLFLtYxFcqt5oUd48jhJB+id5Si3yTK6x/2wHJ
	 HjxufAQpokFwfASr3fVzOddgEp1BFFJSHi0IwAjNRAuKdzwgIM/ajhTNDOe6oJEcWqLsS
	 at1lxNuKH0Nae3BJs819jrGUFLXcigELDpOmq+AAFqowTcX2kkVKKDUYmN3TIc2Ecx6zm
	 xzrBaW5oa6HbVSmwE91Pb6nMmPV/gxcM8TpolYdUl5KtoxN/2uDGXrpcRp7GMX5xMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9b35SnAiVEyglckUUCcQOfp7hZah/YyHOryVGVM5sYs=;
	b=faUq0lKEixeqnGQfgmsvGjQYpuX5Eyli0ifQYbelgOxhqnmhJ7jEoK26t7S8YLzw2wOm
	 g+5Kp+4c1NW5RekYYIURPXGOgIkDaPX6zEA54Vbtqq88tyEUxG6/v/KFxLhwQnyXnGwly
	 z6cTYmrcWjKs+Y8T9+Vz5ZijyWg4maaMWTuWQByWnoEQ8J5HjlMh8AB6YfNWyW17hsyJK
	 sWhpY+teXLZgUHQWU470w3QieIIemC7f2Wo/uBneXpiZjkCTTpyuDds+PqlNGiyBbs5eA
	 FK5iJ64CM3Z4LiqLINMLNwe7dWfdoHohgfX8Y4BEb6zPb5Jd/kWig1/rr1oxrtX+C+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A8d5v/Lk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2295606A31C;
	Thu, 19 Nov 2026 01:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8d5v/Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3031F000CA;
	Thu, 19 Nov 2026 01:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051363;
	bh=9b35SnAiVEyglckUUCcQOfp7hZah/YyHOryVGVM5sYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8d5v/LkOY/GqErpCCNe4RVgTQgZHwx7XLJqRpJVSEDv0uCj3nq7PUbGRhK1/lwz3
	 OHvK0ee2maq/sMzU2laKcDdaYSb7VpSKXmaL7NqsRwc+yfX6qxknbAiJpDGYW+oJag
	 /1t68GdzvrrsX2Jb8EE631rfP3pxhAj1rZBqyMbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0183/2214] selftests/ftrace: Force C locale in ftracetest
Date: Wed, 18 Nov 2026 15:30:59 +0100
Message-ID: <20261118150017.353423341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 55314cd197ab9..73b14345b695f 100755
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



