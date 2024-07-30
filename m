Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886681A6161;
	Tue, 30 Jul 2024 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356332; cv=none; b=dUkbWRktOzRR5vrcgEWrwcTJVp5kwXESY/elNTw6Ee+mo7hC48jIl4b+k2Dt8S8foSfL8dZvKgbzLgzz3DNjW+uK9KdDCE4AWVDigr7MRofj6KSRUsmcfI56AM4zY7MnrrImwVWI1BKacgvpowJ9nOfW63RU5NlqKM4Z1gZ3lr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356332; c=relaxed/simple;
	bh=70cgeueA2Vs9ZopmZvpafSR2HStbNJcEPI5b16NkqZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL7k0OAltmIBCQqD30l6SkfdmwQT8vQdzRQB0RYJW8cS64vXdFcr3PfBl7I6HrSFON9KR3+eUrnug61LcoX7HXaG5w7x8IUAJCCf4i1A6p1dhuP+sGLUcEkg3qIeyEo1QOyDzkjPonP5fVy/tda7hSH3+e0y2pmgEqe7+U2MhBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pl94/Qgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pl94/Qgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEADC32782;
	Tue, 30 Jul 2024 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356332;
	bh=70cgeueA2Vs9ZopmZvpafSR2HStbNJcEPI5b16NkqZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pl94/QgvxP8h79NoCphPRteg+/W5GNyctdlpUnWUwRZGDRYsOp2uTlJqcBmsFw7yR
	 FNygbvOgz7dsivRPhMjKlHiJbtjqli1fbA+gc+1d37Kz/F2ky3Ix7hCItFGdiOgz0X
	 zq5fcjTARLI/5aQCzfJ+mvzsx4V2xcuSnPaKJZm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/809] m68k: cmpxchg: Fix return value for default case in __arch_xchg()
Date: Tue, 30 Jul 2024 17:40:16 +0200
Message-ID: <20240730151730.140194251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit 21b9e722ad28c19c2bc83f18f540b3dbd89bf762 ]

The return value of __invalid_xchg_size() is assigned to tmp instead of
the return variable x. Assign it to x instead.

Fixes: 2501cf768e4009a0 ("m68k: Fix xchg/cmpxchg to fail to link if given an inappropriate pointer")
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240702034116.140234-2-thorsten.blum@toblux.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
index d7f3de9c5d6f7..4ba14f3535fcb 100644
--- a/arch/m68k/include/asm/cmpxchg.h
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -32,7 +32,7 @@ static inline unsigned long __arch_xchg(unsigned long x, volatile void * ptr, in
 		x = tmp;
 		break;
 	default:
-		tmp = __invalid_xchg_size(x, ptr, size);
+		x = __invalid_xchg_size(x, ptr, size);
 		break;
 	}
 
-- 
2.43.0



