Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA263C;
	Thu, 15 Aug 2024 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732166; cv=none; b=LJNjqywR4rmpUe3kpFbzoXaoqaCHaXgRZlXRnuPaC39GjhyMBeqNusgXATvrFihy8Nt7TMWTm7vDwUhgYWAqNcQZmaqbp0wycJKgajYXdpQ9FGn4zcQS2FIldIqt9gYTsscI/Ye9tEhSLOqt+3QUaKo+ceJIbjsg+B8MBzp6HLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732166; c=relaxed/simple;
	bh=93qe8ECe+57yJOXKp4engFWzpk6JIbA1WB2Q0IL0Xmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh647s1XpiMFsBpYfxT5L53xS5fmeOHc8KRAvruvujkf8kM8VThhWBfzfuiB/Z5UP1tqvWEKghy//Pzn/iz8AFvTCJARJYjltp/qjsNEoi5HEJbBKt+lyCtsSW2j4pCcaGJMJnlvF8xn5MJfiGjkLoPYfZ91GaUb6rbhNZh+rIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQAeYtFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQAeYtFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED12C32786;
	Thu, 15 Aug 2024 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732165;
	bh=93qe8ECe+57yJOXKp4engFWzpk6JIbA1WB2Q0IL0Xmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQAeYtFZBpcIYWPuU7zBNt5whMBVdEOg9UIQu3eOSdYNMLA7FIi7UAsOHKwgDZz0/
	 D1qrWwaqPICbaWdqJnR+zoAcurFPcAP/q86MrIhkx9ntNpwP9oV3TqzjnGRGlOUbZ7
	 +OyGyKyTD/3bhuVBzkgGQ8JDFb7ioZpIckUQ4/sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/352] SUNRPC: Fixup gss_status tracepoint error output
Date: Thu, 15 Aug 2024 15:22:41 +0200
Message-ID: <20240815131922.932348999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit b9fae9f06d84ffab0f3f9118f3a96bbcdc528bf6 ]

The GSS routine errors are values, not flags.

Fixes: 0c77668ddb4e ("SUNRPC: Introduce trace points in rpc_auth_gss.ko")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcgss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/rpcgss.h b/include/trace/events/rpcgss.h
index ffdbe6f85da8b..9c8cb69c79112 100644
--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -52,7 +52,7 @@ TRACE_DEFINE_ENUM(GSS_S_UNSEQ_TOKEN);
 TRACE_DEFINE_ENUM(GSS_S_GAP_TOKEN);
 
 #define show_gss_status(x)						\
-	__print_flags(x, "|",						\
+	__print_symbolic(x, 						\
 		{ GSS_S_BAD_MECH, "GSS_S_BAD_MECH" },			\
 		{ GSS_S_BAD_NAME, "GSS_S_BAD_NAME" },			\
 		{ GSS_S_BAD_NAMETYPE, "GSS_S_BAD_NAMETYPE" },		\
-- 
2.43.0



