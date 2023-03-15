Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F84431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CD0C433EF;
	Wed, 15 Mar 2023 12:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883195;
	bh=u66U3m65PJqVDS28/79g2IDAVlH3OBmhN84cHiMjyqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZvu78Ey9Uiquu99PcOyrmJt7SVuf+S1+PonKiIeD8dcO3+vyB8JztjACbN5J+SnQ
	 Zuk1IjrO5na7m5pwGZl6QrEfNBSn84E5PdhxmjeWb34QgLs4rm+zT+Ikn0dQF68rPe
	 brT8VCDxl8MBZ88yZPVd1EsubrdNh2zDWJ0/ZyUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/145] powerpc: dts: t1040rdb: fix compatible string for Rev A boards
Date: Wed, 15 Mar 2023 13:11:58 +0100
Message-Id: <20230315115740.769171987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ae44f1c9d1fc54aeceb335fedb1e73b2c3ee4561 ]

It looks like U-Boot fails to start the kernel properly when the
compatible string of the board isn't fsl,T1040RDB, so stop overriding it
from the rev-a.dts.

Fixes: 5ebb74749202 ("powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
index 73f8c998c64df..d4f5f159d6f23 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
@@ -10,7 +10,6 @@
 
 / {
 	model = "fsl,T1040RDB-REV-A";
-	compatible = "fsl,T1040RDB-REV-A";
 };
 
 &seville_port0 {
-- 
2.39.2



