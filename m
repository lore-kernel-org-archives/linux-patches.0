Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFFE2ECD22;
	Tue, 17 Jun 2025 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174793; cv=none; b=L+ACeVpiN88ZTHU3G86Mg99bjY8us5DY/RIUOEpPds5lnDS8tGrXbtXjkmduSsh5xyiEMsfEluTyvAiJIBHqHqfZ+LMFVtstVILEX6HjJgSj2ZiP+ZRQpO7MrVzI6Cochg5GkSRgbn5coiBIi+vTOfyecoWG3OMzZuK7UuSzBN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174793; c=relaxed/simple;
	bh=Ux9HqUSh9Un1+22iEPBNLE2DZmNIFART2Rn8Nn8w0LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s14YJd9tPoj1il/17uqP/DS84Ldp2qUpqTcp/epmURD2tgkhZ7NSkXUvuEBHJ+W0kD2IIIM3tajY5qCkzupMo3782Z4/+KPnyABkUcmq7qG+mAFq6BmEM8b2VoGcrswYinOLAtc3LLZZYH2uPiIVHLca9wxUXqkRtqCHY6mmiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rlans3mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rlans3mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953FEC4CEE3;
	Tue, 17 Jun 2025 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174792;
	bh=Ux9HqUSh9Un1+22iEPBNLE2DZmNIFART2Rn8Nn8w0LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rlans3mjg7C9DUnnT1SrBJHxXNm3tFsqFKnvkaU8z79mgx1dmHhQTPW+kxzMncJoe
	 fuVrzASmHPjoTdKzssTdVzRaN1IIvtCVQ5/ji1MNr3uZrGrKfpq+3+VrLHPdTIf+3s
	 E1Lqo99KMO5CofU43rrXY03Y8LL/6MeBh9dq7vIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 021/780] powerpc: do not build ppc_save_regs.o always
Date: Tue, 17 Jun 2025 17:15:29 +0200
Message-ID: <20250617152452.375213378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ac621155ec3c..0c26b2412d173 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -160,7 +160,7 @@ endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)(CONFIG_PPC_BOOK3S),)
+ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)$(CONFIG_PPC_BOOK3S),)
 obj-y				+= ppc_save_regs.o
 endif
 
-- 
2.39.5



