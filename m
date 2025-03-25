Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2B25BAD9;
	Tue, 25 Mar 2025 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906165; cv=none; b=PjedS55c+3XQJizKpa+zs1pf/dqpTsceJadjiMzb6Abg6+quyaYOIOs8DV+I7mV9qWdxmhK/u/UhKx4wh8isG0ZBkmw3ZYMvyhlgo4LEdNFVpOHhLJpttxt6v+vBF6fOAtpHfjiMOEjRrh09oTe7Od379i5xFX3VeHJpN2gw2/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906165; c=relaxed/simple;
	bh=HmWfJcEd6s4X4v8pBPDY7xYKxP/Xpw4QVlY+HDtUD2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbTG9PknfCki1bgZMqO0Dp1owtZDigJy8TDhv0SShOPhwtOryXcYsvIR9+K6rtRNlvZNMS8+UxnaXVj4Bp/8zF2UVl2DWvK13ZlMYLQpV/Qf11a8XhWOGPvpNOy4tWUkkg5sjPSQcy9JpNCZglJ1gfQkxoeMW6X79FIAvb9gTAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQDq1V1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQDq1V1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98579C4CEE4;
	Tue, 25 Mar 2025 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906164;
	bh=HmWfJcEd6s4X4v8pBPDY7xYKxP/Xpw4QVlY+HDtUD2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQDq1V1bAbMxJMbwtlsbIu1zlNPNz1qDgwXJND2deGa0Q4856+QWUW9oqSN4X1ch9
	 RxXUx8GirJ1zFQKfs0eBeGA4y3ime/7RHg5s9ONoT9y73V3jwPWCF5kDZ5KFcG7MCs
	 nz/lxgNbI/GuiFLLZ3CXJIMGS43axKeBTfenF/xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.6 50/77] ARM: shmobile: smp: Enforce shmobile_smp_* alignment
Date: Tue, 25 Mar 2025 08:22:45 -0400
Message-ID: <20250325122145.661007489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 379c590113ce46f605439d4887996c60ab8820cc upstream.

When the addresses of the shmobile_smp_mpidr, shmobile_smp_fn, and
shmobile_smp_arg variables are not multiples of 4 bytes, secondary CPU
bring-up fails:

    smp: Bringing up secondary CPUs ...
    CPU1: failed to come online
    CPU2: failed to come online
    CPU3: failed to come online
    smp: Brought up 1 node, 1 CPU

Fix this by adding the missing alignment directive.

Fixes: 4e960f52fce16a3b ("ARM: shmobile: Move shmobile_smp_{mpidr, fn, arg}[] from .text to .bss")
Closes: https://lore.kernel.org/r/CAMuHMdU=QR-JLgEHKWpsr6SbaZRc-Hz9r91JfpP8c3n2G-OjqA@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/c499234d559a0d95ad9472883e46077311051cd8.1741612208.git.geert+renesas@glider.be
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-shmobile/headsmp.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-shmobile/headsmp.S
+++ b/arch/arm/mach-shmobile/headsmp.S
@@ -136,6 +136,7 @@ ENDPROC(shmobile_smp_sleep)
 	.long	shmobile_smp_arg - 1b
 
 	.bss
+	.align	2
 	.globl	shmobile_smp_mpidr
 shmobile_smp_mpidr:
 	.space	NR_CPUS * 4


