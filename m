Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE615683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA3C433D2;
	Mon,  3 Apr 2023 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531263;
	bh=N9CUN0PygrK7ljgrPQ4Jem6IAB6ahT7pNwV1E4Mzm3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcYPBj5YThJUF60s3iToUWfJNGDr6ijpKaEi4TU9tIFm6d49QzQIoldBvWihw4MTx
	 K/1WsabclYhFZN+VVc/TvJBKg6KASpj1O9ecqdDi4oRp+yzPieef3E4snpSIZL4qA8
	 YSF1wOgyEljPs5zXMfcWZZ4pEeqH9qoxke7yWVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 63/66] usb: host: ohci-pxa27x: Fix and & vs | typo
Date: Mon,  3 Apr 2023 16:09:11 +0200
Message-Id: <20230403140353.973996550@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0709831a50d31b3caf2237e8d7fe89e15b0d919d upstream.

The code is supposed to clear the RH_A_NPS and RH_A_PSM bits, but it's
a no-op because of the & vs | typo.  This bug predates git and it was
only discovered using static analysis so it must not affect too many
people in real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20190817065520.GA29951@mwanda
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-pxa27x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -147,7 +147,7 @@ static int pxa27x_ohci_select_pmm(struct
 		uhcrhda |= RH_A_NPS;
 		break;
 	case PMM_GLOBAL_MODE:
-		uhcrhda &= ~(RH_A_NPS & RH_A_PSM);
+		uhcrhda &= ~(RH_A_NPS | RH_A_PSM);
 		break;
 	case PMM_PERPORT_MODE:
 		uhcrhda &= ~(RH_A_NPS);


