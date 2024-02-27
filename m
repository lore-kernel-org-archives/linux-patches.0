Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08811419A0;
	Tue, 27 Feb 2024 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041545; cv=none; b=FKFaREYROfuA/O2GDYjwq5rhgIzbA/S+ZTcbEYDem/tWhQSxt32pICcmBDZLVArRheORUkg6JDmRodJkKDxP7mTwWd3z/Lv+NK0LNaEPcp+1J1MIPttuJG/Gn1Rz8LUaTY6oOSLXegXNb/ValOS34aeSUzWbI2xhxPcI0PyYc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041545; c=relaxed/simple;
	bh=2es+X6tt15dNhWrJd8ai3jZ6N2jn40P8ydbTzIFiOeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPbbHuVuvPVJe1r0rg879Wl6rLEQRtrK4nse/sgjoWLAnoQcnJFviM9orfnIjeVMxUO0N7GLQlVm4OIoueZ6b+CVuaWtd62Sx5Twp2POkQ/Ay5Gi8vzmRrgpgmPzawAjICkt3aC4YfSDsoZXgBBPfcqVDHkRoL5OOtxzaBP1ISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjgFqi8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjgFqi8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A625C433F1;
	Tue, 27 Feb 2024 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041545;
	bh=2es+X6tt15dNhWrJd8ai3jZ6N2jn40P8ydbTzIFiOeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjgFqi8phFjPbyk5k9x7Z/PabDUgSWPHnHf1K6efNzKpjhL6RSeO73WMlYoLQmpUk
	 wXKzzHmMD7t1K9KuuoAtzgw2r4EV7Q7uYQyDJvqVkVhRl4UQiojwXA6TAhcjPQLgts
	 WAJ4qXvRUXGrHRMYTR+lV5SWWDxfbCgndm4d3pUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianmarco Lusvardi <glusvardi@posteo.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/52] bpf, scripts: Correct GPL license name
Date: Tue, 27 Feb 2024 14:26:29 +0100
Message-ID: <20240227131549.911449480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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
index dcddacc25dff3..cf0ee47bcbeeb 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -286,7 +286,7 @@ eBPF programs can have an associated license, passed along with the bytecode
 instructions to the kernel when the programs are loaded. The format for that
 string is identical to the one in use for kernel modules (Dual licenses, such
 as "Dual BSD/GPL", may be used). Some helper functions are only accessible to
-programs that are compatible with the GNU Privacy License (GPL).
+programs that are compatible with the GNU General Public License (GNU GPL).
 
 In order to use such helpers, the eBPF program must be loaded with the correct
 license string passed (via **attr**) to the **bpf**\ () system call, and this
-- 
2.43.0



