Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048266;
	b=DYoqnEgKeXNe3o5D1fMC0ud9w69M6b4fqK1LtAkHLOfGWlZ1nePbXIPE49bi6ANzCLDH
	 5hRC9bNMJ845JBLNYtpfQdoTw8xNF+wBpDMRQV7b0lh1HFJAPm9vYzwWqNe8zyoG9B4Tw
	 LxN6FFRZl9SgpsCf+REbgMdKfhrOf+FcQvl4Emxmzrtb4LNHUKSclQ4ZWcJjzLoawBl5w
	 I3lYe4kY5+TGwQyz21WbBCc4vel14Q8PgpNKbBAxkehRSNnMvdRv+RfPWon57GfPsmbrS
	 S5PEMNavrAl5dO4gUsMkszB8OX/+95JP9L9sEeIbrD9KXO2h/VvKWz/d8JC5/tCxkpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hiUa2qDokzBtLVXTt7DtsUR7H9MY9YUZ1s4KIbQ1aT0=;
	b=UFEW26IUDhHvIXy+ofaPXjnOagaDi/36KAFTPj1p8KEB6Npvz/YZvEQp4zGu4JwK1aVI
	 qV5ZuhFLDmEVBKfog8enRo7wEvbg21FTVZqQK15E5I9k5XGYiyY2KqBEzKnxZA3fiTDn1
	 /DXp9MX+1K4riR0qX23NEqoETJBZI5VbkE/GEfEmYrsoW1mgk1k9V3PlbvdGtDWligrrj
	 R2CCMAaxRitwRLZ49Y/7DM4Z+jvkII6iW+OPSVZgylCwmunZAfhkErYStUh4phDt1rAC+
	 eWynsKhcORGWR1Ogs/cvEbQSgEpY5yg4DPfIqX2Cf/+YRhLMvh3qwKa9Ijpo6wEyoxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJkxLghv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FEB606A31C;
	Thu, 19 Nov 2026 00:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJkxLghv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DE81F000C4;
	Thu, 19 Nov 2026 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048266;
	bh=hiUa2qDokzBtLVXTt7DtsUR7H9MY9YUZ1s4KIbQ1aT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJkxLghvj6HTkduVu2Oae3VVZoxkzYZPcTSAJAcVYZc4gHPUEMIkujYFlg0Hqrm+T
	 1VWR6iKydsFLQh4GAER99BvUg4rGAIUY3PUZgexLIax1Ebnce01v9n9EyI/Q3xDuKk
	 eQfZcz1S0NLQoQNLamvL27041BirF5a7ULSFzkZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1932/2857] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Wed, 18 Nov 2026 15:49:26 +0100
Message-ID: <20261118150310.775533754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 839291430cb3b..bcc3012e48e53 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -28,6 +28,7 @@ $(obj)/%.pi.o: $(obj)/%.o FORCE
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y		:= kaslr_early.pi.o lib-fdt.pi.o lib-fdt_ro.pi.o
 extra-y		:= $(patsubst %.pi.o,%.o,$(obj-y))
-- 
2.53.0



