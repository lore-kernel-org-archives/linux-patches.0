Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBF4200A5;
	Mon,  6 Nov 2023 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsN8uhNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E54CC433C7;
	Mon,  6 Nov 2023 13:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276249;
	bh=i3/F69MfDFVt2rmPYaTg33vOeCIeGt3JajqFI+DJHx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsN8uhNPjNSYJlAi04ZT9F8S4CmEKj6jyRfJcNNAAEoyVKbabinhBfTLcCdrnpLF6
	 6znRq9MyiHR2HV3FkJofV2DRch16HTUBeKlnDMXqA0Pz4+Zme1r3AefvSsGIXeDzca
	 0q7Nj0FzpJT97j9nNBj/r6MvK9ARF7L0WAGDLzjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	nic_swsd@realtek.com,
	"David S. Miller" <davem@davemloft.net>,
	netdev@vger.kernel.org,
	Denis Efremov <efremov@linux.com>
Subject: [PATCH 4.19 41/61] MAINTAINERS: r8169: Update path to the driver
Date: Mon,  6 Nov 2023 14:03:37 +0100
Message-ID: <20231106130301.036417515@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

From: Denis Efremov <efremov@linux.com>

commit 0a66c20a6a123d6dc96c6197f02455cb64615271 upstream.

Update MAINTAINERS record to reflect the filename change.
The file was moved in commit 25e992a4603c ("r8169: rename
r8169.c to r8169_main.c")

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: nic_swsd@realtek.com
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -182,7 +182,7 @@ F:	drivers/net/hamradio/6pack.c
 M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/realtek/r8169.c
+F:	drivers/net/ethernet/realtek/r8169*
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>


