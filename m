Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497FD79FD;
	Thu, 11 Apr 2024 10:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832020; cv=none; b=RwAR93Lkcj1J4owdvtqFp7Yq7JjrF+1faBVBBYMEWt9B1t+HDooIn1WHcPLkxwaCNP6EZ1QKLOrf1+N7ziw9kVKiXYfMpAlnIh119XgGdrzAFyR4TQ59xUmMRf/RaBhhqvF5LkR97CsuWvi4n0byxsyzDSqRV61yhZ6YluehgQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832020; c=relaxed/simple;
	bh=zatITTH7SlHF4vFRn8XYShOPzODiubIgSYTz2JTJbp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLxEJyQiRxpqcPrCL2I9c+guw/49Cm0TgAoHiu+/6tAxWKxZMX523YbC4DAeXksM/3DISpAoMFlzZ3vW9saLIkAV8mqF8VTJSuNb8PJ4jEKWyQnqNKMP/7JWOZOTVxY5whh9i6n3mD31iIiCiNMQpFiBikGeUsJ9HaLeLuXhbH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZwynZDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZwynZDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF67AC433F1;
	Thu, 11 Apr 2024 10:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832020;
	bh=zatITTH7SlHF4vFRn8XYShOPzODiubIgSYTz2JTJbp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZwynZDbEZaSpMXlRtGeHm1jShLhVAp+nRur8I4X2VRrL1YexqUqE8vBVJYudVuRE
	 e6QdZcRC4oTNDD5XU0bjDwifbucWc5mhMwxHz0bYB9bxpkk7Wez6nOaHVsbaNVjy5f
	 2qW14eWhTvrYG6rd2iiTAUAP07yiEGPlLgFvroas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Wen <puwen@hygon.cn>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Subject: [PATCH 5.10 204/294] x86/srso: Add SRSO mitigation for Hygon processors
Date: Thu, 11 Apr 2024 11:56:07 +0200
Message-ID: <20240411095441.744549245@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Wen <puwen@hygon.cn>

commit a5ef7d68cea1344cf524f04981c2b3f80bedbb0d upstream.

Add mitigation for the speculative return stack overflow vulnerability
which exists on Hygon processors too.

Signed-off-by: Pu Wen <puwen@hygon.cn>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/tencent_4A14812842F104E93AA722EC939483CEFF05@qq.com
Signed-off-by: Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1177,7 +1177,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
 	VULNBL_AMD(0x17, RETBLEED | SRSO),
-	VULNBL_HYGON(0x18, RETBLEED),
+	VULNBL_HYGON(0x18, RETBLEED | SRSO),
 	VULNBL_AMD(0x19, SRSO),
 	{}
 };


