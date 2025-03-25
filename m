Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949225DAEB;
	Tue, 25 Mar 2025 12:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906369; cv=none; b=KT9S9VkFUiFBTdSd+hUy5kl5ielO1642Icc6cpn7f/Atbs9c9LHBeQ8LONtjL/MvP8ynWXPnFngTamkru8asHdWgWSkwedr114z2WFvdUlGicMqHqPFHv8CprjFWqjebnd/g/5GrGv9DucWrEfivHMcgOhkm6Sb5aGQu0MNAW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906369; c=relaxed/simple;
	bh=mbpA3wedsUBePsK5f+xeJjTZPuvs8ZiEvBIDgOEwmzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCom+e63Djmw7WagKXAQL4j9oAGB75XmCW6R5y9asBMf7nbDSHaCy/t2sYFNldMeudd/idiH0nQoVcJAQUy6BtMoIhRwCev4lVdqqDXLjsgW/tKT41SqTkG2RWO5Lw8ZmO2wbgDbAo5kpM1XPfX7ErjblhQnbfUz2H2Se1VnMT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jj5LpClV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jj5LpClV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1242C4CEE4;
	Tue, 25 Mar 2025 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906369;
	bh=mbpA3wedsUBePsK5f+xeJjTZPuvs8ZiEvBIDgOEwmzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jj5LpClVWqDvqK5czKhF/vmuQhKLrqE2PEhc+K0PK5bhEV+ddYtylLUu8L/okXZwJ
	 vewaAtt/Jc3kMSeL39iDBlzMwWzdF7DVwHPnzhlhExiohaF7gSO7v+5xjBsSfT7Qzo
	 S0KXODPGtdMAKKm0/SicDlMs4qM1IDLbFSdgNbSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 6.12 081/116] ARM: shmobile: smp: Enforce shmobile_smp_* alignment
Date: Tue, 25 Mar 2025 08:22:48 -0400
Message-ID: <20250325122151.281440164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


