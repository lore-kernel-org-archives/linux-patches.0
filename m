Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB9015CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326FCC433B5;
	Tue,  8 Nov 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915826;
	bh=D0jJIemx6fqoLQzv6MyEpZjQy3nqd7ClP1DdBqbamak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWj2nsOi3ylBWXoeQVOEb88VrvrJgrUrioF+PjwjsLfYmVXVjghhJxSkJfwLx5LSD
	 Zh0Oj0/gzucZ+/bnhg5qFenqYwp1GoxdfqZYC4JLO3zoyHcoGo9tRF5mMjgrKRhCXh
	 vR4Y8mLk1reuhBvdI47VDz3R3M2PLpwSX8ApbmSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 102/118] parisc: Export iosapic_serial_irq() symbol for serial port driver
Date: Tue,  8 Nov 2022 14:39:40 +0100
Message-Id: <20221108133345.152513700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit a0c9f1f2e53b8eb2ae43987a30e547ba56b4fa18 upstream.

The parisc serial port driver needs this symbol when it's compiled
as module.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/iosapic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -875,6 +875,7 @@ int iosapic_serial_irq(struct parisc_dev
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 


