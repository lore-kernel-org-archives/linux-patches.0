Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037603;
	b=qwpeUgM8qGWjeZvrhDVvGnUxcFkpKsQaD8HOrAgh9CE/ogGScwQoMtcCfRygzLpsOsV3
	 4Bw3jzVXiFsuisGo9ePXOcV0KG19Bhsudh7CXLej89WZBpjxJaB1Gl5OOkbP7CrXeDU6W
	 8r0DuogpEQNrxL4jtTKxqMaHFIW+2x6Q/H8sUZNnVVE6B6ss6Vi+263/BMZx9g+0cS8rM
	 3WSUOIwPwWTG1Ayoa6T1zux0iJO3LGSw+LwXv01Ff/vBdr0/dYf95zUhJAZWgOHhao8CW
	 CQ//UQ0B3X8JFq/RDHOL3/KkLfzWEa0jeUDe5n286/kGBfeqqvPex7arjExZXldpwvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9w+TsiEiiMiQriKgsH7oU/EoqhL0stcKp9UUmiv8P0o=;
	b=3ljg06rCGY89n+aucniHlPnweg8R+kn8Nj8Euddci3V2Lff+FSSyPEuBgPiacgdT49rD
	 +nM8IK7mdVT7NENJUdJqU2EMayU2BxBgipOIDTxJdTzQnm99Z3gE+aZWmmn8SJKD3pJ2n
	 fYWsgcS1ODMS+jG02CHSbZUyLl4+d1rpeeW3H6tIep41bgLRoczIqe6pD8vOXIqs+79Zk
	 TnieTlKIXkdsGePbcR1H36iSYjh1Jp1LuuS4S/ea0FKJCDH3GmvhVTRmUpRKHr/ag67WD
	 I/ygxSIq70CrO73iKYg4IZR6yU82i/Zn+J1HhzKd+T0Yf9Ad3sUo3FvrHs4nMsUPe+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNUoWJ5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC9606A32A;
	Wed, 18 Nov 2026 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNUoWJ5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488D51F000C4;
	Wed, 18 Nov 2026 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037602;
	bh=9w+TsiEiiMiQriKgsH7oU/EoqhL0stcKp9UUmiv8P0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNUoWJ5VLZxzYB0Iqqp5xzyAAaHq3cRoPhEA4ifQ4sHJ/Tah1bqHwqauvBIA3nz0g
	 SHDNLTWsMoOHOqYAqA1z5AqirJktRiRTpdZHQoIjtJ8M79AB34pb9dS1mTfJ+QystJ
	 zEs1YDiqpEGDO2/hwVqBxRuZKNBBJb3+JF1zdsbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xia Yan <yana06070@163.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1454/3318] veth: keep carrier off when resizing channels with a down peer
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118150404.479721764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yana06070@163.com>

[ Upstream commit 2d02191779345b13de91048db441191b20264d16 ]

veth_set_channels() temporarily turns carrier off while reconfiguring a
running interface. It then turns carrier on for both ends without
checking whether the peer is administratively up. If only one end is up,
changing its channel counts therefore reports LOWER_UP even though the
peer remains down.

For example, after creating a pair with two RX and TX queues per end:

  ip link set vca up
  ethtool -L vca rx 1 tx 1

vca incorrectly reports LOWER_UP while vcb is still down.

Only restore carrier when the peer has IFF_UP, matching veth_open().
The local interface is already known to be running at this point.

Found during LLM-assisted source review and reproduced with a veth pair
in network namespaces, without kernel instrumentation or error injection.
The companion veth.sh test reproduces the two mixed up/down failures
before the fix and passes after it.

Fixes: 4752eeb3d891 ("veth: implement support for set_channel ethtool op")
Cc: stable@vger.kernel.org
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Xia Yan <yana06070@163.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261029024259.3700-1-yana06070@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 06171a3deb9fe..6766e1381650d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1393,9 +1393,10 @@ static int veth_set_channels(struct net_device *dev,
 		 * to identify the range we have to disable
 		 */
 		veth_disable_range_safe(dev, new_rx_count, old_rx_count);
-		netif_carrier_on(dev);
-		if (peer)
+		if (peer && (peer->flags & IFF_UP)) {
+			netif_carrier_on(dev);
 			netif_carrier_on(peer);
+		}
 	}
 
 	/* update XDP supported features */
-- 
2.53.0



