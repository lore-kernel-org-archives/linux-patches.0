Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA32233735;
	Mon, 27 Oct 2025 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593028; cv=none; b=PSQ3NwYJCrG0xWsizk09cwyKtqO1EEwm6EegIWMstqu/EhNlzRNMkLnRXQIGLkwvvjEv7O2ZEnpd2gCRWSCK5vNV1XTAaYJ2MPzLtKsdNSJnqb9WjGwExn1TKxxeTyNZIKfuoPsqDAGXQNMh4KdYxBnmRqmIz5BjOGmWGS8kjPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593028; c=relaxed/simple;
	bh=S5ZAutcr7l39/ciU9WTL2qZmQk2rn1wHS6HPqu4eGe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm85aOhCLd6sabbvyolPLCZ/GRl3NEQO+ldS2lbY8f2znJko4EuvEjq87w+2fSt0hyEXdPG5m8m1Gx3WQFLZSTzJlyJTFPb66QRFCqCIjYAT108AWWBhtndhG8KuilRA4ISxqOE0Cf13X3lA+QhSUoOPHlkVg8OBkwV+KQAKlUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzPuLz37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzPuLz37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5910C113D0;
	Mon, 27 Oct 2025 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593028;
	bh=S5ZAutcr7l39/ciU9WTL2qZmQk2rn1wHS6HPqu4eGe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzPuLz37PaqdNq3R6s7/AB/IHben8zG7eTWX+pfTBPuMbi8aJ3ONuP1G6eytbKo98
	 0USecphh+4f9V37LVOvWZvz8oz1R0EKOj57KVlcZJpOV0OqldWDjNq5pEajC7OrWkH
	 Y7AKFLq0CczSAm4EiC2WKqAtgjnrI0qNWHhjOTFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 101/117] x86/microcode: Fix Entrysign revision check for Zen1/Naples
Date: Mon, 27 Oct 2025 19:37:07 +0100
Message-ID: <20251027183456.753730862@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 876f0d43af78639790bee0e57b39d498ae35adcf upstream.

... to match AMD's statement here:

https://www.amd.com/en/resources/product-security/bulletin/amd-sb-7033.html

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20251020144124.2930784-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -182,7 +182,7 @@ static bool need_sha_check(u32 cur_rev)
 	}
 
 	switch (cur_rev >> 8) {
-	case 0x80012: return cur_rev <= 0x800126f; break;
+	case 0x80012: return cur_rev <= 0x8001277; break;
 	case 0x80082: return cur_rev <= 0x800820f; break;
 	case 0x83010: return cur_rev <= 0x830107c; break;
 	case 0x86001: return cur_rev <= 0x860010e; break;


