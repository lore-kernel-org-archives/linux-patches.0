Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C38847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7BDC433EF;
	Wed,  1 Mar 2023 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694240;
	bh=oED7abGEiQB8tTHBCqBWLGBbdyjpI8DaV3OZMQni0Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vif6t2t7GyrDTMH/xHR0dYj1IHVUN44Dsg8MNyAoKFjNbOKsuahJiRgoZutWNJT2I
	 mxau4vpMol9/wLM5iagiysx6vf7LlxtPpWUIcnuaUWpp6jevJQVQ/6BV6CH1k8pBIR
	 At6uLSjcVbzqDP6eysBsFrso1Wg/Nv6tTciZ02DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 5.15 13/22] staging: mt7621-dts: change palmbus address to lower case
Date: Wed,  1 Mar 2023 19:08:46 +0100
Message-Id: <20230301180653.181926989@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit efbc7bd90f60c71b8e786ee767952bc22fc3666d upstream.

Hexadecimal addresses in device tree must be defined using lower case.
Change missing one in 'gbpc1.dts' file.

Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20211019102915.15409-1-sergio.paracuellos@gmail.com
Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-dts/gbpc1.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/mt7621-dts/gbpc1.dts
+++ b/drivers/staging/mt7621-dts/gbpc1.dts
@@ -19,7 +19,7 @@
 		bootargs = "console=ttyS0,57600";
 	};
 
-	palmbus: palmbus@1E000000 {
+	palmbus: palmbus@1e000000 {
 		i2c@900 {
 			status = "okay";
 		};


