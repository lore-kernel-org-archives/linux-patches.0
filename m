Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CC52571AB;
	Tue, 25 Mar 2025 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906024; cv=none; b=a7YDQGAH/e6ZkCfm/qh1AkvzkX/5rNxKTtbTyXL+QRW45W6b6smzVTPxP/YfAvEQm5v19lReQLqXPu4Bu1M0OILzd2UQyiQ0n8mmbRKFKX6NwGF2Tn2Te6vhxItjIKwOYXXQcgARWCLxUxiH6q4UUWgdsXJRYYGn4I4Q2CEvot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906024; c=relaxed/simple;
	bh=dv4M0z0eAxNoQeFItUfw4GrXJ9Q7DyuWHMg5HS5BGYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWnKpcOuLWu9v0g5X4Bw4Q2aCdeeUOU7EKQlX6hGGlqu9I1ZB8XoY+6wGNB55efscgjyL/mEyLoeMhQ9iHugEM+59hjWc7cMP7DcEiV/07Tn+lmod56+35Hc1i9wh5ZVAfmTP8bgCIAvrrl6egW66YOPsKamw1mlBW+WW/NX/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDW99uzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDW99uzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11321C4CEE4;
	Tue, 25 Mar 2025 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906024;
	bh=dv4M0z0eAxNoQeFItUfw4GrXJ9Q7DyuWHMg5HS5BGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDW99uzR/t3LxkDylJkv6E43GdAGGZvPcb1itEsLOhmVvy16EprQwfS2/0e3TFG6S
	 k2VDvDSgnBdT1zpr5jFD2qRK4814GyWTqezHELTRTAlZc8w0tzaff26Wz6QoNeQa0Y
	 wGd/jaR7zKp0SGf0/gpAo/EUdj5TW7DT2jjEZPVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.13 086/119] ARM: shmobile: smp: Enforce shmobile_smp_* alignment
Date: Tue, 25 Mar 2025 08:22:24 -0400
Message-ID: <20250325122151.256962426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


