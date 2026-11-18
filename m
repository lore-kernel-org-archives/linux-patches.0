Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023631;
	b=SqTzfErly5rC2MU2jQQPaG3JRtzj+boRrXAPZbS0nR18YzFAEV5redhSzQNnO4lqoC7U
	 IQYiBo3jT0fqEo9kTkVc9IcQE7x3cAsnev/Jp2R2Bn9V/JV2HTpRYPgzulc3en8scZ9EI
	 gAqvwPDy1JyrphTSTNLRNN1urHwCKnI9S5XQLGaycbleVVwDaOr7ilYpFvwV7O44I/r3B
	 zr6SzMTulwQQ31kv+9Fvo4MPMiRvTv+5Sfhxrs1fYBp7Wp3+85DGvjH8B+bJyyUj5sbhJ
	 GmJ0gPBuYs+sbuVbKsF2omZu0LBd+BsTvrhfmvgazYc0qREb5NA+gBhGdTYeHeERibA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+pzB8O5LKy8NinYrl/exk/GccK+u0BaJ8WPiZI4bBA=;
	b=JZDVMM3G0jPd56BrUiGh0shGqlaWEAJnECO9iriHz77xTswcrLxmD/mJROWXjWiH57uS
	 Q1p1EzjWd4FmXMR/81+NRyNFp7+bgsjuuI9FI0rT1lixbR7ycOm36o32cHzfyP+SXEj3Z
	 MG0pVVhLWOJHAnkGBm/yNTtbkIBOkaG7OGPIzKjvDsFrv1hWHmvZH9Xm02joo7b2bW9vN
	 XOcHrp0yRoAYp0fgIEgIiw/sJvWSbZSgwrc324+X/4f8ujtghng7prDm9oWWfdhOsoVw6
	 NxTMW/BnS6nfJiGjU0Bc1yUpYx5wbwQ1BHhu2UipC+L8sF9LOwp8YCOZLwWJrUem5xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFrssdwA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D823606A320;
	Wed, 18 Nov 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFrssdwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DBD1F000C4;
	Wed, 18 Nov 2026 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023631;
	bh=H+pzB8O5LKy8NinYrl/exk/GccK+u0BaJ8WPiZI4bBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFrssdwAexQ+FeQOO6ttYEKcOD8CaY4GYce53lAA8ONdp9ahDAVPobQUWKZAq1Cik
	 z/ppqa97eoDEnjftcmiCVG6ZFYNut9IV09gdo9KY9qs2ChoiKzqFdiaIu1cykKYnST
	 5gEAMTKsJqRpWu877mfo7zXmC5iC7wLjS6oGisG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0439/2151] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Wed, 18 Nov 2026 15:36:14 +0100
Message-ID: <20261118150138.030147078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 44b14ff4aebeae98663d0fd424b4ef88237ee981 ]

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260901140326.3812068-7-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b21..96243c291e39d 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -34,6 +34,7 @@ $(obj)/lib-%.pi.o: OBJCOPYFLAGS += --prefix-alloc-sections=.init
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y					:= idreg-override.pi.o \
 					   map_kernel.pi.o map_range.pi.o \
-- 
2.53.0



