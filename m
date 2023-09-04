Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3922C23A0
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3570FC433CA;
	Mon,  4 Sep 2023 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852278;
	bh=fYPMrGGZhW6UK/qAMnqpY2Za9OJy+JxpK4Q0JLbLRR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5wb1jZyLJra28y3irYAouaiHtHt5tS91XSlzdSEXXXH1pTSaWXmQeb4m47rMh99u
	 KZYcyQx/C2vJtfJqPT1gmKxZW5jp3ISk9ZVrmT/ICdCkaPJ5b5uPbCwctwMYQSB9At
	 hij/N33XA0BXMhrMka/5PE8IOxwJG/fw5uhJLMnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Joshua Kinard <kumba@gentoo.org>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.5 10/34] rtc: ds1685: use EXPORT_SYMBOL_GPL for ds1685_rtc_poweroff
Date: Mon,  4 Sep 2023 19:29:57 +0100
Message-ID: <20230904182949.062298527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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
@@ -1432,7 +1432,7 @@ ds1685_rtc_poweroff(struct platform_devi
 		unreachable();
 	}
 }
-EXPORT_SYMBOL(ds1685_rtc_poweroff);
+EXPORT_SYMBOL_GPL(ds1685_rtc_poweroff);
 /* ----------------------------------------------------------------------- */
 
 


