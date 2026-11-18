Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043428;
	b=1EPze+KTiacK92HJH00sVA1gUsWdoDvdU1Wkgx1+fOZtl+Xm/O/h44Z6hEiSQJ05THJu
	 rTPA2VKZvT6YF9Qdy8WCyqgCuAxz7zljUduwCcPAmnlqBc/xMj0w1EuAJDN12k+QRvZ12
	 FvV+3s8AQvT4cKvtVVQkHZz4zBO2/34OssCvnLQBMIobrrkv+M8PIqKznSjsAM8AG4ykT
	 F5p7eAT96j8FROKwYhjfnrtmtRYeveEhJjr3Lx5qG73UsYnjYzRdcm4rXm28aQmfrTdVi
	 A2MIrGZItqkF1DSI+eUW16MYEr5cFmTjLJUUoWIYSnNXyOiCHCS34ZmNMeqGKCVHFZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=subRKZ8WdGlznZOXydk0MKPABkNv2MrJ4eL5GwtuqBo=;
	b=i5nrP/g5QKKxXvmtxbBtr7IRIHbJ0/Mb3YYN3eoRP7ujWI+nC40hgB8vUFT2JW4h7a5b
	 I17OkW17ZSDTWG8Kpdj7irlmi6yVxYzFPxutw8nyVzVaP+FdQBPyTftbzF3r8er/gRyM9
	 7dheUcFWWErMXm+II7JXyQooKLxyvz2HXCvbvqWTccWqOPxdvv5K4ZBFKuHzxz7Mf05iR
	 7ofVxO2QbgI8xGYdtIBsq2Hv9LeaVlitgx22SOUT6ObYU0PPSPpjbdvpW5j9aazE7RupO
	 6CrojZSQOOoaJq2YNsMZNF7rOe/EnZuHzfDYMbB2ZE6y7OzhQy+kj65oKfNYnbi2ZCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTnU9tzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3164C606A976;
	Wed, 18 Nov 2026 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTnU9tzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DF61F000C4;
	Wed, 18 Nov 2026 23:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043428;
	bh=subRKZ8WdGlznZOXydk0MKPABkNv2MrJ4eL5GwtuqBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTnU9tzW+JFscsRWBJ1bKhJ8B27Kpp8Y/jkkyfXNfLsS+axOi7TP6Zqevn296r/sQ
	 L7+i2PTfGA9HaKmbmKMI253D/gaFAawZoDWgkuksMFRZ5tBZNeY9Hr7t5XWiXSKLLX
	 I0eFS+961fQPMP0E6L/hZukhGc+sKalc/T+yiSG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0208/2857] selftests/ftrace: Force C locale in ftracetest
Date: Wed, 18 Nov 2026 15:20:42 +0100
Message-ID: <20261118150208.847305851@linuxfoundation.org>
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
index ef0edb7a71e37..e97a18deba3d9 100755
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



