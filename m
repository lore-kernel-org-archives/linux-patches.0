Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D622910F;
	Tue, 15 Oct 2024 13:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998067; cv=none; b=s7QH+cs12A6s6RHMtoybtm+4+EpFJ3n6PyBB/TzqhJ6Onf7Wj/QQip8/gsOsvxEZre4kWGo7mwVauzqtSzEHSTqsBF4486dDd1elJfqC4YgUMPPOGEFGowk5VnyDhSDKCngKKjavOM3J4TYCTS23tkDGwzgpLUCrv+2gip7XpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998067; c=relaxed/simple;
	bh=pucba5Lcead2tksHIcnKtVxgspNzbbsU6mjlWaL3idc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUvJx+MqO+EcusiPAoWzvYhqnOKyfJzFjcLKybHtvd/g05izqxYZlOBVlJXYc5qmW9et1Iw26QOms4ofXHPV5LoXdtUxdqOsi+/V+hTEx6e7ZyzEmgzNE5BZqvY8QY0+xIl+ghgwrtJ3Vh+lDrLI0e1b7rEBQtII+Xnc5UTvbzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HNZIMMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HNZIMMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061A7C4CEC6;
	Tue, 15 Oct 2024 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998067;
	bh=pucba5Lcead2tksHIcnKtVxgspNzbbsU6mjlWaL3idc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HNZIMMJ7NrO0rA0P4loRSu4vyKLEUE4J4RfF4IZDLFtRyADP3/R67x6LvtcMimS4
	 5nK/1ZQDTJufzBVkApbb1ParJUfcPgJ9U+6ezYi5O/hAmfEZfu5SuPtqV6GfflGhog
	 vC0ID8eP7F+L1gXA8/hnkcLisRUVTxlAppNrG5uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans P. Moller" <hmoller@uc.cl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 368/518] ALSA: line6: add hw monitor volume control to POD HD500X
Date: Tue, 15 Oct 2024 14:44:32 +0200
Message-ID: <20241015123931.177568985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


