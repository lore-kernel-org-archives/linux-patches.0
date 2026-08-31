Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7547CC6B;
	Mon, 31 Aug 2026 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184689; cv=none; b=nJDW7OKMWyEEUEHvzqVByFYLdhYd4bKrB4m35T9julQeyK6xKjkcG3x1Tx2kOgYA9muoBc2449IB4RZmI8BlqOamTIAebMDkEwfttpfWQlvhqPfFR7ZeZrKFY3Ob9qhdgVg8yhSRuMx8G6Pk2GdACkc7GgtRtuo2ZBUaG5BnflI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184689; c=relaxed/simple;
	bh=YqUa7X4MA96Yz8XXoAIcSeKdJJj3vO9HkAnvaqky6Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ego9N4AkH2yT0fGXs9g49x9uqG3J7M2FFwC8AAdMNg2sTCFp3kIcOwlKTmcihqWgVz0k/F/CNaJi2FvhIrUfv1upyvxZI7ELRu7kxCBiMh101hBmdXiJmgyKgkR5ZjK0aFZvgtQak/GmyZ9PTy8D9T97GipYs5zMv3Y8wqQf1Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNR6Rmqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNR6Rmqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2531F000E9;
	Mon, 31 Aug 2026 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184688;
	bh=h9MjDrAvkafSEL8HmT+ryqk5H0ohYuYTL20FHP1GPRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNR6Rmqi7MOuzHzuaPf+T0QO5MSKrOT9C2qA17OE8kB4AMXWu1vTT9c/a1o80dIWX
	 ErV7Iy+KRdZ4NNz3q/bTINpJj0IDkkeIvAUgZ5itOo0Zd5oO3Wcr6QgNnWGjSPYFFh
	 SRJFtm4VpyYBpvscF+47obteXjKqwNahBTt7Hc0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 70/91] x86/CPU/AMD: Add models 0x60-0x6f to the Zen5 range
Date: Mon, 31 Aug 2026 15:34:58 +0200
Message-ID: <20260831133403.291323306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

commit bf5641eccf71bcd13a849930e190563c3a19815d upstream.

Add some new Zen5 models for the 0x1A family.

  [ bp: Merge the 0x60 and 0x70 ranges. ]

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240729064626.24297-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -705,7 +705,7 @@ static void bsp_init_amd(struct cpuinfo_
 		switch (c->x86_model) {
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
-		case 0x70 ... 0x7f:
+		case 0x60 ... 0x7f:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		default:


