Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F61C18801A;
	Tue, 30 Jul 2024 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358621; cv=none; b=UCteH7gNpppsXrGFdJ156+wZeoPsoDoEiPsPt/l3YkQVCGigfrpVjZG3Iq23bbZQk70mCAE2gRRZgXafulIWJKvMKeGXr+qwRBbYJktHeXT2cIpH52fEaI48tXhtAKsHQhKkfXf22xjO6nJttTBqsCBJ9A2iZJus1D/C9nkW8Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358621; c=relaxed/simple;
	bh=rLjjdjMtDr+X1OtNlleN0C/mGNxe+ocjBIZSiCX4RqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUKlBhJ6jPM0B7sZA94qjTyZo68XigSaofs96zP7DbzIQnH7TwOeO0AlH8dOOw/BT0hZ488dkFvNxtU89aLF+d8NDq7SjVFHuLmNKXDwJoGqBbbD5+XRC67or3gvNI3pOriNBCF3/qjTEG6951uMmQkBULhRxdALo4vTT72Tw9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYvEd626; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYvEd626"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79773C32782;
	Tue, 30 Jul 2024 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358621;
	bh=rLjjdjMtDr+X1OtNlleN0C/mGNxe+ocjBIZSiCX4RqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYvEd626o0GQN3SCtFhAKv/xC0BCV8HEVxTxOeAS2Co5upVnnBcpEsMngt4bu1c3r
	 NfMumtoZTsuyoaxvkAm4V/EF+VlX3kKpwJr+fObG3p7O3A948sYXMwEO25x7t3CzUk
	 FIp8HaJkrYhIzdlJnjgvKwky9nrxHoeIYtjTdeO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 379/809] SUNRPC: Fixup gss_status tracepoint error output
Date: Tue, 30 Jul 2024 17:44:15 +0200
Message-ID: <20240730151739.633826120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f0c1ceae726b..b0b6300a0cabd 100644
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



