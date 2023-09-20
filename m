Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E393B30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C70CC433C8;
	Wed, 20 Sep 2023 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212694;
	bh=W4nBeTGF6fs11W4fGHE8v54otcEsIuJxkvdyCmcYNGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBVCc0ao39w14vr5Uk7BKnR7YFkMOLnjL4UtJFGxaw1hLPG4aC07A3g107WbDvDbq
	 /xaqlUmFOuShwhHzDaABvY3SIiqspTQVKy/saO4n3r9LbK/+TzLE2uZ4IpdTfcBOd4
	 V1MAMw2kyO38bMqoShYOH8IA6zli19UkQK8Qfcdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Joshua Kinard <kumba@gentoo.org>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.4 005/367] rtc: ds1685: use EXPORT_SYMBOL_GPL for ds1685_rtc_poweroff
Date: Wed, 20 Sep 2023 13:26:22 +0200
Message-ID: <20230920112858.626806001@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1437,7 +1437,7 @@ ds1685_rtc_poweroff(struct platform_devi
 		unreachable();
 	}
 }
-EXPORT_SYMBOL(ds1685_rtc_poweroff);
+EXPORT_SYMBOL_GPL(ds1685_rtc_poweroff);
 /* ----------------------------------------------------------------------- */
 
 


