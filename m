Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185492F2D;
	Tue, 27 Feb 2024 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042249; cv=none; b=kKWG6I1DLo5uxVKsSvf9oT59CtVRFQ/cYlAR6Qsv9yyFg1d7xm3PY+ny5KLzItp/cqu+SNh2QQnyKhUpFT/RGg+kmVOtjPy8bTGZYe1QdL1JXu3VESXvtDtMqiunQVOoxidVgFN4teLeXWAJb8KnjqhVM8/bLLrvv/YxgsNnKDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042249; c=relaxed/simple;
	bh=LGh2BsQvNn11838CkLqM14T7zDKtoOUmKaj7k33VGXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/vSRiQNEJQtvtnoGZJ3GkNgNL4Nkgt+78C4C4hjGmVzu+Lylj4NFBvkiHAb2M8v7EY00rXUw1K+HhP3d3Enb+w8q420gUo40DMZ3JWbqt9iCK1QkkD6tmqdVf4tDtQo2R13tSSHSgLJ+MegCGauJw8hUu+p7wEz68oF2AB8rN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPaYcaG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPaYcaG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB8CC433C7;
	Tue, 27 Feb 2024 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042248;
	bh=LGh2BsQvNn11838CkLqM14T7zDKtoOUmKaj7k33VGXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPaYcaG8rhqKGHILZe4GW+IQoFFmduSbIfMMJa+JjsjfGyvJhpC+P04wVrndPvqDQ
	 w4uetbcyRhVHxHHaLawm7n/cWg4oZs703DLPhX4z1yoqmEqYvdNnLrLpLEUCHTy+bH
	 b43B/LZQSBHJWvyxmVAxWXJiBgqhmcTS0S0X3vKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianmarco Lusvardi <glusvardi@posteo.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/299] bpf, scripts: Correct GPL license name
Date: Tue, 27 Feb 2024 14:25:42 +0100
Message-ID: <20240227131633.182165231@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 scripts/bpf_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 61b7dddedc461..0669bac5e900e 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -513,7 +513,7 @@ eBPF programs can have an associated license, passed along with the bytecode
 instructions to the kernel when the programs are loaded. The format for that
 string is identical to the one in use for kernel modules (Dual licenses, such
 as "Dual BSD/GPL", may be used). Some helper functions are only accessible to
-programs that are compatible with the GNU Privacy License (GPL).
+programs that are compatible with the GNU General Public License (GNU GPL).
 
 In order to use such helpers, the eBPF program must be loaded with the correct
 license string passed (via **attr**) to the **bpf**\\ () system call, and this
-- 
2.43.0



