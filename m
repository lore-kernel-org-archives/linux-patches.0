Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE702737EE;
	Fri,  9 Jan 2026 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961108; cv=none; b=NG5UFdinfudv7sei0YjqC3WbbSLmh8CS7aeYPd0C1OZlqBfoKFUFVFwfWP44JxmkdrxUdmQ/sU7ImUvVZagXhIJKxhL/gJhuLHiUrSaH0H1yXdvXbBbru41XqJewKHlrJ9gxGmvHXZ0z3f8sz9Dmeh6WSCMteaYk04/JWg6MtlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961108; c=relaxed/simple;
	bh=xB1Y7WSc17S3RtFoG9xbhNfiy4bFG38+040ecfjvrvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du/prNHAMaXcZVhKKhdpNFJKllGpJQlKmWso8nJ7zJSI1OwF6Lw3rHNRdRH/zWDUnzLa8pd1xxyWSfZdmT8INLHxeqVo2y2Pwnp5MG2ej4cf63B67VXZUrxaZdKN2P5XbLBWTj4TSmRbEr/qU1DFaiuHNWZ8KFMONzykZMFNG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tj+wEMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tj+wEMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DE6C4CEF1;
	Fri,  9 Jan 2026 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961107;
	bh=xB1Y7WSc17S3RtFoG9xbhNfiy4bFG38+040ecfjvrvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tj+wEMG3jHHEjMhLNxaMecepDek04e6VXO3f3+g5lEIiIGjP8SxZ+LV4+es5rUAZ
	 rhv582rjetLQ1ZwjaOe1JhzCaBr2FGKQjQRAW6l5mBobJGNd9H85RqEpn7EPKWz8ER
	 t+JfiAh8+8i7Mdba8u9PLW04iKSD1+IiKUBBSS+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 604/737] x86/microcode/AMD: Fix Entrysign revision check for Zen5/Strix Halo
Date: Fri,  9 Jan 2026 12:42:23 +0100
Message-ID: <20260109112156.728008807@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

commit 150b1b97e27513535dcd3795d5ecd28e61b6cb8c upstream.

Zen5 also contains family 1Ah, models 70h-7Fh, which are mistakenly missing
from cpu_has_entrysign(). Add the missing range.

Fixes: 8a9fb5129e8e ("x86/microcode/AMD: Limit Entrysign signature checking to known generations")
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20251229182245.152747-1-i@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -237,7 +237,7 @@ static bool cpu_has_entrysign(void)
 	if (fam == 0x1a) {
 		if (model <= 0x2f ||
 		    (0x40 <= model && model <= 0x4f) ||
-		    (0x60 <= model && model <= 0x6f))
+		    (0x60 <= model && model <= 0x7f))
 			return true;
 	}
 


