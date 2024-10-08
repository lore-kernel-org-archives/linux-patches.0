Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B6EEC8;
	Tue,  8 Oct 2024 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390536; cv=none; b=jZ9eNpAu1hEstmfoF1QS9otBKox9mMxu++E56y8T/kt5HZg3q3Qi+cJZ70SjIMin923i9lP/lGMJiltRyoZTYtMMXwe+K/J/yJ6xkWi1bzAdvwHWAo3QszJtlR1srEFll+Oy1MPHSAcJ00qcJjtVpUwGDHRgFuWyDGecl0kKMxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390536; c=relaxed/simple;
	bh=YbpIGsGblL6+nKZkODa70iJNVwCyKKI1bOMkEWgouYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKeHxIIHlhthR/lCoI0uiPMHQA+xIQdr9W0MIr4PnHqAYuhvKlfO1B95B8/BWLwPD0TpfI01ZMe2tdZYqc7EGr6BpQDZRXSQEtqbp0Yph69r6FuZVCnVOfCaaEKzLmhAD+rn0M8fS3WPO75OmQhegkHdQDveVJnf8dDSbwZ83Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUE100TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUE100TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A39C4CEC7;
	Tue,  8 Oct 2024 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390536;
	bh=YbpIGsGblL6+nKZkODa70iJNVwCyKKI1bOMkEWgouYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUE100TU3xBtbMQuVrnqN0wPVWv3FKiK0h+UQBi0eeNQF8cNJVTNvreUf1kQLGzdH
	 iLOf9dcICit7C5fhvCWZj0fcB9vkGaBh/OSdBZck2MKoZbqLeM3x3NWrI7IzPgUJHi
	 POwobMfVCRliKtKV5AE86oRiZ54So139Ga0t725o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans P. Moller" <hmoller@uc.cl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 318/482] ALSA: line6: add hw monitor volume control to POD HD500X
Date: Tue,  8 Oct 2024 14:06:21 +0200
Message-ID: <20241008115700.946316542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


