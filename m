Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D581494DC;
	Tue, 25 Jun 2024 09:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308513; cv=none; b=FRonK4FAqUQ9fWDVC2XQZ2rkZ77bCsW4ptwNQVXd3ooHdJtl7//TzMojHnqHZU8c3Z4zR9OZwdJjTHeQN8q78m0Ubu97piSI4/HYNV6qsjqvzNwmLk+e59OqKPI2OCRgUwJbO90FmzmP+IzZk+pkfQD2XslbW0ZGCplndXPDBCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308513; c=relaxed/simple;
	bh=VgOko6GwI3HH1X1Jf1XW2goDZPENGRwDJX20sghWoy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPH/liP5B1sSQc8HuWBK/02Mwf+SKYTsxZwy/GimnyTfcURxULt+VH0VHJetdv33IpPbol3gun6C+JDdYQzcYZW2hKjaa5ujmteGymkyq02YnuQiqHGnnDmpKG1v6tkwfIjd+ZsWd0MI6o0nKqYJVvFL29Z9OkxhZvEVe8dCmEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4E/cJIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4E/cJIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539DEC32781;
	Tue, 25 Jun 2024 09:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308512;
	bh=VgOko6GwI3HH1X1Jf1XW2goDZPENGRwDJX20sghWoy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4E/cJIhDfXkGLem8/lqvinkbx4XXjNX2f7ODjG3CMqiNxReUOcv3YkSMGb58uZWR
	 4BQQbAAIeelvXszpui9cikxF5MIy92obN/zqQOhTbzTExIq8pCzh+zBdi9k/pGU44k
	 SxiJm/wiA6nuImdiQoNC+CuthF870DXquS4XkO6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 147/250] powerpc/crypto: Add generated P8 asm to .gitignore
Date: Tue, 25 Jun 2024 11:31:45 +0200
Message-ID: <20240625085553.700954679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 2b85b7fb1376481f7d4c2cf92e5da942f06b2547 ]

Looks like drivers/crypto/vmx/.gitignore should have been merged into
arch/powerpc/crypto/.gitignore as part of commit
109303336a0c ("crypto: vmx - Move to arch/powerpc/crypto") so that all
generated asm files are ignored.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 109303336a0c ("crypto: vmx - Move to arch/powerpc/crypto")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240603-powerpc-crypto-ignore-p8-asm-v1-1-05843fec2bb7@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/crypto/.gitignore b/arch/powerpc/crypto/.gitignore
index e1094f08f713a..e9fe73aac8b61 100644
--- a/arch/powerpc/crypto/.gitignore
+++ b/arch/powerpc/crypto/.gitignore
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 aesp10-ppc.S
+aesp8-ppc.S
 ghashp10-ppc.S
+ghashp8-ppc.S
-- 
2.43.0



