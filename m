Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620C42528FD;
	Wed,  5 Mar 2025 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198165; cv=none; b=aDGkXePc/l5BsLEuxz8AVQY9EU4rg3IO4IZLx5R888DM+T3T1/pUd+K2+koCycqW23F+qhirAXWhECiN8FXlPsxk+dXLwO1tYDEydMOQS/qtLZhLQW0mC/3OzZ9JYqBZCxUU4R7xldG6erW6b1QNt0F4A6CLUkd/hs6SHSJ4AsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198165; c=relaxed/simple;
	bh=9+J4qV/NtRm1tgvAIQCFUwvRp44NJWAyD54QIerqPFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOHBoO8XJky36dpOQxUwX8HbOnwaW5G7DN4Hhrvl22933xw9sv9w7Z/SRfHq40zwaIz14mukcAuhH1cZu7v2G9MoILbfkCzw6pzsaadWsHPtzp9VYFY+BidGatBu+WXagqaqLEt5CGY8EPyveIiNyshfee8au4eUen1JCwHrQK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=di9eH+BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="di9eH+BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8F9C4CED1;
	Wed,  5 Mar 2025 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198165;
	bh=9+J4qV/NtRm1tgvAIQCFUwvRp44NJWAyD54QIerqPFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=di9eH+BUJsmQYLZUdrXHYYYfPf6ilL8b0EfJw7Spe/T1fRS+6UIthMmurIpH1mCGV
	 ceVaIyPHbx6wUifmoIZUsSwUdtD9EKxHkLMW/WuRcVEoWyAYEEwWgFonLsRut3ylAN
	 kV+gts9313NAw/t6ddVmd8m2hxD62zTwHdVT1clk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 087/150] ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2
Date: Wed,  5 Mar 2025 18:48:36 +0100
Message-ID: <20250305174507.308964328@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Dmitry Panchenko <dmitry@d-systems.ee>

commit 9af3b4f2d879da01192d6168e6c651e7fb5b652d upstream.

Re-add the sample-rate quirk for the Pioneer DJM-900NXS2. This
device does not work without setting sample-rate.

Signed-off-by: Dmitry Panchenko <dmitry@d-systems.ee>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250220161540.3624660-1-dmitry@d-systems.ee
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1868,6 +1868,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
+	case USB_ID(0x2b73, 0x000a): /* Pioneer DJM-900NXS2 */
 	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
 		pioneer_djm_set_format_quirk(subs, 0x0082);
 		break;


