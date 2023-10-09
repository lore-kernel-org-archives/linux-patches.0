Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2561A5BA
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In9VJLvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ECEC433C8;
	Mon,  9 Oct 2023 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858052;
	bh=+QHkD19/qvA/zkRbupONG2r3g67gkOvQZotRX8KjZ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=In9VJLvswC37WAD/9ppHNtKmxodAyjqS7jkdALMsbdce7YCmE5YmQXPF3i7DcJ6qu
	 4rqI0wCoL7ikNh7zzhs2j0/6kR8EpbHSaRgNETVyUwfk19Jh3hiNg+LxEFFIx0Yyby
	 qNHSl4qIaRceUZRouoyIPhO9ImZs9rtb3YW8qULU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/75] HID: sony: remove duplicate NULL check before calling usb_free_urb()
Date: Mon,  9 Oct 2023 15:02:23 +0200
Message-ID: <20231009130113.395538727@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3ab18811b0090..c330d5a20ca04 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -3074,8 +3074,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return ret;
 
 err:
-	if (sc->ghl_urb)
-		usb_free_urb(sc->ghl_urb);
+	usb_free_urb(sc->ghl_urb);
 
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.40.1



