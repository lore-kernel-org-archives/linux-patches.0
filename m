Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582D272632;
	Mon,  4 Aug 2025 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267029; cv=none; b=byUTPV6z+VU1fRs1M/qtfHfnLABahIIKdkdfwccKoeMNu9WnX1mPtQuNYeuB84WSTVsGbnS4IDf3dr0gF/CGcbYEfVrWf32FjUgb304HN5BJvcHPADrZX321xHXdrrF6ot/cerGYSz4jeXNfE97xYSpivitLBNjqOfhI6Jto+ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267029; c=relaxed/simple;
	bh=a2W8YEILvuFGaDwd8HstuzgOBzSPsd5L1izGgKLkZlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvqSc7bwwaJYbFXeUbV6Q39jZBlMSSifsrBYVCyQhxwC3Q75c0p5FpvRyWD15AMxOW6BSNN47JM1MmE11Fz8yhg+A21Kdqv09X/6Wo34K+CI3IXpICjpn/ZvJnPB4CtKYDD2gGW0gzWcq7Jy1937tzl5o5quVobf1v14I6UWrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBoUDMSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBoUDMSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC36C4CEEB;
	Mon,  4 Aug 2025 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267029;
	bh=a2W8YEILvuFGaDwd8HstuzgOBzSPsd5L1izGgKLkZlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBoUDMSOWRjU8FD2EDwFaUiI+tZm7L/exfjX26Vs39wrSTgTRZ2T0+yDycuJXzQMO
	 b5sy90Ge3+alV1SIZy+D7mF/T/M5OJQpHXahJTVO/2GuxRsaP9DGbYo7IYF91tt0g6
	 SvXna7l9mgA64d/FVh4YG3gAdW2OpBDS6Snza4EomNW+/wLa+FDoi1zjTkpIfPDguk
	 SVy1dQ9EpQbE9/afjlQO5MNfA7kY9WKLtSpn66PC8FGm6qnIgaNfyoOg2JDx88/zCZ
	 RydSwZDxvgtPnsgheDwR5MTw7rjLnKyTxteSNOXchncM7mlr7WUSezK02I14hxdMy9
	 xhKEZnd3zzD9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Penkler <dpenkler@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	matchstick@neverthere.org,
	dan.carpenter@linaro.org,
	everestkc@everestkc.com.np
Subject: [PATCH AUTOSEL 6.16 02/85] staging: gpib: Add init response codes for new ni-usb-hs+
Date: Sun,  3 Aug 2025 20:22:11 -0400
Message-Id: <20250804002335.3613254-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit f50d5e0c1f80d004510bf77cb0e1759103585c00 ]

A new version of a bona fide genuine NI-USB-HS+ adaptor
sends new response codes to the initialization sequence.

Add the checking for these response codes to suppress
console warning messages.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250722164810.2621-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I'll now provide my assessment of whether this
commit should be backported to stable kernel trees.

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Commit Analysis

The commit adds support for new response codes from newer NI-USB-HS+
hardware adaptors. Looking at the specific code changes:

1. **Lines 2082-2086**: The comment is updated from "NI-USB-HS+ sends
   0xf here" to "NI-USB-HS+ sends 0xf or 0x19 here", and the check is
   expanded to accept 0x19 as a valid response code.

2. **Lines 2113-2119**: The comment is updated to indicate that new HS+
   hardware sends 0x59 at position [10], and the check is expanded to
   accept 0x59 as a valid response code.

## Rationale for Backporting

1. **Fixes a Real User Issue**: This fixes a bug where newer NI-USB-HS+
   hardware generates console warning messages due to unrecognized
   response codes. Without this fix, users with newer hardware see error
   messages like "unexpected data: buffer[x]=0x19, expected..." when the
   hardware is actually functioning correctly.

2. **Minimal Risk**: The change is extremely contained - it only adds
   two additional valid response codes (0x19 and 0x59) to existing
   validation checks. No logic changes, no structural modifications,
   just expanding the set of accepted values.

3. **Hardware Compatibility**: This is a hardware enablement fix that
   allows Linux to properly support newer versions of existing hardware
   without generating spurious warnings.

4. **Staging Driver Context**: While this is in staging, the gpib
   subsystem appears to be actively maintained (based on recent commit
   history), and hardware compatibility fixes are important for users of
   this specialized equipment.

5. **Clear Bug Fix**: The commit message explicitly states it
   "suppress[es] console warning messages" - this is fixing incorrect
   error reporting, not adding new features.

6. **No Architectural Changes**: The patch doesn't change any APIs, data
   structures, or driver architecture. It's purely adding two constants
   to existing validation logic.

7. **Tested Hardware**: The commit message indicates this was tested
   with "a bona fide genuine NI-USB-HS+ adaptor", suggesting real
   hardware validation.

## Stable Tree Criteria Met

- ✓ Fixes a bug that affects users (spurious warnings with newer
  hardware)
- ✓ Small and contained change (4 lines modified)
- ✓ No side effects beyond the intended fix
- ✓ No architectural changes
- ✓ Hardware enablement for existing driver

The commit clearly meets the stable tree criteria as a minimal hardware
compatibility fix that resolves user-visible warnings without any risk
of regression.

 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index 7cf25c95787f..73ea72f34c0a 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -2079,10 +2079,10 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 		}
 		if (buffer[++j] != 0x0) { // [6]
 			ready = 1;
-			// NI-USB-HS+ sends 0xf here
+			// NI-USB-HS+ sends 0xf or 0x19 here
 			if (buffer[j] != 0x2 && buffer[j] != 0xe && buffer[j] != 0xf &&
-			    buffer[j] != 0x16)	{
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf or 0x16\n",
+			    buffer[j] != 0x16 && buffer[j] != 0x19) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf, 0x16 or 0x19\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
@@ -2110,11 +2110,11 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 				j, (int)buffer[j]);
 			unexpected = 1;
 		}
-		if (buffer[++j] != 0x0) {
+		if (buffer[++j] != 0x0) { // [10] MC usb-488 sends 0x7 here, new HS+ sends 0x59
 			ready = 1;
-			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e) {
-// [10] MC usb-488 sends 0x7 here
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07 or 0x6e\n",
+			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e &&
+			    buffer[j] != 0x59) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07, 0x6e or 0x59\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
-- 
2.39.5

