Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF6614A85
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C0C433C8;
	Mon, 26 Jun 2023 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804304;
	bh=lCWJKD76psD+3yaHMyASNE7r59nJvshmND+wnZIW4Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WALIXij9X3EPTaa+ijAthxAcVXMafNxG3NlCZQ4XkHK+XLmPNMH9raiIJ66flBdQb
	 IoRxw9Dr6V47QHldA2Qwjr167GrEuFeDXegY45Oa0NDvjmHhhPi8LKAfMELNSgRv8R
	 1acCvZjwjFMF/ODBg/PslY2JMC/Ap4bljKd9a+FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/170] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date: Mon, 26 Jun 2023 20:10:52 +0200
Message-ID: <20230626180804.316789288@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit ee9a113ab63468137802898bcd2c598998c96938 ]

This change allows adding additional files to the xfrm_interface module.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20221203084659.1837829-2-eyal.birger@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: a287f5b0cfc6 ("xfrm: Ensure policies always checked on XFRM-I input path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/Makefile                                    | 2 ++
 net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (100%)

diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 494aa744bfb9a..08a2870fdd36f 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the XFRM subsystem.
 #
 
+xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface_core.c
similarity index 100%
rename from net/xfrm/xfrm_interface.c
rename to net/xfrm/xfrm_interface_core.c
-- 
2.39.2



