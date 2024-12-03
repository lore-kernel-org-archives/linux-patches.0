Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5521E4A9;
	Tue,  3 Dec 2024 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236644; cv=none; b=jZxEs62RBuUVPF7eprdmJHkbHGNDDjvk5b6ZCiEUFYGOkg3sIzDQ+vL6MmaAP7u4noPrhJ+ABzKCffNVDxFi6JAYqzsGGoTug4hK2r7qL7jyIRHVniwji89V2PPVS/4nRnS5L5dekstVQzHIFx8F3TX2MrajW7lMmYgYnbU8pC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236644; c=relaxed/simple;
	bh=EaWZp0S5s8w8ze2EPWV1Le9zY2ZLhIzcyslRiotRr7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELjLL35+dFxbosfWtJMtPhRf2bs8Fwh3fl26qHLzPPhbyK0jTW2yrYXV8EVHpvLT80HJVbShGfZiHRYZGkQw/Wn4QVx3M1CmvYrZshjQ9DRCO5zmHy+yJsCYigN7RB47Psc7c8Nk9whc1V1oklAg7Kp6vS5HSK/cazSwzHuLgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/62hjdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/62hjdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E690C4CECF;
	Tue,  3 Dec 2024 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236644;
	bh=EaWZp0S5s8w8ze2EPWV1Le9zY2ZLhIzcyslRiotRr7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/62hjdVfsXkDvOjR7as02yDHNqVvZ62ZFidKgxP/VBLn8ojYJOUqP2ffB070es5N
	 7I/p8U614avcW85kB5b4zND7/E3KSm4kozZ4KyXVUx4pzbwwIbccetqyReK4reIpEZ
	 pkvEOQtRsqSZw8KQpEamG9FzNcKaenPFHg+ltQ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/138] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Tue,  3 Dec 2024 15:31:48 +0100
Message-ID: <20241203141926.587927513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

[ Upstream commit f212140962c93cd5da43283a18e31681540fc23d ]

Fix a typo in the CONFIG_M5441x preprocessor condition, where the GPIO
register offset was incorrectly set to 8 instead of 0. This prevented
proper GPIO configuration for m5441x targets.

Fixes: bea8bcb12da0 ("m68knommu: Add support for the Coldfire m5441x.")
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mcfgpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
index 66203c334c6ff..6c5d70defc1ea 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -152,7 +152,7 @@ static inline void gpio_free(unsigned gpio)
  * read-modify-write as well as those controlled by the EPORT and GPIO modules.
  */
 #define MCFGPIO_SCR_START		40
-#elif defined(CONFIGM5441x)
+#elif defined(CONFIG_M5441x)
 /* The m5441x EPORT doesn't have its own GPIO port, uses PORT C */
 #define MCFGPIO_SCR_START		0
 #else
-- 
2.43.0



