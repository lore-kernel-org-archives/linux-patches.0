Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571724CEEA;
	Sat, 12 Sep 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202954; cv=none; b=UEXflTkd6gAKrvhCJu+Z6pNqYrAPfL45e6nnXl5r1Jp7hoAJ7RSdG0KDc7PZF1RqT9Z3z4cwLtTNLwzEjFLo5dwmmTukJ8fAV8/VO7O/x7yi4PhrfsD6LXkvR0LtyRf8uaJsxCuW5JSmpQx/h7hRHx4cR4Pr3rmWvYRnnTBJhJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202954; c=relaxed/simple;
	bh=PSMW/K1EnfRdZHep+Mc5LLbJuWdr/yfVwQR5R5/Jpqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLPehCGsZERp1dux4B5NWrtAEpOFtdM3Fv+w9sbM3e+2FLKVdOqRWr+ieb22HjteXwcwpN0R4uU/0YOcmgNGyqTAeolNN5ZsJ0E5oMEEhVpL7+i8gHQIgSONhty9mxUmALtaz2uc/1OI6/9nTQU4awxHNDDUaSYi0gXoeYIv8YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kts4n5Wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kts4n5Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E21F000FF;
	Sat, 12 Sep 2026 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202952;
	bh=yFsO0UoOYXB+EhAPRAimeTHogX17dM626JrA+yh97+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kts4n5Wx6Oz4RieZSnWgjgCGO1D5KhmQt20PbtEbPeX7Wcahd94Fs8f7kIoHm2PQX
	 lQZtVmXxeERxcTzdnjS2WlNhm4qA7iwUxZ+cyY8adPNpE9UTDNFNcvG9kbpe8omSBC
	 7EnNhraAyUzFGjIRv1Mtn19Hrjv9yRK4DJsZGrTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1308/1815] xdrgen: Add XDR width macros for short integer types
Date: Sat, 12 Sep 2026 08:50:58 +0200
Message-ID: <20260912065719.724091662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit c488328375beb4e3a3ca0526919c81767ce1de95 ]

Commit ae78eb497868 ("xdrgen: Implement short (16-bit) integer
types") taught the generator to emit XDR_short and
XDR_unsigned_short in the computed maxsize macros and added the
matching encode and decode primitives to _builtins.h, but it left
the two width macros themselves undefined in _defs.h.

Define XDR_short and XDR_unsigned_short, each one XDR unit wide, to
match the width the generator's maxsize table assigns them.

Fixes: ae78eb497868 ("xdrgen: Implement short (16-bit) integer types")
Link: https://patch.msgid.link/20260712193122.116845-5-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdrgen/_defs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sunrpc/xdrgen/_defs.h b/include/linux/sunrpc/xdrgen/_defs.h
index 20c7270aa64d2..8f3776ef32295 100644
--- a/include/linux/sunrpc/xdrgen/_defs.h
+++ b/include/linux/sunrpc/xdrgen/_defs.h
@@ -25,6 +25,8 @@ typedef struct {
 
 #define XDR_void		(0)
 #define XDR_bool		(1)
+#define XDR_short		(1)
+#define XDR_unsigned_short	(1)
 #define XDR_int			(1)
 #define XDR_unsigned_int	(1)
 #define XDR_long		(1)
-- 
2.53.0



