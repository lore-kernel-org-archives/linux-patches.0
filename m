Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027041;
	b=5gfDQkQz8V5FXAFWR0BwCODtjlE7xKYsBkl2+GS9SGLZQCsuTZ6yL2XKbyc2kOQdWfms
	 G0A0dUg5Bbfu3ix5F1uUuWO4mrojV1Ypt6UHB+DU7PVGEUaDX8Bb7V5B+CQ7I8We3HLgX
	 DMpmyP6wa4vCYrPK2N3043h3tHCBcFgjPP2RMgdqmJBkfhIp8y+fxHvCOQAdGDFChrCbe
	 UZeSmkE4PTq6dtwqERSyHeuRz65IyS5V35dVRIKL3Qp37VFcXsTamkjLID61CdKf+ok1h
	 iU+6ZK0qPnurRV/S/S2TXuPGhXr9YxY5l0Y45ZOnG5xG5OBhOjgnXGD0XoWxtNy7mIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pRrGNVwtnuXCalk370KJRAkfBVCXY4KRyQgun9+e5Ss=;
	b=15g6rwEvtI3gLIlFhrbpGoQ3dhcqSD3RAcRnYKdEPufD9bsoo5lAJAKU6upNoJEFkNh2
	 n5/1wKel3IXTLmvd2eIKkwF4LsKvljezmzuHCjR+5azwR1IdpJL3gSaPsJqVUY7lmrwwd
	 wkE63I8YqhwffsELbVbTYL7AjIpHvm0mzJDWA5eCevHhWV86dSRl+3fUAthowwzaI0hYo
	 B9QujCXWnQlaNvxknf2qqMXTWCfPTw6LvnIgtWIh3eBIvyeUojItVUS8ixEZX4wQ0OfNf
	 ldg/txlRlmnjU5eDyWewHP7d0jDMJpaREY2aSmWAHu3tg7ip+7aYfGwP/plSMdLRfNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoElw6GU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FEE606A337;
	Wed, 18 Nov 2026 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoElw6GU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DE41F000C4;
	Wed, 18 Nov 2026 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027041;
	bh=pRrGNVwtnuXCalk370KJRAkfBVCXY4KRyQgun9+e5Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoElw6GU6LkDorVEBDsyntane7FyQP0uz/RYihycKKLm9HGyma6xVSyHRh95zewWk
	 9jCQe6+jwiVLTFx2mWxv+xJEw+mNtnG7LHDq45KTlYEeCTSr5A+d/dgEXVW7D+0GxY
	 yCfQDZHXLIjUTpEB4Wh2GJKn8q9BcUwS7TSLfAW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1607/2151] selftests/ftrace: Avoid unlink error on first run
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150220.406753064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



