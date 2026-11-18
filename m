Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020561;
	b=CSJ9bEgQ6xADJw1VfawU3C1BoibAjJU/twS5QLu6c3QSa06BgMsXzIuBHCKgf1dsUtCo
	 UHhXinkXNGBOoRmR0x9Q+ZhhWbH1smhzYW2OwMN07kw84fq19R60u3WHAVdMwgAhvXf7l
	 mvCe64yObEAbRswXpDxWUBeFP1FVoO/x7/Y/WhpBCVggQqWP8RSqd5Q/Uy5i78Kxq2JJe
	 YQwjeXmO3Ua3VhD8l1MnSZPcd5KM/0o6WUJ1QvA9V2AX7k/Ll1dZ0UtsIO+7XXzuvH/Eh
	 9HC9bms0b7metGFCLt8aoCBVO1rI2efP+fjifdJUnFs4R+hctTEVvUWsLM0vCh2jWgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0Yuz8ViZmwLrAjAsnW4gY4ToP+8Q01vc5UaaOOYZps=;
	b=CX5AE7dN7ISoD3Z2ebWBNAPjfxPOcerEnQUwHaS5762eXgGYdvirgO9fvGNUwAaMjE4o
	 4s1LTvqCEZhaF06JqT9bV5ICSTCO76kydrOEokQ7QrnomOs3vZpBWFYS9pxVjmc+Q8GW9
	 hi8lQLHECdb7JQXm7d9brGxQZEI5U4miJqhg827MiL6R4mOkb+yp2ka4wKHQmlSHcgcqt
	 0nud02mOwwnMrWhemAAfq/ZEM/RPJFl2O5+Krw30WCE9AKBPDMXv4hmq8mN19PSCcmy2/
	 0yJwgWm8+Qkw2mXuRNxNdrsFFggoyFWTUMblCjd+Iv/NVNp1bQQVyY88hnkaF0Kryxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gezYdcGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34B3606A31C;
	Wed, 18 Nov 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gezYdcGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04FE1F000C4;
	Wed, 18 Nov 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020561;
	bh=z0Yuz8ViZmwLrAjAsnW4gY4ToP+8Q01vc5UaaOOYZps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gezYdcGgXpEeE3xfwOaYmVICV9HwrdhPRcRvS+kQtB2cGoNL7iacTZ0DBLjclK72e
	 qtEK5LkYd07FhVqb60Uk/80EZbc+OEXx8CigaBAs5aJmHgkm94/JBCBH+pqhjcmNZE
	 3mvuTkrWptSANNLkCjuOQtWMYNWYpjm73F8K9j3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1968/2651] selftests/ftrace: Avoid unlink error on first run
Date: Wed, 18 Nov 2026 15:53:28 +0100
Message-ID: <20261118150357.331749408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewon Jung <jaewon8868@gmail.com>

[ Upstream commit 0abfa9ad5c6917cb9a509276f32009d944b3c269 ]

On the first run, ftracetest tries to unlink a symlink that does not
exist.
Use rm -f to avoid the "No such file or directory" error.

Link: https://lore.kernel.org/r/20261014114839.6258-1-jaewon8868@gmail.com
Fixes: 7dc1e125f07a ("ftrace/selftests: Add softlink to latest log directory")
Signed-off-by: Jaewon Jung <jaewon8868@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 246d7e1d015cf..95804610e079d 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -243,7 +243,7 @@ else
   mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
   date > $LOG_FILE
   if [ "x-$LINK_PTR" != "x-" ]; then
-    unlink $LINK_PTR
+    rm -f $LINK_PTR
     ln -fs $LOG_DATE $LINK_PTR
   fi
 fi
-- 
2.53.0



