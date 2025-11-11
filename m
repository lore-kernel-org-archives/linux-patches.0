Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0133446DE;
	Tue, 11 Nov 2025 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823618; cv=none; b=ZV5on8NGl2KMmOYHVKgqmKCvyHS3SBTQtrK5oaVbOfUASEoolI2aFcGb7i+qGoHDe3pskVH5aQp+GCW6x575e+caGy4xzheZvwiR2UZaWSThj0ubLE6EG8i/bJ2UaSoLpJRK+9YErnvrqj+KssK+5wdPgYBPb2/nslJ2a5BIdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823618; c=relaxed/simple;
	bh=na8uSJiSgUd2+awJe4dibEW3+zzhjO7a3jAmAVjK4as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxx7u5+q59iYK6DKMVc+HA35GBuhi7OzH5h3xn8GfHYkh9pBlgnxpfZ8rV8oxTiqJWCMhIocVPn1C2LeN1iv/k95XEXvwbgFBb28cPbRaEO1HhB1VYFjE5FKCVIdyEAl315uXy+iIJ8JgaUNInUhZaWo41mr0zUZfKLroUIHZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfPDr4xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfPDr4xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B126FC16AAE;
	Tue, 11 Nov 2025 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823618;
	bh=na8uSJiSgUd2+awJe4dibEW3+zzhjO7a3jAmAVjK4as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfPDr4xwEUswYVl7JmqBOyz+aMZtlc3rNFCl8lIlEbjZ10ZsVPrIWgiu6aG/YIGQH
	 uc2MVbd0psRE81JIeOaCSEPffFrk2wXJuItz7OYq17aU3CUNo1SFX+d1DWWei+3cwC
	 ynr+6lUqri+cFF4Wql74dExcBSVvj6S6rSeSSuFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/565] drm/xe/guc: Increase GuC crash dump buffer size
Date: Tue, 11 Nov 2025 09:42:23 +0900
Message-ID: <20251111004533.334178155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit ad83b1da5b786ee2d245e41ce55cb1c71fed7c22 ]

There are platforms already have a maximum dump size of 12KB, to avoid
data truncating, increase GuC crash dump buffer size to 16KB.

Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250829160427.1245732-1-zhanjun.dong@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_log.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_log.h b/drivers/gpu/drm/xe/xe_guc_log.h
index 2d25ab28b4b3a..1c673c2fbd567 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.h
+++ b/drivers/gpu/drm/xe/xe_guc_log.h
@@ -15,7 +15,7 @@ struct drm_printer;
 #define DEBUG_BUFFER_SIZE       SZ_8M
 #define CAPTURE_BUFFER_SIZE     SZ_2M
 #else
-#define CRASH_BUFFER_SIZE	SZ_8K
+#define CRASH_BUFFER_SIZE	SZ_16K
 #define DEBUG_BUFFER_SIZE	SZ_64K
 #define CAPTURE_BUFFER_SIZE	SZ_16K
 #endif
-- 
2.51.0



