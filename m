Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CC33D0BF;
	Wed, 21 Feb 2024 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708513863; cv=none; b=B+wm5gFmheMEPAi/z5U46tJT84gnYraehMrprzqOJZj668MlK/4AHLIRw9ucGie+1HiUPLienFp8FCuDKCUHTqWaHuX2pbs56Wl6ns71XeS2QUXaod48IEweu/I9GMf1K7BHhmg3epdPxUK/jzQ8UP/tp1KziNq0FmMfyqxS0jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708513863; c=relaxed/simple;
	bh=eqa3qErM7RQTKv99St58mGiTe7+MrVWsGFQ5TM92PF8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=e+N3Jxivck5WL45LfghLNrlVnHqt/seYA4xILWCEn6CqJq2mnaBMk5WZi3ZEpXxZs0WyJmNtxMkPgtH4il9IaitQCR9JdncFtn0Li8wq6ptCYz1POOvk1sakPrtPmYJ4RO3RCDbEoSKruqzgOZO9lyxQGUDiumWaVr9zCSpnJPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9YzbyjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9YzbyjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223A0C433C7;
	Wed, 21 Feb 2024 11:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708513863;
	bh=eqa3qErM7RQTKv99St58mGiTe7+MrVWsGFQ5TM92PF8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=E9YzbyjQu0l1V1efBshzBAfcN1HIgLFSLoNpAcNi2HPWf2dkLELfG0koCEhn9xlpJ
	 Fq67wnOVbmaK8hs9884KC8ve5thRlPtWyrzeS3MPOBhhLeZYBNVEr76jjnTDiN7Dex
	 N2WxtA3TCMlIHJiPEJnfxv6IttzF9sApdkVAY3FU=
Subject: Patch "Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""" has been added to the 5.4-stable tree
To: gregkh@linuxfoundation.org,han.xu@nxp.com,linux-mtd@lists.infradead.org,max.krummenacher@toradex.com,max.oss.09@gmail.com,patches@lists.linux.dev,richard@nod.at,s.hauer@pengutronix.de,tharvey@gateworks.com,tomasz.mon@camlingroup.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 21 Feb 2024 12:10:52 +0100
In-Reply-To: <20240207174911.870822-2-max.oss.09@gmail.com>
Message-ID: <2024022152-scoop-onstage-df6a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-revert-mtd-rawnand-gpmi-fix-setting-busy-timeout-setting.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From max.oss.09@gmail.com  Wed Feb 21 12:00:21 2024
From: max.oss.09@gmail.com
Date: Wed,  7 Feb 2024 18:49:11 +0100
Subject: Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev, s.hauer@pengutronix.de, han.xu@nxp.com, tomasz.mon@camlingroup.com, richard@nod.at, tharvey@gateworks.com, linux-mtd@lists.infradead.org, Max Krummenacher <max.krummenacher@toradex.com>
Message-ID: <20240207174911.870822-2-max.oss.09@gmail.com>

From: Max Krummenacher <max.krummenacher@toradex.com>

This reverts commit 15a3adfe75937c9e4e0e48f0ed40dd39a0e526e2.

The backport of [1] relies on having [2] also backported. Having only
one of the two results in a bogus hw->timing1 setting.

If only [2] is backportet the 16 bit register value likely underflows
resulting in a busy_wait_timeout of 0.
Or if only [1] is applied the value likely overflows with chances of
having last 16 LSBs all 0 which would then result in a
busy_wait_timeout of 0 too.

Both cases may lead to NAND data corruption, e.g. on a Colibri iMX7
setup this has been seen.

[1] commit 0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times")
[2] commit 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -684,7 +684,7 @@ static void gpmi_nfc_compute_timings(str
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:


Patches currently in stable-queue which might be from max.oss.09@gmail.com are

queue-5.4/revert-revert-mtd-rawnand-gpmi-fix-setting-busy-timeout-setting.patch
