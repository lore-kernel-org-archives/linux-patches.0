Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A001DF279;
	Tue,  8 Oct 2024 12:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392363; cv=none; b=BF7fm0cLOsgkyu4TTfIYcLF03Q+f1RqztA8WPpH0JFJFHRhSHaDwCGXcdvwxVY+3Smd00LXc3yi/ux1nvuQsZDQGyYcEcTOXh9jGt8mux+71WiRmAQZeSglXyGP+34exMiaf26nwjJigG9ZwstuuvIaziNGCU2af4VDt7VyKatA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392363; c=relaxed/simple;
	bh=6Rg/F6BesPIEVwV+puyzWHrnlv/FvtZ67lFOnyQJO/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrTtCfGWi9PKhCVK9GB5O0gwoei8ssO4c+TPgFUv8MQdiHabloF/FFszNA2mhK+js4F4G3VqTumxK5WUj8dfR2e6rx240Oi2+4Otg/nIvYD0OQgRaxv+IvvPP25iV2n0fSbbFycyMRRkiT+7T7Qvug7Lsu5G3CCgbOyGSs844kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJjFLnH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJjFLnH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C01C4CEC7;
	Tue,  8 Oct 2024 12:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392363;
	bh=6Rg/F6BesPIEVwV+puyzWHrnlv/FvtZ67lFOnyQJO/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJjFLnH3lmnDWn3UsJxk3Lx+AMKbp1vNBglzDYTXBHSjbgIPzPDk4k6S8mEaFKn1R
	 XT7hcY3W4ombhoU1eQRnUiWna7kINk+MCuhT5DzM/ri4EYb4TuvLGm6zzme6/8mPPc
	 Y6JjgDSjGKrvE9/crN5VmMFiu9nVvFyLWLbcpoF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans P. Moller" <hmoller@uc.cl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 376/558] ALSA: line6: add hw monitor volume control to POD HD500X
Date: Tue,  8 Oct 2024 14:06:46 +0200
Message-ID: <20241008115717.090462328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans P. Moller <hmoller@uc.cl>

commit 703235a244e533652346844cfa42623afb36eed1 upstream.

Add hw monitor volume control for POD HD500X. This is done adding
LINE6_CAP_HWMON_CTL to the capabilities

Signed-off-by: Hans P. Moller <hmoller@uc.cl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241003232828.5819-1-hmoller@uc.cl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/podhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -507,7 +507,7 @@ static const struct line6_properties pod
 	[LINE6_PODHD500X] = {
 		.id = "PODHD500X",
 		.name = "POD HD500X",
-		.capabilities	= LINE6_CAP_CONTROL
+		.capabilities	= LINE6_CAP_CONTROL | LINE6_CAP_HWMON_CTL
 				| LINE6_CAP_PCM | LINE6_CAP_HWMON,
 		.altsetting = 1,
 		.ep_ctrl_r = 0x81,


