Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D38341AC
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnwtSDNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04643C433C7;
	Mon,  9 Oct 2023 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859687;
	bh=gJHOUshAXWtweUDgJaF6Q3n6dRJz0xPf7YycQUqQt0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnwtSDNJLIB7fTPR6w/FjbqW6Gd6OtRkXGbJXigNBijCKZqvDSuOiGw0G1HlJQ5B8
	 NMOtj07IqTaA0hjTyMkgBq1FULU5psRGv/41SgeJ4/yfIIzdkYvSqlvoOAbp41oi5S
	 lN0DXdMFDk1rWeWiusdlQDmcmFaRPzg9ie02095Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 64/91] media: dvb: symbol fixup for dvb_attach() - again
Date: Mon,  9 Oct 2023 15:06:36 +0200
Message-ID: <20231009130113.722507873@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit f296b374b9c1 ("media: dvb: symbol fixup for dvb_attach()") in
the 4.19.y tree, a few symbols were missed due to files being renamed in
newer kernel versions.  Fix this up by properly marking up the
sp8870_attach and xc2028_attach symbols.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Link: https://lore.kernel.org/r/b12435b2311ada131db05d3cf195b4b5d87708eb.camel@decadent.org.uk
Fixes: f296b374b9c1 ("media: dvb: symbol fixup for dvb_attach()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/sp8870.c |    2 +-
 drivers/media/tuners/tuner-xc2028.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -619,4 +619,4 @@ MODULE_DESCRIPTION("Spase SP8870 DVB-T D
 MODULE_AUTHOR("Juergen Peitz");
 MODULE_LICENSE("GPL");
 
-EXPORT_SYMBOL(sp8870_attach);
+EXPORT_SYMBOL_GPL(sp8870_attach);
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1513,7 +1513,7 @@ fail:
 	return NULL;
 }
 
-EXPORT_SYMBOL(xc2028_attach);
+EXPORT_SYMBOL_GPL(xc2028_attach);
 
 MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
 MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");


