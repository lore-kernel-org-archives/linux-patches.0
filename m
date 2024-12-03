Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BCE1F892F;
	Tue,  3 Dec 2024 15:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240770; cv=none; b=JaOGUFwwAhG5XB7dH+z+25POMnyMMN8sRp+Z0i2Tmd4By+I4DrsaQbx0DYRRW598jhTjX5IzAv5diQuHtVmKalxVp+hFm2HyOwS5PautJWMUgNET+F1gRMo1oJgD0Oi/f6z9mXu+z1CCmTd/gCOVYYwTvU6MOQGn+6OadY+kJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240770; c=relaxed/simple;
	bh=VTa7pHK/z8UsWSe0EiFZRNsSrOcZYPVRqHsayf6hKys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCxZ8r4u6wsx/q46NGoG9nK3xUUUeTP4xRmhV+98Yv6qj05CetiGiu58YvnZ2yzZ25tMecFSqc66PfKU9UjQM8tGMNPWTehhCStbIpeW6pWCS2tQU0yXTcCCPzZGrlSLVykauHV85bj2aZ8PKummHXP0z9/e0lS9/eqsh/tc0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWaYPjwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWaYPjwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2714C4CED6;
	Tue,  3 Dec 2024 15:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240769;
	bh=VTa7pHK/z8UsWSe0EiFZRNsSrOcZYPVRqHsayf6hKys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWaYPjwlJBAuRIp4FRKoMTvzZUBQHwD+vGpvpUeVnf2RuhccUawjSO/ZYyCdYZ742
	 ahgUf0NevsKqZQJdc2v6pPrH3ZSufnyVR3pdolXZoXLbEZJ03pOmlr2e64ig9OpAqy
	 p37BkcjvYMK0UncrlYRZOhqjN1tWXqJUSTb4gSh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/826] libbpf: Add missing per-arch include path
Date: Tue,  3 Dec 2024 15:39:16 +0100
Message-ID: <20241203144752.678556507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 710fbca820c721cdd60fa8c5bbe9deb4c0788aae ]

libbpf does not include the per-arch tools include path, e.g.
tools/arch/riscv/include. Some architectures depend those files to
build properly.

Include tools/arch/$(SUBARCH)/include in the libbpf build.

Fixes: 6d74d178fe6e ("tools: Add riscv barrier implementation")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240927131355.350918-1-bjorn@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 1b22f0f372880..857a5f7b413d6 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -61,7 +61,8 @@ ifndef VERBOSE
 endif
 
 INCLUDES = -I$(or $(OUTPUT),.) \
-	   -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
+	   -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi \
+	   -I$(srctree)/tools/arch/$(SRCARCH)/include
 
 export prefix libdir src obj
 
-- 
2.43.0



