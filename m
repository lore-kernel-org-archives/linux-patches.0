Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95B15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB36C433C1;
	Tue,  8 Nov 2022 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916876;
	bh=gD3ceGq7VxYCWxbnAF5UEbqxlhsg22Z2XwChZIQH6Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GO1alHXGGsczdRG0XwJ4/Cvk34v6NHFJyNiAFstZq4J13stW8VWpGEBx3TxFqzuJi
	 R93Zcenmce6lf1HugZOSW4gcTQoxOFqE8tmkQRpu9CKEitb7vCHYaWmLa/WDK7GH8N
	 aXvDTvZmjHugclybLgCC94CecWF5hp6vqbyfLnis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 6.0 162/197] parisc: Export iosapic_serial_irq() symbol for serial port driver
Date: Tue,  8 Nov 2022 14:40:00 +0100
Message-Id: <20221108133402.303744385@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
@@ -866,6 +866,7 @@ int iosapic_serial_irq(struct parisc_dev
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 


