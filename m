Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010D238AC92;
	Sat, 12 Sep 2026 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227898; cv=none; b=F6NCJM62EMMHXWuBUJllgtrFXVrc6cWQdA8RIVsdl4KSRlPegumWV5D26FEvCPnLIQ6X1hLEEXeQLehih7Om6RlpF92jHPftKxHepq165ZzJK8hTI15czEZfgueA+E4ay1gktwEghlsXZgtq1fr4rGMzjbV5wJXe5BTv8efnIf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227898; c=relaxed/simple;
	bh=Pb/4WoI02urSMmN2URGqmRy2n6d8gsIiBhItF66Ty+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7a+VXQ8lXTCiueszgdOinUUA4D5ot4nXDNVbcFaTN5zI8nTtCvrlMhM7kjnRJtIZ2S2rMmp5GilxnR40zY2sm+BpT1VkhfGQ9ujTL05faWK/gJX2rMom9876OAQ4zTACM0GiP9v9UR5ozJ0YP0YCCqJIw3Cwqjr1g3hGeKs/VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD/2K2LH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD/2K2LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D58D1F000FF;
	Sat, 12 Sep 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227896;
	bh=ty8ECq1KKVTAWzN4aFRNTPEXbgI4QlS3FbRF7uUkLP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SD/2K2LHAfNPKwvhIjXNNxyNdCd+ue68dHzYun85PqM+i1i/ipUUw/+HJ60eOdakp
	 f2yeAb5QxfoEeAoF/vk9//vPTHCRZb8ZTlLkK0OPW/Gm+I8LWzotcnUi0XmfMu5Epw
	 KRRmknfr/kLAgzlSXXpNpY2UjywJZ47bVXYGygBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 0274/1191] usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()
Date: Sat, 12 Sep 2026 08:50:02 +0200
Message-ID: <20260912065554.380278863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9f6f095beec82a80daa666a3b2186a5b95841e9a upstream.

GCC (Debian 14.2.0-19) is not happy about the buffer size:

drivers/usb/gadget/function/f_mass_storage.c:2970:48: error: ‘%d’ directive output may be truncated writing between 1 and 9 bytes into a region of size 5 [-Werror=format-truncation=]

Bump the size to get it enough for all possible values.

Note, although cfg->nluns is limited to FSG_MAX_LUNS (16), the compiler
doesn't realize this and complains about the buffer size.

Also note, the existing comment is wrong as size 8 for the whole buffer
doesn't cover 100 mil numbers, hence drop it altogether.

Fixes: b27c08c953e9 ("usb: gadget: f_mass_storage: create lun creation helpers for use in fsg_common_init")
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260817161239.1448582-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2964,7 +2964,7 @@ EXPORT_SYMBOL_GPL(fsg_common_create_lun)
 
 int fsg_common_create_luns(struct fsg_common *common, struct fsg_config *cfg)
 {
-	char buf[8]; /* enough for 100000000 different numbers, decimal */
+	char buf[14];
 	int i, rc;
 
 	fsg_common_remove_luns(common);


