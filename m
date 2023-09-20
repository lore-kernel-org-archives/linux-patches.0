Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8BE544
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3777AC433C7;
	Wed, 20 Sep 2023 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211750;
	bh=D6U8glx+io/KriHRY+V+/qmiFOq4+ssFGgR2SdGbGn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a043XTmg/rlP10GqtrxJ1D/DcrTU9jl2qNLs30+F7QmwscHwAo6Avdlbf7M8I8pwU
	 biYiM3GfRLLEMROMggH7vNEm2+cGfOizxtxYhEHamAH/CHRrD3vfDcAw4+k78L1+so
	 aGAo9fQm2/CKT74CMUjgBMwamNB2thJ893NvgjKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Joshua Kinard <kumba@gentoo.org>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4.19 004/273] rtc: ds1685: use EXPORT_SYMBOL_GPL for ds1685_rtc_poweroff
Date: Wed, 20 Sep 2023 13:27:24 +0200
Message-ID: <20230920112846.574591938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 95e7ebc6823170256a8ce19fad87912805bfa001 upstream.

ds1685_rtc_poweroff is only used externally via symbol_get, which was
only ever intended for very internal symbols like this one.  Use
EXPORT_SYMBOL_GPL for it so that symbol_get can enforce only being used
on EXPORT_SYMBOL_GPL symbols.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Joshua Kinard <kumba@gentoo.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ds1685.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1630,7 +1630,7 @@ ds1685_rtc_poweroff(struct platform_devi
 		unreachable();
 	}
 }
-EXPORT_SYMBOL(ds1685_rtc_poweroff);
+EXPORT_SYMBOL_GPL(ds1685_rtc_poweroff);
 /* ----------------------------------------------------------------------- */
 
 


