Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8C115CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF48C433D6;
	Tue,  8 Nov 2022 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915200;
	bh=epfwt4R+Vqb2uPFXpJPcuM80qjAyy3Lx/TZgZKiqD3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUkyaMN5/AO8fY7nkg9a6joalRtq4YkttM7AJ48n9ixCG9/eRXSBWDbXsw7HxAHXZ
	 FDs32V/7lYv4habhkz1g0O4NBmfDCYh2E/n6U1moNb6dm18or9G8Iq2w2zOB7RC5VB
	 5zoGUgqILoOCP+gKbmf++1VAvT+ypW3YviaLm6pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 4.19 40/48] parisc: Export iosapic_serial_irq() symbol for serial port driver
Date: Tue,  8 Nov 2022 14:39:25 +0100
Message-Id: <20221108133330.978772900@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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
@@ -889,6 +889,7 @@ int iosapic_serial_irq(struct parisc_dev
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 


