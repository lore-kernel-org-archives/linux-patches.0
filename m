Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A0165F1F;
	Mon,  6 Jan 2025 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177662; cv=none; b=EyfbkhR0lxihl1HhJPxwM3vNq0tKG4Ve1fGJ+UwrUeQfgAwY0VtsX91YKC60XYQgf1OWush4p2wdTWX+0R1X5YkuCFS4KeuOZ3Gyg+JsRrZR5zPzV0c/XFboF6DmM59WZUuKphf9iHchDpThF33koLpp/zwKXsnbnU0DlcmMTxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177662; c=relaxed/simple;
	bh=Li2hBaS4z2Hki+0qjM/k4xNLfKU7eZVVFkLWIhAg59k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lt6UlYekt1zvK9ZDOFCKLxCP8BRvEBnle7hYWKFuOxMJlYN6tbzKKvveXZMik9tvBVb6yKcqEz7LChl7US7kk2HAol5AT2biDOgPhUZB25B7zsSb8RPsE7ouXsAuHdhmb++0pBUkjWVI7WBjv6sJk1jzOYgnCR9wsf0gO15buik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ub0BoEG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub0BoEG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858F6C4AF09;
	Mon,  6 Jan 2025 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177661;
	bh=Li2hBaS4z2Hki+0qjM/k4xNLfKU7eZVVFkLWIhAg59k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ub0BoEG6NHoztqgCs10qEKaLRyIdwnABKhIQg0460SYWmSGAbfm6YOGzpU7XDZM+O
	 a1w2vTPTK8jofapDVUcGdJIDreaSktxBiSYgcLNi90iyJWHNZVKwaBldHJKQnbJHBZ
	 o9YZGMQv9Ndh5oax69m9fjlOCI03dyBmYC85JPSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Xiao <1577912515@qq.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 004/156] platform/x86: hp-wmi: mark 8A15 board for timed OMEN thermal profile
Date: Mon,  6 Jan 2025 16:14:50 +0100
Message-ID: <20250106151141.907761243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

commit 032fe9b0516702599c2dd990a4703f783d5716b8 upstream.

The HP OMEN 8 (2022), corresponding to a board ID of 8A15, supports OMEN
thermal profile and requires the timed profile quirk.

Upon adding this ID to both the omen_thermal_profile_boards and
omen_timed_thermal_profile_boards, significant bump in performance can be
observed. For instance, SilverBench (https://silver.urih.com/) results
improved from ~56,000 to ~69,000, as a result of higher power draws (and
thus core frequencies) whilst under load:

Package Power:

- Before the patch: ~65W (dropping to about 55W under sustained load).
- After the patch: ~115W (dropping to about 105W under sustained load).

Core Power:

- Before: ~60W (ditto above).
- After: ~108W (ditto above).

Add 8A15 to omen_thermal_profile_boards and
omen_timed_thermal_profile_boards to improve performance.

Signed-off-by: Xi Xiao <1577912515@qq.com>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://lore.kernel.org/r/20241226062207.3352629-1-jeffbai@aosc.io
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -64,7 +64,7 @@ static const char * const omen_thermal_p
 	"874A", "8603", "8604", "8748", "886B", "886C", "878A", "878B", "878C",
 	"88C8", "88CB", "8786", "8787", "8788", "88D1", "88D2", "88F4", "88FD",
 	"88F5", "88F6", "88F7", "88FE", "88FF", "8900", "8901", "8902", "8912",
-	"8917", "8918", "8949", "894A", "89EB", "8BAD", "8A42"
+	"8917", "8918", "8949", "894A", "89EB", "8BAD", "8A42", "8A15"
 };
 
 /* DMI Board names of Omen laptops that are specifically set to be thermal
@@ -80,7 +80,7 @@ static const char * const omen_thermal_p
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8BAD", "8A42"
+	"8BAD", "8A42", "8A15"
 };
 
 /* DMI Board names of Victus laptops */


