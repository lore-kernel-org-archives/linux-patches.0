Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EDB11CBA;
	Tue, 17 Jun 2025 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174262; cv=none; b=MIrPji211CntaurMg5Ay0VSIw+/MBrAwH9cc0Bi0IKmHjJFsPpigmZJh1ybGVRa1Yjua6AtSEGE8UZ3KJ2F6EtBAY5kZE1Em5M0CHcLO/4dSgKWWovM7KPTME6cbZpdrvPl5qht7f2WW5gQe4vOQiFTUnmskPiG2xbhzjEF8YO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174262; c=relaxed/simple;
	bh=UWV/VmvPuZYrsCIaOKqwAhUVrGJTw84fI5uC21nxKBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hO0TTaoYLiKkSDr/lUOc8206D+Afpd+Dq0y3gQLUMq7Zq2PQZMiTDuXSTccMdf+QwFCjqyHmO+5cyM/r9dpFUIktafXUWpjqrAGmQWBXVa/n40PDXHve66lEfmYTe1TmcWs4323nYl5Juef3fV6M3Uc2JJB2bS/qm7ESM3CkYbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8eFtYUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8eFtYUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206F9C4CEE3;
	Tue, 17 Jun 2025 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174262;
	bh=UWV/VmvPuZYrsCIaOKqwAhUVrGJTw84fI5uC21nxKBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8eFtYUylQ+M3z0KnwyYu7enRmwtKprYmjE151UNoshgdNnnYI2z1k6NsEMnh/U+J
	 rqXBUevDfD7nHFaqmfhXN+Zxoth1IOdc0IJ3ugMUu1HzAeIzHoUx6GAbQvB4rH4AQX
	 d5sHZFaDJEYVO0J7kAmC93WAgdiigucxkszLpc0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/356] powerpc: do not build ppc_save_regs.o always
Date: Tue, 17 Jun 2025 17:22:20 +0200
Message-ID: <20250617152339.250901739@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 497b7794aef03d525a5be05ae78dd7137c6861a5 ]

The Fixes commit below tried to add CONFIG_PPC_BOOK3S to one of the
conditions to enable the build of ppc_save_regs.o. But it failed to do
so, in fact. The commit omitted to add a dollar sign.

Therefore, ppc_save_regs.o is built always these days (as
"(CONFIG_PPC_BOOK3S)" is never an empty string).

Fix this by adding the missing dollar sign.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Fixes: fc2a5a6161a2 ("powerpc/64s: ppc_save_regs is now needed for all 64s builds")
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250417105305.397128-1-jirislaby@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 2919433be3557..b7629122680b1 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -165,7 +165,7 @@ endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)(CONFIG_PPC_BOOK3S),)
+ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)$(CONFIG_PPC_BOOK3S),)
 obj-y				+= ppc_save_regs.o
 endif
 
-- 
2.39.5



