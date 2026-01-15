Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF193D6667;
	Thu, 15 Jan 2026 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499772; cv=none; b=nxlLwSBBNu8Gfh33awbvyqZyUCs3NqJ4cI1YnYU/T58tH16my26AT9B/reKeMnvuwetPgd5/jKjDE7HR9Ji9es+UXJXBYVkLzCfmfPrPVDUE/AlJZcMOc7kE165DQIypB4J9jUvERNcBGVD3xMLxAj28ayF3+l9gcmileeefnXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499772; c=relaxed/simple;
	bh=uXkSlEpKJT+bhz9mT/4jdt97kp3Zy3dYxmpCmGVcx8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bN6fNPdhuNTo20AY7doKxORLFYmlrepVDFiFTuA2VYgjBQl+zTiEVQEdVC0yh4F+Xs9rwSB8jYMeWPm0PYb52JHN5FMsdRn+gFjk54HDGE4QeycbLxNwkthJuKlTtJjzBsDL1ZtG3DruHx2gusGtVnXZ+UdXHKV85vw14zl041Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j448IytZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j448IytZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22A5C116D0;
	Thu, 15 Jan 2026 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499772;
	bh=uXkSlEpKJT+bhz9mT/4jdt97kp3Zy3dYxmpCmGVcx8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j448IytZoCbE7iMlfk4bJDvOXNdbpR8YH9pYfUcKsZ+NgjW8Vo28ZtIKAwDYd13hg
	 sKMaMmWLtXbQUQiqrCT7lLEFQBxetAHEh/1U0/oP5VRiFvdzI0QpBph6z55/GwWToU
	 ZaIojZsfdhVwZmO160QEjnuzjiHbwVD3QsZiIaAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 311/451] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Thu, 15 Jan 2026 17:48:32 +0100
Message-ID: <20260115164242.151053855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hitz <christian.hitz@bbv.ch>

commit 5246e3673eeeccb4f5bf4f42375dd495d465ac15 upstream.

LP5009 supports 9 LED outputs that are grouped into 3 modules.

Cc: stable@vger.kernel.org
Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christian Hitz <christian.hitz@bbv.ch>
Link: https://patch.msgid.link/20251022063305.972190-1-christian@klarinett.li
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -57,7 +57,7 @@
 /* There are 3 LED outputs per bank */
 #define LP50XX_LEDS_PER_MODULE	3
 
-#define LP5009_MAX_LED_MODULES	2
+#define LP5009_MAX_LED_MODULES	3
 #define LP5012_MAX_LED_MODULES	4
 #define LP5018_MAX_LED_MODULES	6
 #define LP5024_MAX_LED_MODULES	8


