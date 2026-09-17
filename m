Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0498F259C80;
	Thu, 17 Sep 2026 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660208; cv=none; b=oSIf+806BVE0IIVzpRH95oYTUPE+dtd1VWJxA/glfrdC/l1BR/8X9B+mj2IdBxzexo4P4Die4ovbBEH2JSINmndhmg1c/AdcWKIkiagqm7Q6p/Hn4ktq4PZdGkLOLLS6sbJGRnCSEsavcCXlBINZ9rMGZI++rVLJfeIQy0kt+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660208; c=relaxed/simple;
	bh=Dj9FA4i6uNtego8cKOwGaeVeQEoa/YTAGpdqqg4uzDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx4Kg+T8NgbZ9J0sQ6FhiOG/aU0TrK047/D71L90oMPvHDBhcTjUlZH85A3YTm/rQ7TA6kEhMeOHcipMugRdAF80ClxrS9Ukhn5+5vKjgb2zfQQ1lY6avgwC0BTxEp6neGkn3F637peHiaUallv+Ug7GuGI58x0dh7zTCChlsy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw6LrrvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw6LrrvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EA41F00893;
	Thu, 17 Sep 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660200;
	bh=p/cbF3VR5hLlGgTJqKV8FKT0VsWdgE+QCs0CFvbgtgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zw6LrrvL7MH932C5VStBPpQRFBykjqRruBqw3z/PyEsFmu6J4rqSNpHJSdKJZZEG4
	 CwmWW+aqZKlJCUPGcurDOX7TFBhZKTegvUc389hfOjGCqHZCYCI7SHHCz05lmzdIRf
	 fvXjOInVbb1ntY+1MBOtg+ZscQqOVZiOXpjevAyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 7.2 512/733] ata: pata_legacy: remove documentation for removed module parameters
Date: Thu, 17 Sep 2026 16:13:40 +0100
Message-ID: <20260917151404.887706345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit a19d4f9b8befdcfcd5a87bab91312fe64af3bbb8 upstream.

Commit 3c4d783f6922 ("ata: pata_legacy: remove VLB support") removed
several module parameters from the pata_legacy driver, but neglected to
remove their documentation. Remove it.

Fixes: 3c4d783f6922 ("ata: pata_legacy: remove VLB support")
Cc: stable@vger.kernel.org # 7.0+
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20260607064053.195166-1-enelsonmoore@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   37 ------------------------
 1 file changed, 37 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4922,18 +4922,6 @@ Kernel parameters
 			Set to non-zero if a chip is present that snoops speed
 			changes.  Disabled by default.
 
-	pata_legacy.ht6560a=	[HW,LIBATA]
-			Format: <int>
-			Set to 1, 2, or 3 for HT 6560A on the primary channel,
-			the secondary channel, or both channels respectively.
-			Disabled by default.
-
-	pata_legacy.ht6560b=	[HW,LIBATA]
-			Format: <int>
-			Set to 1, 2, or 3 for HT 6560B on the primary channel,
-			the secondary channel, or both channels respectively.
-			Disabled by default.
-
 	pata_legacy.iordy_mask=	[HW,LIBATA]
 			Format: <int>
 			IORDY enable mask.  Set individual bits to allow IORDY
@@ -4946,18 +4934,6 @@ Kernel parameters
 			with the sequence.  By default IORDY is allowed across
 			all channels.
 
-	pata_legacy.opti82c46x=	[HW,LIBATA]
-			Format: <int>
-			Set to 1, 2, or 3 for Opti 82c611A on the primary
-			channel, the secondary channel, or both channels
-			respectively.  Disabled by default.
-
-	pata_legacy.opti82c611a=	[HW,LIBATA]
-			Format: <int>
-			Set to 1, 2, or 3 for Opti 82c465MV on the primary
-			channel, the secondary channel, or both channels
-			respectively.  Disabled by default.
-
 	pata_legacy.pio_mask=	[HW,LIBATA]
 			Format: <int>
 			PIO mode mask for autospeed devices.  Set individual
@@ -4981,19 +4957,6 @@ Kernel parameters
 			the first port in the list above (0x1f0), and so on.
 			By default all supported ports are probed.
 
-	pata_legacy.qdi=	[HW,LIBATA]
-			Format: <int>
-			Set to non-zero to probe QDI controllers.  By default
-			set to 1 if CONFIG_PATA_QDI_MODULE, 0 otherwise.
-
-	pata_legacy.winbond=	[HW,LIBATA]
-			Format: <int>
-			Set to non-zero to probe Winbond controllers.  Use
-			the standard I/O port (0x130) if 1, otherwise the
-			value given is the I/O port to use (typically 0x1b0).
-			By default set to 1 if CONFIG_PATA_WINBOND_VLB_MODULE,
-			0 otherwise.
-
 	pata_platform.pio_mask=	[HW,LIBATA]
 			Format: <int>
 			Supported PIO mode mask.  Set individual bits to allow


