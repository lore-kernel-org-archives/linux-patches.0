Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057505;
	b=RNXoBOTC981EJ8DYvk2/3UkMglog9sPzn4HEA6YhPeOCLkUCg5UMdZzm7Xh4CsbLbs1t
	 SHTlL3TvYAarPl4d26eWcAzx1zWRWe38yD/JWs+RMZxCyjwN9Rkf4P1sT0ni6Y29xXyNg
	 nCoJFnZR9AdwX0NFbIHFyos2YfCnRWwycWAp4AGDAKH442SiSu61944qkZg2MBu4giPIV
	 VbapzSPMkGO6WQMsAo2c2T8c6x0M9UjufCLWPw+T15dG633rVxhhE/N4PFDduyyTNtHOw
	 M3yRD+kNDE6WVYITPl7JEn+1mcdmyMqNf2914A6EM2MnHdpVq/ZZh9OUBYHKFrRnZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j9uSmjqR2M67oZDq1RBqe1JYiXPHEepbH0K044uck1o=;
	b=C5tW1LN1mKLs/Q+Rb0rinS+6n9LRKiMmcf1i9fXe4dUd+v0K+LzsDprWwAiOv2Nvuq7Y
	 xS2vUs846KByqnIK11Z3wJqGLAC3/TD9JhLUO7+bLCPHyLZPYDbUouDeb5/W/UV5JCwO1
	 hnOENt+4ajIkLatNYJtutsW3ZrpE1ezqyEhUJNSZS3J91X/LUmQ4rpwKMpTWl7CmS+TOp
	 uGeO1O8qRoLQS+3IT2NPdRShYb5zzCh3ObBDug0L1W1JuxVUUf3M4abBN0GPxZHGxNc4H
	 nhfHvk8YwMsEAzjyoJyoUyd/rKu3YmU8s3Xezd+20wGbM5V8heUupmwC5eg4Jr5zcFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8jojZQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF860A2618;
	Thu, 19 Nov 2026 03:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8jojZQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B401F000C6;
	Thu, 19 Nov 2026 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057505;
	bh=j9uSmjqR2M67oZDq1RBqe1JYiXPHEepbH0K044uck1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8jojZQ0W9P/oHztNZeU0NDNOzxjMDF+1zdcRtsbYyYgKyP5jA6tDShmrVgIxy+ht
	 IZ5jr92eYZde2avmjLXHLVshsswxZmaMdPDsoGZ8QYmcZ/SrMIUbhUJ7VPdfi2woFk
	 0IO5T6uoIIzmc74/K4+OCF6gZfKP47NkwdMTumEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0155/1848] selftests/ftrace: Force C locale in ftracetest
Date: Wed, 18 Nov 2026 15:36:33 +0100
Message-ID: <20261118145917.847538730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



