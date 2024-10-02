Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753D1D0427;
	Wed,  2 Oct 2024 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877239; cv=none; b=oBBua6F5+kXHV4V2DigmfzjqffXfpz5873S0Jm5jGK+OdugRWoggGy4CNj/eWJUpv75RGK0GDhzSCeZX0BlzEwxI+fJLiPX89wGz0qiXChSkhrsydx4GGThHlQzpOuS803OvT6ZcGrMbjZnvzDYW88f3Elt5u6iKeqB7jfWQ6RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877239; c=relaxed/simple;
	bh=9AYE9t14z+6fLBb1CGHuHvTuHGEE+RiHw1DEXRwnR6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbMABAbL5mOwfGNIV8kLOJOHzUJirtGqqpgCOtRbQIGJsNZtvHcriF/swKhzPyCZodNqMMNOGWkBiogb8rD0Qy2n2TBNUJXKACcVJlvCbciCXSLiwjsx7DnEaLEqqA8kMReh1QaEnX2hI7YHwW+p68GtUpJB7H4YnVYqyMMeD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAjp+IO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAjp+IO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C18C4CEC5;
	Wed,  2 Oct 2024 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877239;
	bh=9AYE9t14z+6fLBb1CGHuHvTuHGEE+RiHw1DEXRwnR6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAjp+IO2SAojUtuhALT/M5y8u+PuA5F73ww8ErsS38jnb+zvGyvfQbI6XWDTJabio
	 p8PqSwLHlrcydtonInb3sqwGJLKAogA6Hme0TOPayw7TGc3wb7kSefk4xqSNd8zX3r
	 CyAqfdtwXJ0v9/Ky1jF3ufsUZo3zknZHMbc/GHnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Martin <Dave.Martin@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/634] arm64: signal: Fix some under-bracketed UAPI macros
Date: Wed,  2 Oct 2024 14:51:56 +0200
Message-ID: <20241002125811.735025110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Dave Martin <Dave.Martin@arm.com>

[ Upstream commit fc2220c9b15828319b09384e68399b4afc6276d9 ]

A few SME-related sigcontext UAPI macros leave an argument
unprotected from misparsing during macro expansion.

Add parentheses around references to macro arguments where
appropriate.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Fixes: ee072cf70804 ("arm64/sme: Implement signal handling for ZT")
Fixes: 39782210eb7e ("arm64/sme: Implement ZA signal handling")
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240729152005.289844-1-Dave.Martin@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/uapi/asm/sigcontext.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
index 8a45b7a411e04..57f76d82077ea 100644
--- a/arch/arm64/include/uapi/asm/sigcontext.h
+++ b/arch/arm64/include/uapi/asm/sigcontext.h
@@ -320,10 +320,10 @@ struct zt_context {
 	((sizeof(struct za_context) + (__SVE_VQ_BYTES - 1))	\
 		/ __SVE_VQ_BYTES * __SVE_VQ_BYTES)
 
-#define ZA_SIG_REGS_SIZE(vq) ((vq * __SVE_VQ_BYTES) * (vq * __SVE_VQ_BYTES))
+#define ZA_SIG_REGS_SIZE(vq) (((vq) * __SVE_VQ_BYTES) * ((vq) * __SVE_VQ_BYTES))
 
 #define ZA_SIG_ZAV_OFFSET(vq, n) (ZA_SIG_REGS_OFFSET + \
-				  (SVE_SIG_ZREG_SIZE(vq) * n))
+				  (SVE_SIG_ZREG_SIZE(vq) * (n)))
 
 #define ZA_SIG_CONTEXT_SIZE(vq) \
 		(ZA_SIG_REGS_OFFSET + ZA_SIG_REGS_SIZE(vq))
@@ -334,7 +334,7 @@ struct zt_context {
 
 #define ZT_SIG_REGS_OFFSET sizeof(struct zt_context)
 
-#define ZT_SIG_REGS_SIZE(n) (ZT_SIG_REG_BYTES * n)
+#define ZT_SIG_REGS_SIZE(n) (ZT_SIG_REG_BYTES * (n))
 
 #define ZT_SIG_CONTEXT_SIZE(n) \
 	(sizeof(struct zt_context) + ZT_SIG_REGS_SIZE(n))
-- 
2.43.0



