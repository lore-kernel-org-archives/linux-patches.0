Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5854819EED0;
	Thu, 15 Aug 2024 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729247; cv=none; b=HQM0GWAhAk4z+Wd7JMlt0kRbAnmW+0h4KhDWyLP6kBF8qFbbbSrdGgpEie0LsBmdiCjsUL2NGii+4Npq6lY+lfT47bSHxwsmwDSehWo4cI7YUV+5AbN5qb7qrDXEMAiZYwUZ044htz6s7zZVwkJUXWfZzqCAOaZq/cczjfooRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729247; c=relaxed/simple;
	bh=UoVLMXGVAmnbv7RfbeF9I6V/VDtAOuinaw8pQi/xEWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhV7TTZSSEhADL7ELzmUtoeWYDiEVLklBC1idftoDfhTbO9rHJxigye1ShLOyqHfRnxNDynOb130TpIeXE6Sdk+Qt/2i5pA8MJ6rUHktNDB28NnEx+b0+Md72/dBhfiHxEaLosXv07lJX/gTHb/FGDG8yLlhVI2HgOgaR1SyzQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KA0/Jhsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KA0/Jhsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D231FC32786;
	Thu, 15 Aug 2024 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729247;
	bh=UoVLMXGVAmnbv7RfbeF9I6V/VDtAOuinaw8pQi/xEWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KA0/JhsdsqSFYR2MoFz5PEBmUl/GmQSTEAP9gqy+aNrkdiGS2q8q3yAdPcBMk5BRv
	 WteNPUDOyUzMuclrRq8UGV1b76p9yg+fjAw9wcCxVeeOYiDXlhD1S/b4dOhf2uZbs5
	 SSCcAiJOsE5u4EPbCLv/dCoyN08KS0UUZZKvfWDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/484] m68k: cmpxchg: Fix return value for default case in __arch_xchg()
Date: Thu, 15 Aug 2024 15:18:16 +0200
Message-ID: <20240815131942.743773451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e8ca4b0ccefaa..9765910d0ad27 100644
--- a/arch/m68k/include/asm/cmpxchg.h
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -33,7 +33,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 		x = tmp;
 		break;
 	default:
-		tmp = __invalid_xchg_size(x, ptr, size);
+		x = __invalid_xchg_size(x, ptr, size);
 		break;
 	}
 
-- 
2.43.0



