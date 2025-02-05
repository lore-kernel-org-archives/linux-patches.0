Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF9915198D;
	Wed,  5 Feb 2025 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764190; cv=none; b=PJ5wXPD5ntJxuO9edWaTqSs/2Uza7CWU0L/qsH6QR3g36xgZC+osevW0cNqzKqkls3Ivf8H25Xlj05ybsqKaIWOlG1TYyN2HN5YAQzVjDR0UjREZF0i13spMw3o3DWqfrPvAEu+rTfHSYCggvJMdLSGyBYaD4txwIOjsu/jnx4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764190; c=relaxed/simple;
	bh=cwWf0AI7PuC688cYSRcA0l06Mg+VtCAREJsqS17Cg5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6Tf2qJPwmEcwN6D4uNRUG1QJxv789dSp6Hq1YvGb7E4AjSAgHxh9IgAHNUXKMZwGbYTVf2tsVMxlWSN+yghiMVX9Ysh/BaxsH1zBIEGtySt4GdUlpeUDHZio8T7izbf/eZsBpk+UFOPdulTh3Z29FVTQBfvB8TeLYPENeey6E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovmQu5m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovmQu5m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EFFC4CED6;
	Wed,  5 Feb 2025 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764190;
	bh=cwWf0AI7PuC688cYSRcA0l06Mg+VtCAREJsqS17Cg5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovmQu5m/YsdAx9cmm0n4k1LlMjEYR79RqwpXUCXZgJt5ZN1YwCLNNLJxo/TaEUuQc
	 2zA/9Y4X8iFdxGLuBMWV4jwgIrsLKeKtzidUs+Nqln6yG2shQ5v3b5r5GJ7cDsdLZZ
	 CmxDFy6CWj6Gj6DPMUeRZjWgxoPGEYMV9T7+wv3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/590] HID: multitouch: fix support for Goodix PID 0x01e9
Date: Wed,  5 Feb 2025 14:37:32 +0100
Message-ID: <20250205134458.967352065@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 8ade5e05bd094485ce370fad66a6a3fb6f50bfbc ]

Commit c8000deb68365b ("HID: multitouch: Add support for GT7868Q") added
support for 0x01e8 and 0x01e9, but the mt_device[] entries were added
twice for 0x01e8 and there was none added for 0x01e9. Fix that.

Fixes: c8000deb68365b ("HID: multitouch: Add support for GT7868Q")
Reported-by: He Lugang <helugang@uniontech.com>
Reported-by: WangYuli <wangyuli@uniontech.com>
Reported-by: Ulrich Müller <ulm@gentoo.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d1b7ccfb3e051..e07d63db5e1f4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2078,7 +2078,7 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.39.5



