Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874228F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA63C433C7;
	Sun, 16 Jul 2023 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538186;
	bh=h7wSZcCXv4nXf65tj7RLqZPvATNaJNRzTCdnu8XReZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1uT5TuLolMnG3J/Gjt9+u3G1wfcyL0Y+40UZST5H3yR9a93La9YyH1DFfe/4XPCe
	 8X4rsxuI24hwsqAz5ZkaGUiZGHUMRAQSnXlwQ3EAs6/PFcUjTHMebFITSZ7u4iw01p
	 UXk9aiIQBfOndT/+hJPkRrLnQ0iXBywaXbb24Asc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 362/800] ARM: dts: BCM5301X: fix duplex-full => full-duplex
Date: Sun, 16 Jul 2023 21:43:35 +0200
Message-ID: <20230716194957.487491561@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit fd274b733bfdde3ca72f0fa2a37f032f3a8c402c ]

this typo was found by the dtbs_check
| ports:port@5:fixed-link: 'oneOf' conditional failed,
|  {'speed': [[1000]], 'duplex-full': True} is not of type 'array'
| 'duplex-full' does not match any of the regexes: 'pinctrl-[0-]..."

this should have been full-duplex;

Fixes: 935327a73553 ("ARM: dts: BCM5301X: Add DT for Meraki MR26")
Fixes: ec88a9c344d9 ("ARM: BCM5301X: Add DT for Meraki MR32")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://lore.kernel.org/r/50522f45566951a9eabd22820647924cc6b4a264.1686238550.git.chunkeey@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts | 2 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm53015-meraki-mr26.dts b/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
index 14f58033efeb9..ca2266b936ee2 100644
--- a/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
+++ b/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
@@ -128,7 +128,7 @@ port@5 {
 
 			fixed-link {
 				speed = <1000>;
-				duplex-full;
+				full-duplex;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
index 46c2c93b01d88..a34e1746a6c59 100644
--- a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
+++ b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
@@ -187,7 +187,7 @@ port@5 {
 
 			fixed-link {
 				speed = <1000>;
-				duplex-full;
+				full-duplex;
 			};
 		};
 	};
-- 
2.39.2



