Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFE1A6186;
	Tue, 30 Jul 2024 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356290; cv=none; b=ogoj/pq4wYJ2UBd8ZiTTEO2SAF2LfHyYS7QQzsNfZJc74rLoVAY4kg95oLyqmgk0EGLWIkXsA+atdH2pp6Q5kslfDw1NU2CZwhmUwnjzxGl4JA/j8F2CQWuhAf4lWCPtJv17ZOVeDH0E+Vlg+uugw9FqakW4LnKQkYAk68Xir7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356290; c=relaxed/simple;
	bh=o9hWDKhWkJxe/AbVZbWCYgDqA4AztxMs6+woVQLvR8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw+XNr4T3meYztoxNcz8gK8zP9uDxNvpYjNp9XdRXZPPH8oIMiwH+nz7y6/CbSK7/FQvsLf1Cn6gH79L98d4+o0UEHVkxhoQcZPjmqZsDsstp435z+lQcMLC+XWW+9cxBs0UnPnU+c8tX5kLiL/tkO8MJaiJjbXrkFt556jsVaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhYYiAbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhYYiAbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55131C32782;
	Tue, 30 Jul 2024 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356289;
	bh=o9hWDKhWkJxe/AbVZbWCYgDqA4AztxMs6+woVQLvR8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhYYiAbtTIlAC5EOYLC4KN+Yfj9JaWuUbGFqtWRty2uStQwhKtf/APFI39PDs3tCY
	 DLZjdrl4cVKLIiBXTq5aHKlQJWdAyNaE+d9T/TYBobxRAzlc/CS8/uLr8N7S7C3ZeE
	 HcazMAzSkZyVZGMDJCDTcbe6uxTfC9yYUvPUOWuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/440] SUNRPC: Fixup gss_status tracepoint error output
Date: Tue, 30 Jul 2024 17:46:49 +0200
Message-ID: <20240730151622.747404939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 894d9fc8bd94a..e228a44af2915 100644
--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -54,7 +54,7 @@ TRACE_DEFINE_ENUM(GSS_S_UNSEQ_TOKEN);
 TRACE_DEFINE_ENUM(GSS_S_GAP_TOKEN);
 
 #define show_gss_status(x)						\
-	__print_flags(x, "|",						\
+	__print_symbolic(x, 						\
 		{ GSS_S_BAD_MECH, "GSS_S_BAD_MECH" },			\
 		{ GSS_S_BAD_NAME, "GSS_S_BAD_NAME" },			\
 		{ GSS_S_BAD_NAMETYPE, "GSS_S_BAD_NAMETYPE" },		\
-- 
2.43.0



