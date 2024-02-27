Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA6854BFE;
	Tue, 27 Feb 2024 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044270; cv=none; b=VdvPhL0W5iANulqzNAA61ylTtL0s855X6qQMG0ZGu5LmJQtBxRR1ScRIzaw7679A1FQL7uUw31LEZXT/HbZYFQnzhkqHdKnMI5j0Uw8P1ARI2ygUbF2I/K96N8OIO+meqGeYAkB64JJ2wmsxeiDTowqqMZtTfdPc/CcdfI+CPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044270; c=relaxed/simple;
	bh=Vnsn0GphUfjWDrXwakChs1FZ3ArdD5MbWqbDc2Of1y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6bAqhIGzIHcFeEH6ZK+j6o9cy/TgejIWaWlCD2ooDBJJum7dsMob0fbcbQo5vhChA1iLcjsZwL24Ux2+5avVTztlBOmB2qXMhB9ZIXRVIel7dyUKVZapYEyr24eE9xPqMH5H0iUZw9SMPLTwyNFH2lWHZ0sI1TmG4dQlKquGwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcSBL/+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcSBL/+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F286C433F1;
	Tue, 27 Feb 2024 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044269;
	bh=Vnsn0GphUfjWDrXwakChs1FZ3ArdD5MbWqbDc2Of1y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcSBL/+jpCnEUYFXkbxq8zMF+/1XEB3bouyEi/YouVTpd2A4TB84WUBswb/HSGN6X
	 RGFvyQbtxbYl0gEG1SPmaKSmt8Rpp3tUzN23+4fz7r0Ws4JTF19nL4F5m+Ymv4mmeo
	 0oBVaGBbvhKCmilV09d/MmojA86e3hn5Ot8jMQpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianmarco Lusvardi <glusvardi@posteo.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/122] bpf, scripts: Correct GPL license name
Date: Tue, 27 Feb 2024 14:27:43 +0100
Message-ID: <20240227131602.042833902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianmarco Lusvardi <glusvardi@posteo.net>

[ Upstream commit e37243b65d528a8a9f8b9a57a43885f8e8dfc15c ]

The bpf_doc script refers to the GPL as the "GNU Privacy License".
I strongly suspect that the author wanted to refer to the GNU General
Public License, under which the Linux kernel is released, as, to the
best of my knowledge, there is no license named "GNU Privacy License".
This patch corrects the license name in the script accordingly.

Fixes: 56a092c89505 ("bpf: add script and prepare bpf.h for new helpers documentation")
Signed-off-by: Gianmarco Lusvardi <glusvardi@posteo.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20240213230544.930018-3-glusvardi@posteo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/bpf_helpers_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 31484377b8b11..806240dda6090 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -284,7 +284,7 @@ eBPF programs can have an associated license, passed along with the bytecode
 instructions to the kernel when the programs are loaded. The format for that
 string is identical to the one in use for kernel modules (Dual licenses, such
 as "Dual BSD/GPL", may be used). Some helper functions are only accessible to
-programs that are compatible with the GNU Privacy License (GPL).
+programs that are compatible with the GNU General Public License (GNU GPL).
 
 In order to use such helpers, the eBPF program must be loaded with the correct
 license string passed (via **attr**) to the **bpf**\ () system call, and this
-- 
2.43.0



