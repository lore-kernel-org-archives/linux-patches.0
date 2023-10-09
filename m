Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6B19464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1P5FiIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D74C433CA;
	Mon,  9 Oct 2023 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857211;
	bh=Sw6ZD76MfliE/IvH2lf/lSraJQzEmotHVKeyY+2GslA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1P5FiImq3uS+BoR1yDNwi7vLheVyb7GlircQXAmstXM17d2gU4tqlT5Ozv1Hhz+g
	 PgKsJ/+j01MsPKvGhX4aKIXGQR+Z2GAy3OZlHzoUjrzbigI4N3ncg17Rc3jY2uCEDr
	 0IvHeolw+SFIw2VsWgrV5Rjqvx3ycDD3JAD44lVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 134/163] HID: sony: remove duplicate NULL check before calling usb_free_urb()
Date: Mon,  9 Oct 2023 15:01:38 +0200
Message-ID: <20231009130127.747719624@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit b328dd02e19cb9d3b35de4322f5363516a20ac8c ]

usb_free_urb() does the NULL check itself, so there is no need to duplicate
it prior to calling.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e1cd4004cde7c9 ("HID: sony: Fix a potential memory leak in sony_probe()")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index a02046a78b2da..ebc0aa4e4345f 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2155,8 +2155,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return ret;
 
 err:
-	if (sc->ghl_urb)
-		usb_free_urb(sc->ghl_urb);
+	usb_free_urb(sc->ghl_urb);
 
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.40.1



