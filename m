Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E4F227E95;
	Tue, 29 Apr 2025 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948433; cv=none; b=Kh5/7Egp+09sbSBQTgIqrmJ18z0xREOH6zaZZ6kzPqi1zkUQ//2lbD+aB++zVNF5FlPCnBf+DsPxi3yu9VOtGjDUuNYzeYcYE3xOYLySoi/5KgUk9eWirlmtZnkwU4uK/inz32qskwMMFDG8v9iNCF/fVfnpUb4iUHpjDqjAKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948433; c=relaxed/simple;
	bh=RRrprCwxF8GRnjKhD9csKnWYuOUb93lNsHau9O2PS4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6ahVHfbiuCkit+SGsJ/hMSIUIWIQK3yVfiGbRQnAsg2otpVds19iavOSw9uVB+0ZfB5DlYiVv7L6EDsKnP4D/Q12/ctZLkkZQAH0FpdSnDTxAdH63NfGXQKns0Udw4yb6MD9/PIuuJ85DGKzYAJsHrFGLurKMxv/CUH33PPXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+T2qJM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+T2qJM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63010C4CEE3;
	Tue, 29 Apr 2025 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948432;
	bh=RRrprCwxF8GRnjKhD9csKnWYuOUb93lNsHau9O2PS4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+T2qJM8YSKhE+Kuj3EaqlDzZHybTdFgYBorluNUCvhFo/IaGiopLuoay1bk3KfMS
	 vglftJfgL57yPs9XKOKZljk8YjRwcHbLUiWs6Gz+iB0U+7INpgXljPxpxP3hMJcNfp
	 0foW0mYELIvgNL5EphPyyn0SAkDwL6NAKcHr1Tv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 272/280] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:43:33 +0200
Message-ID: <20250429161126.264624775@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,7 +116,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


