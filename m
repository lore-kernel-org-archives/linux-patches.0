Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E864B2D0C75;
	Sat, 12 Sep 2026 11:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212952; cv=none; b=LJU42w7FSRRxERvufOiaK0Xo/mc0Zfjr9qZ+ES8RzzoE6bw+5fQKsFHSR5ypFrjszy7rWSELQdOjn6RdHhH0cA6xQfs3bEBL9XbC8YFM1+Ipv3Y9u4HEvW6S63wP0ewPElU5UKKUzp4Zv7FHonwNYcQYjuXdV/auNZZo+YQ1k4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212952; c=relaxed/simple;
	bh=z+ENEPP2T4eVHz7GUTN/S8dktWUqfNRpywoDjGr55sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvwVrdCrD2PpoiSKqD2vQs775F/cBdOMCphTWmYX933Aqdh0wCKFBryNaiaryF0VCwaCQPMDd9zCswwVbDVKOAL9Ag+QpDN+qRWGls5hAHs83VMQvat4J3jcpKBtkbctebYd1psSQ+8S/g5nKet/fo1uV5FjBYl+Sb0kjniTnw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQUgTpni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQUgTpni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8614F1F000FF;
	Sat, 12 Sep 2026 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212950;
	bh=302asN1Z5u6/sQOMn36uS0F5dggvieLno9eb5R3wU7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQUgTpniBNF57S63gtNbkupioPDqF+41B5seyR+y++tEg8kuUcfYor9gjPEKdRGf6
	 TnNZoLskKsRVsFOHHdxk/M1/1ggTWfwhQg0floe+Mtuq6dSlUnvIm/KBPGJHbp7kMB
	 Doh3V/bVKMhoHRJrqfXLWHOpFzSBRChW7zE3B+nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 0022/1376] usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()
Date: Sat, 12 Sep 2026 08:40:48 +0200
Message-ID: <20260912065608.043280382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2961,7 +2961,7 @@ EXPORT_SYMBOL_GPL(fsg_common_create_lun)
 
 int fsg_common_create_luns(struct fsg_common *common, struct fsg_config *cfg)
 {
-	char buf[8]; /* enough for 100000000 different numbers, decimal */
+	char buf[14];
 	int i, rc;
 
 	fsg_common_remove_luns(common);


