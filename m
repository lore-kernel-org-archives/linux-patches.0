Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D678C9C;
	Sun,  7 Jun 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826800; cv=none; b=ZH16bs1LjYVEkY1K9+I1dwxv6z+NWrSB1zsGAXUo1LAw3lt0sPRkgxPkxFi0afe9YlUFmgnVEYA7ZkuRRNgPipI5kN15pmtloqVLlRBtQcZ8w2qnwnclpwMKpWufwqq9brvfvVEathNCmPah/KPfjunh4TFw1WWCsHs9N81fUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826800; c=relaxed/simple;
	bh=YimbhDMft4ucu5O+vVtOM0YxzHGdRhHnMDKiGmhpuVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWA8CZmwBJRVjKq0z3GWd7DnAWw13zDOc1k+92NGXGP2PnUbLq1W47GW6LJKko43jL102f6NOblSTqZ42hvUkTp/G2jYSVOuF2bvQ2ajtK4QyC3ZUELJyEaKhdQqU9Q9GbfXf67NqTy+v9h9Yr+7bCXuAgnVlH9Jd5xcW5GrKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zbr4sd/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zbr4sd/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3561E1F00893;
	Sun,  7 Jun 2026 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826799;
	bh=Kg4ZDozu1nyjBOVQvvP4+6n+6AYpkXjfaEFPAuPhqWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zbr4sd/iGlv+uhaIHRToObTpEn1Xju5nJVuS2QlxGfVNDaCvknZso3NrN88Bseb3U
	 Wz1CPiBP4kLwjO3dBXMwcEGJV007dc0Hj+EXq3YGw1mPhf/JdUyW6lONoc8MWrK/y6
	 Voa9v9sWatNeXnGTln79qydAEOZTb0VaRkpub6uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Kai <lukace97@outlook.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 012/332] HID: remove duplicate hid_warn_ratelimited definition
Date: Sun,  7 Jun 2026 11:56:21 +0200
Message-ID: <20260607095728.475609439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Kai <lukace97@outlook.com>

[ Upstream commit dd2147375a8fe7c5bc3f1f1b1d3a9567c26faefa ]

The hid_warn_ratelimited macro is defined twice in include/linux/hid.h:
- first one added by commit 4051ead99888 ("HID: rate-limit hid_warn to
  prevent log flooding")
- second one added by commit 1d64624243af ("HID: core: Add
  printk_ratelimited variants to hid_warn() etc")).

The second definition is correctly grouped with other ratelimited macros.
Remove the duplicate definition.

Fixes: 1d64624243af ("HID: core: Add printk_ratelimited variants to hid_warn() etc")
Signed-off-by: Liu Kai <lukace97@outlook.com>
[bentiss: edited commit message]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 101e05acf931a5..c9e0ebe9c75270 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1284,8 +1284,6 @@ void hid_quirks_exit(__u16 bus);
 	dev_notice(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_warn(hid, fmt, ...)				\
 	dev_warn(&(hid)->dev, fmt, ##__VA_ARGS__)
-#define hid_warn_ratelimited(hid, fmt, ...)				\
-	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_info(hid, fmt, ...)				\
 	dev_info(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_dbg(hid, fmt, ...)				\
-- 
2.53.0



