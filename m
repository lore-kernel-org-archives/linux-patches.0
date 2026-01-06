Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A7833C1B4;
	Tue,  6 Jan 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720101; cv=none; b=JCfrTS05JMLfyGISJsreCOY9Wa7Lmhg9MVbxbph5jh0Rs8f8bgv9sSgYhavhP1Q9r0wJAf89pwElQbMRVfsaD/aRREK3dXAd1geg4Vr6rAHvOSa+tlzPTjHfLkuPmVOI+BqJFISeWPrAJ06krzwsyJyRwg43fE9jWZd5R7P7K3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720101; c=relaxed/simple;
	bh=1lJrMDLKUCGzKMaXoO5LNcKLPhfrqmMhhAiiOg023HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohe1MTZCUmsZNw0kE99zsZ/wjVlEO+9p+qlO1uy2714V9kbSQODVz5ZmywwdKZI273NkTXr+a2cR7sPPdhchphCpf3q3+7q1JvyXHJ3kgEE8j3L8LufK2gTjseOk0136DYlgky7z7BHoHYGayw70QpDTH1lGmi67kCiphM7PQf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlFyYgla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlFyYgla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A6C16AAE;
	Tue,  6 Jan 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720101;
	bh=1lJrMDLKUCGzKMaXoO5LNcKLPhfrqmMhhAiiOg023HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlFyYgla4L9qA2ldzXH1GUUU4zIgyOo4Bjr3VzhTW5mc5vUD4JcD7XxN2xPr+VWva
	 6S0XyOSW0O/q6Jbs9IhsbwAtdfKpkm3rGfp/fbgoSKtvyvv7LgpPhwCSDUyX8zSU/v
	 jwGqdui3ODHEeohm8/LK4ZsMjtY6jKeXf7wQrNeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/567] reset: fix BIT macro reference
Date: Tue,  6 Jan 2026 17:58:35 +0100
Message-ID: <20260106170456.247233892@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Encrow Thorne <jyc0019@gmail.com>

[ Upstream commit f3d8b64ee46c9b4b0b82b1a4642027728bac95b8 ]

RESET_CONTROL_FLAGS_BIT_* macros use BIT(), but reset.h does not
include bits.h. This causes compilation errors when including
reset.h standalone.

Include bits.h to make reset.h self-contained.

Suggested-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Encrow Thorne <jyc0019@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/reset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 514ddf003efc..4b31d683776e 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_RESET_H_
 #define _LINUX_RESET_H_
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/types.h>
-- 
2.51.0



