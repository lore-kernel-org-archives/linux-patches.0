Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C964F20C488;
	Tue, 29 Apr 2025 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950149; cv=none; b=g4ADbiKv37NBup7VxB7/jeI7/+SM2KE0SpfUFA6S3PUdp3iI8AQqKQsSOFmfG+DDocUdBH2eWNk+B3bF50u4fUHYS7qw0197b7xMt+C47MigSYvk9Yc+uANvSLUA43ub2gUJWAXAm8/F6CDeHPS/5GN2HaJrYY5B0QZc2nAP6K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950149; c=relaxed/simple;
	bh=o3GwYfMoqEuL3D3BkxdQkoKgz588JM95Mo3Gv7ASgvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ac/k/MB68aURl8qzsXhC7gjPoFx9XQVHffGOEuNtGlqBSXU/0CnPtqok5csk1sQoTOgTrziw82g9cTdSAnlF3Zc/wYdNrx6CCYQZDf3l6qjA/jaijxyAQiR6kgNXQuwSIi+i/de0bTtpI5kk7b4OsZm3lBUitgE6BJOArGHo1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDe9dRJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDe9dRJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D3CC4CEE3;
	Tue, 29 Apr 2025 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950149;
	bh=o3GwYfMoqEuL3D3BkxdQkoKgz588JM95Mo3Gv7ASgvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDe9dRJL/PxGnCIa7TprrbIbLBPSfDOoK5H9nyfpLS7N//SQR8s8/LxnvYVFdWID4
	 w6VTynfQFctwD55UY7n3plGn5Ax58OBeOnmZowVAsn7uHTNjfOhwOtsxN+ebIcz1it
	 LxjccKRxa2Xwc2nQSgzKzA9P4+Of+mUf4bf79Cus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 160/167] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:44:28 +0200
Message-ID: <20250429161058.200096926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -104,7 +104,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


