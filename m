Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB61B2C11DF;
	Tue, 13 Oct 2026 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895756; cv=none; b=QuTfzPRxXDS9JgpzBlEH3J3mcCwBGAXW2wcHx9CyCBaLQxGPfw6rxYhG6jyGC8DcdqTD/aFrticnnsXmnoCYEIog9zCuySrgEJCmw/m2r/UvgZ3SWXM3jbUKtFVB3sjgOC2rh7/sECEz8+7eE+m68eomBBc1rDdNW9b6/DG+rSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895756; c=relaxed/simple;
	bh=r0UI5lRYaFHwiNl19v1q37WhkU5WWm4EOHzTkHkv9iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBuLgzGh3QNs/KKio8RAyOgGXNob/gDjYMFEl5vILZ7bdsuMPRL6eZjl2B3qXHf5ZplgHAZAmfxG9pAJqDtg8YxKHcNxr7TCDca0I7Jq1Yb93zyYPV+BrdAG7v7l0FZc9uIRJvX+XYdMlIPxCfw/XtSfG5vVZmKzSlxXz1/wni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emTdonxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emTdonxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AE71F00893;
	Tue, 13 Oct 2026 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895755;
	bh=jB5laeX1TdYAgCbVmVAAaVCfiHv/V+ZtlgTDel2HdJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emTdonxrXmAzPJ2TvGPsVnw8PV1e+X4FIs1K5noU7QgTZJsBXWY81PJDiQHo6/jjs
	 XESNcq19P0fFBdcOqkkGx4Idck78q2ERsuMt22QZZ2KYlUyFVKw62kqVuDtIrwAzvx
	 b8ucHFrAyLK5fzVlHmTx9U1S4ZVOKlDMQdkhxE5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Vishal Badole <Vishal.Badole@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 383/497] EDAC/amd64: Mask UMC chip select to the four implemented selects
Date: Tue, 13 Oct 2026 13:39:10 +0200
Message-ID: <20261013112916.986076821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Badole <Vishal.Badole@amd.com>

commit 7484bc43ba6b8e189b482db5b75e7842890a82b1 upstream.

For DRAM ECC errors, the chip select value can be found in the
MCA_SYND[ErrorInformation] field.

ErrorInformation[2:0] was first documented in Zen1. The 3 bit field
implied that up to 8 chip selects may be used.

However, all Zen-based systems have only ever had up to 4 chip selects.
So only bits [1:0] would contain a valid chip select value.

Future systems are redefining the field to ErrorInformation[1:0]. This
matches the existing 'up to 4 chip selects' implementations. And it
frees up the extra bit for other decoding.

Change the current chip select mask from 0x7 to 0x3 to prepare for the
decode change.

Fixes: 713ad54675fd ("EDAC, amd64: Define and register UMC error decode function")
Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261002113204.3358815-2-Vishal.Badole@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2795,13 +2795,13 @@ static inline void decode_bus_error(int
  * the instance_id. For example, instance_id=0xYXXXXX where Y is the channel
  * number.
  *
- * For DRAM ECC errors, the Chip Select number is given in bits [2:0] of
+ * For DRAM ECC errors, the Chip Select number is given in bits [1:0] of
  * the MCA_SYND[ErrorInformation] field.
  */
 static void umc_get_err_info(struct mce *m, struct err_info *err)
 {
 	err->channel = (m->ipid & GENMASK(31, 0)) >> 20;
-	err->csrow = m->synd & 0x7;
+	err->csrow = m->synd & 0x3;
 }
 
 static void decode_umc_error(int node_id, struct mce *m)


