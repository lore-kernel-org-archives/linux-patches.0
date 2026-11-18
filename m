Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032068;
	b=bjNEYnqkBE3yZ/rYcTUzkUFTodFTu1vE3a7g8J/cCGLnSo6MMwsUxAE9sSeMdOMa1tlS
	 Sr6RXa3ACRrV4Y5jrrhzNrFX6ZoBroAMIsczIOv1+XPRMzD0PQ8hSNUBfYE+cFvvG8zmz
	 n1DSYYP6Y4aZ5LLxpvjlo06YkKM2PRXYFDicsgbhuAaU4dyTwQFt9hVxfB6DqiES8qHq5
	 s4/07xgpA4MkT3GnjsWEaMa69Ue8SOHZS2gAN79UMJiTc8G0KRe4iBudz0zrimHEXp6AU
	 /kJqB50LtreZrDznwdZDorGS3QNXG9WqKuJw1AITRBB5Ylu9pr7O7H0bxNGbLsBJVtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2jO45uUUHcmrjgbz9mTB8fUUFADX56Hupieduf9TWj4=;
	b=OhW86OcSeWyTjmX8/S//Y2+5Ry6QyKz/7hcU7hgiZ2+od3fDBdLa5vka6A+ITOW5Vo+Z
	 Z1XXnsCmLFIrsZen2lOl6uek8rUVu83H+nsI75ZA85l2A/AUjl6gtiKj/J3FbsMnO7y29
	 I3p26RrF6ma/V1T7aCrSXJBGJ95vXDvtbA4SY32rXWqHFRc5dI94S24OMjjXguVAO2QVh
	 DXElpIL6dBYEkKlF8M9Hvv4D2nqd04p4ZDxg4zwsF1EbSEKeXiAUK8P9iVp5xlHQIvX2K
	 3NO/Z65GQu3uZN9GyeMXntIKPDBu0ibDHZ3DWq+QU5p1CWUE+wzYfcVDk8RAMqEdF+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bBMVO/Cj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC413606A334;
	Wed, 18 Nov 2026 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBMVO/Cj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8B51F000C4;
	Wed, 18 Nov 2026 20:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032068;
	bh=2jO45uUUHcmrjgbz9mTB8fUUFADX56Hupieduf9TWj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBMVO/CjI+MSbJMwt4pTu01z/owLqR6xXwRvViFMzPeBR7y8QVrjZTmlYj2AbW59G
	 vqH7koje+VwW8QF3/10GUT1ebWzmx0d67qXg5iIaaoce1egDvHAb65aZD8Y4zcuFlD
	 uaQcjBfBt6ksdLgGGvsYrnTrLTBabY+Gd1ZwYoj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1279/1756] selftests/ftrace: Avoid unlink error on first run
Date: Wed, 18 Nov 2026 15:56:46 +0100
Message-ID: <20261118150100.496100297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ee3b950e872f6..09b01044be600 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -223,7 +223,7 @@ else
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



