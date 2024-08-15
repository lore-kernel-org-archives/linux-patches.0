Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881711714A1;
	Thu, 15 Aug 2024 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729507; cv=none; b=hv0rXkBvtJV69xIHnwRA2SEAYS8zd4BCWMdWe0p5HF/npd4YY6iBBsMniQSN+l2NQZsXkJmTBicRDyadoy934craKh2HH6XZDADwhc4FGbKs5BQQKqh1iYcAZttZYgRwTzVz3l7lvehp6yd9RpgrGWifKMEYDU55QHkC7K4cu8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729507; c=relaxed/simple;
	bh=wA9LAUyazRkv1ikeqQhvfab6miUKHs3WmBZBdXD4AVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdGVLx1OAwyJyhTJPHWAbjYCg/D48aVp3iOhxqBUIdprUSeQ2pM/hdQGZe0wmtRvEbPgq6kEZbY0pl4903mWyNuJy6VL+BIyx2lrwXsCaROKbS9pdPE93m0bTEhRxFSz/I/YMra80FhndjkYTh0POIcuT8/yhWTG7RmK+THEVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSWBvaHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSWBvaHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7BC32786;
	Thu, 15 Aug 2024 13:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729507;
	bh=wA9LAUyazRkv1ikeqQhvfab6miUKHs3WmBZBdXD4AVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSWBvaHjLMlGBHbsKn5TZgaCkE0RNClmu5P/dZlew7SfQ9u8Hu13cUfvXgcNPTkKQ
	 2tknRAYy0E/4hmFpsOzYtKkj+FrLxBgvSSlxSaI/iH2VSqNBRiAf6D0BHVgYbEovMH
	 kPFcy7kH3M4Zo28tt7jGK/IbMA8B5jIiYs+oooQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/484] SUNRPC: Fixup gss_status tracepoint error output
Date: Thu, 15 Aug 2024 15:19:37 +0200
Message-ID: <20240815131945.889587633@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6959255ccfa98..3e4f767fbfc12 100644
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



